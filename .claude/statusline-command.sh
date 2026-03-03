#!/usr/bin/env bash

# Claude Code Status Line v2
# Components (priority order):
#   Model │ Context Bar │ Project │ Git │ Cost │ Agent │ Duration │ Diff │ Style │ Vim

set -euo pipefail

# ── Constants ────────────────────────────────────────────
readonly SEP=" │ "
readonly SEP_LEN=3  # Approximate display width of separator
readonly BAR_WIDTH=10

# ── Read JSON input (single jq call for performance) ─────
input=$(cat)

_raw=$(echo "$input" | jq -r '[
  (.model.display_name // "Claude"),
  (.context_window.remaining_percentage // ""),
  (.context_window.context_window_size // 200000),
  (.workspace.current_dir // ""),
  (.workspace.project_dir // ""),
  (.cost.total_cost_usd // 0),
  (.cost.total_duration_ms // 0),
  (.cost.total_lines_added // 0),
  (.cost.total_lines_removed // 0),
  (.output_style.name // ""),
  (.vim.mode // ""),
  (.agent.name // "")
] | join("\u001f")')

IFS=$'\x1f' read -r -a _f <<< "$_raw"

model="${_f[0]:-}"
remaining="${_f[1]:-}"
ctx_size="${_f[2]:-200000}"
cwd="${_f[3]:-}"
project_dir="${_f[4]:-}"
cost_usd="${_f[5]:-0}"
duration_ms="${_f[6]:-0}"
lines_added="${_f[7]:-0}"
lines_removed="${_f[8]:-0}"
output_style="${_f[9]:-}"
vim_mode="${_f[10]:-}"
agent_name="${_f[11]:-}"

# ── Terminal width detection ─────────────────────────────
_tput_cols=$(tput cols 2>/dev/null || true)
if [[ "${_tput_cols:-}" =~ ^[0-9]+$ ]] && [[ "$_tput_cols" -gt 0 ]]; then
  term_width=${COLUMNS:-$_tput_cols}
else
  term_width=${COLUMNS:-120}
fi

# ── Helper: build progress bar ───────────────────────────
_build_bar() {
  local pct_int="$1"
  local filled=$(( (pct_int * BAR_WIDTH + 99) / 100 ))
  [[ "$filled" -gt "$BAR_WIDTH" ]] && filled=$BAR_WIDTH
  [[ "$filled" -lt 0 ]] && filled=0
  local empty=$(( BAR_WIDTH - filled ))

  local bar=""
  for ((i = 0; i < filled; i++)); do bar+="█"; done
  for ((i = 0; i < empty; i++)); do bar+="░"; done
  echo "$bar"
}

# ── Component builders ───────────────────────────────────

build_model() {
  local name="$1"
  local compact="$2"

  local short
  short=$(echo "$name" | sed 's/Claude //' | sed 's/ /-/g')

  if [[ "$compact" == "true" ]]; then
    echo "$short" | grep -oE '[0-9]+\.[0-9]+' || echo "$short"
  else
    echo "$short"
  fi
}

build_context() {
  local pct="$1"
  local style="$2"
  local ctx_sz="$3"

  [[ -z "$pct" ]] && return 0

  local pct_int
  pct_int=$(printf "%.0f" "$pct")

  local warn=""
  if [[ "$pct_int" -le 20 ]]; then
    warn="⚠ "
  fi

  case "$style" in
    full)
      local bar
      bar=$(_build_bar "$pct_int")
      local remaining_tokens
      remaining_tokens=$(awk -v p="$pct" -v s="$ctx_sz" 'BEGIN { printf "%.0f", p / 100 * s / 1000 }')
      echo "${warn}[${bar}] ${pct_int}% (${remaining_tokens}k)"
      ;;
    compact)
      local bar
      bar=$(_build_bar "$pct_int")
      echo "${warn}${bar} ${pct_int}%"
      ;;
    minimal)
      echo "${warn}${pct_int}%"
      ;;
  esac
}

build_project() {
  local cwd_path="$1"
  local proj_path="$2"

  [[ -z "$cwd_path" ]] && return 0

  if [[ -n "$proj_path" ]] && [[ "$proj_path" != "$cwd_path" ]]; then
    local proj_name
    proj_name=$(basename "$proj_path")
    local rel
    rel="${cwd_path#"$proj_path"}"
    rel="${rel#/}"
    if [[ -n "$rel" ]]; then
      echo "${proj_name}/${rel}"
    else
      echo "${proj_name}"
    fi
  else
    basename "${cwd_path:-/}"
  fi
}

build_git() {
  local cwd_path="$1"

  [[ -z "$cwd_path" ]] && return 0

  local status_output
  status_output=$(git -C "$cwd_path" --no-optional-locks status --porcelain=v2 --branch 2>/dev/null) || return 0

  local branch
  branch=$(printf '%s\n' "$status_output" | awk '/^# branch\.head/ { print $3 }')
  [[ -z "$branch" ]] && branch="detached"

  local indicators=""
  if printf '%s\n' "$status_output" | grep -qE '^[12] .M'; then
    indicators+="*"
  fi
  if printf '%s\n' "$status_output" | grep -qE '^[12] [MADRC]'; then
    indicators+="+"
  fi
  if printf '%s\n' "$status_output" | grep -q '^?'; then
    indicators+="?"
  fi

  if [[ -n "$indicators" ]]; then
    echo "${branch} ${indicators}"
  else
    echo "${branch}"
  fi
}

build_cost() {
  local usd="$1"

  if [[ -z "$usd" ]] || [[ "$usd" == "0" ]]; then
    return
  fi

  awk -v cost="$usd" 'BEGIN {
    c = cost + 0
    if (c < 0.01) {
      printf "< ¢1"
    } else if (c >= 1.0) {
      printf "$%.2f", c
    } else {
      printf "$%.3f", c
    }
  }'
}

build_duration() {
  local ms="$1"

  if [[ -z "$ms" ]] || [[ "$ms" == "0" ]]; then
    return
  fi

  awk -v ms="$ms" 'BEGIN {
    s = int(ms / 1000)
    h = int(s / 3600)
    m = int((s % 3600) / 60)
    sec = s % 60
    if (h > 0) {
      if (m > 0) printf "⏱ %dh%dm", h, m
      else printf "⏱ %dh", h
    } else if (m > 0) {
      if (sec > 0) printf "⏱ %dm%ds", m, sec
      else printf "⏱ %dm", m
    } else {
      printf "⏱ %ds", sec
    }
  }'
}

build_diff() {
  local added="$1"
  local removed="$2"

  if [[ "$added" == "0" ]] && [[ "$removed" == "0" ]]; then return 0; fi

  awk -v a="$added" -v r="$removed" 'BEGIN {
    if (a + 0 >= 1000 || r + 0 >= 1000) {
      printf "+%.1fk/-%.1fk", (a + 0) / 1000, (r + 0) / 1000
    } else {
      printf "+%d/-%d", a + 0, r + 0
    }
  }'
}

build_style() {
  local style="$1"

  if [[ -z "$style" ]] || [[ "$style" == "default" ]]; then
    return
  fi

  echo "$style"
}

build_vim() {
  local mode="$1"

  [[ -z "$mode" ]] && return 0

  echo "-- ${mode} --"
}

build_agent() {
  local name="$1"

  [[ -z "$name" ]] && return 0

  echo "agent:${name}"
}

# ── Width-adaptive assembly ──────────────────────────────

if [[ "$term_width" -ge 100 ]]; then
  ctx_style="full"
elif [[ "$term_width" -ge 80 ]]; then
  ctx_style="compact"
else
  ctx_style="minimal"
fi

model_compact="false"
[[ "$term_width" -lt 80 ]] && model_compact="true"

# Generate all components
c_model=$(build_model "$model" "$model_compact")
c_context=$(build_context "$remaining" "$ctx_style" "$ctx_size")
c_project=$(build_project "$cwd" "$project_dir")
c_git=$(build_git "$cwd")
c_cost=$(build_cost "$cost_usd")
c_agent=$(build_agent "$agent_name")
c_duration=$(build_duration "$duration_ms")
c_diff=$(build_diff "$lines_added" "$lines_removed")
c_style=$(build_style "$output_style")
c_vim=$(build_vim "$vim_mode")

# ── Write state for tmux integration ────────────────────
# Atomic write (mktemp + mv) to avoid tmux reading partial JSON.
# jq -n --arg for safe JSON escaping (branch names may contain quotes).
{
  tmp_state=$(mktemp "$HOME/.claude/.tmux-state.XXXXXX")
  jq -n \
    --arg model "$c_model" \
    --arg context_pct "$remaining" \
    --arg project "$c_project" \
    --arg git "$c_git" \
    --arg agent "$c_agent" \
    --arg cost "$c_cost" \
    '{model: $model, context_pct: $context_pct, project: $project, git: $git, agent: $agent, cost: $cost}' \
    > "$tmp_state" && mv "$tmp_state" "$HOME/.claude/.tmux-state"
} 2>/dev/null &

# Priority-ordered component list (highest priority first)
all_components=(
  "$c_model"
  "$c_context"
  "$c_project"
  "$c_git"
  "$c_cost"
  "$c_agent"
  "$c_duration"
  "$c_diff"
  "$c_style"
  "$c_vim"
)

# Build output respecting terminal width
output=""
output_len=0

for comp in "${all_components[@]}"; do
  [[ -z "$comp" ]] && continue

  comp_len=${#comp}

  if [[ -z "$output" ]]; then
    output="$comp"
    output_len=$comp_len
  else
    new_len=$(( output_len + SEP_LEN + comp_len ))
    if [[ "$new_len" -le "$term_width" ]]; then
      output+="${SEP}${comp}"
      output_len=$new_len
    fi
  fi
done

printf "%s" "$output"
