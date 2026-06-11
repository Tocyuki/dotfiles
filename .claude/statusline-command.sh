#!/usr/bin/env bash

# Claude Code Status Line v3
# Components:
#   Model │ Context Bar │ Project │ Git │ Cost │ Agent │ Duration │ Diff │ Style
# v3: ANSI colors applied at assembly time only, so the tmux state
#     file keeps plain-text values.

set -euo pipefail

# ── Constants ────────────────────────────────────────────
readonly BAR_WIDTH=10

# ── Colors (p10k-like) ───────────────────────────────────
readonly C_RESET=$'\033[0m'
readonly C_CYAN=$'\033[36m'
readonly C_WHITE=$'\033[97m'
readonly C_MAGENTA=$'\033[35m'
readonly C_YELLOW=$'\033[33m'
readonly C_GREEN=$'\033[32m'
readonly C_RED=$'\033[31m'
readonly C_DIM=$'\033[90m'

readonly SEP="${C_DIM} │ ${C_RESET}"

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
agent_name="${_f[10]:-}"

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

build_agent() {
  local name="$1"

  [[ -z "$name" ]] && return 0

  echo "agent:${name}"
}

# ── Assembly ─────────────────────────────────────────────

# Generate all components
c_model=$(build_model "$model" "false")
c_context=$(build_context "$remaining" "full" "$ctx_size")
c_project=$(build_project "$cwd" "$project_dir")
c_git=$(build_git "$cwd")
c_cost=$(build_cost "$cost_usd")
c_agent=$(build_agent "$agent_name")
c_duration=$(build_duration "$duration_ms")
c_diff=$(build_diff "$lines_added" "$lines_removed")
c_style=$(build_style "$output_style")

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

# Context bar color: green → yellow (≤50% remaining) → red (≤20% remaining)
ctx_color="$C_GREEN"
if [[ -n "$remaining" ]]; then
  _pct_int=$(printf "%.0f" "$remaining")
  if [[ "$_pct_int" -le 20 ]]; then
    ctx_color="$C_RED"
  elif [[ "$_pct_int" -le 50 ]]; then
    ctx_color="$C_YELLOW"
  fi
fi

# Component list (paired with colors, applied here only — builders and
# the tmux state stay plain-text)
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
)
all_colors=(
  "$C_CYAN"
  "$ctx_color"
  "$C_WHITE"
  "$C_MAGENTA"
  "$C_YELLOW"
  "$C_CYAN"
  "$C_DIM"
  "$C_DIM"
  "$C_DIM"
)

# Join all non-empty components with separator
output=""
for i in "${!all_components[@]}"; do
  comp="${all_components[$i]}"
  [[ -z "$comp" ]] && continue
  colored="${all_colors[$i]}${comp}${C_RESET}"
  if [[ -z "$output" ]]; then
    output="$colored"
  else
    output+="${SEP}${colored}"
  fi
done

printf "%s" "$output"
