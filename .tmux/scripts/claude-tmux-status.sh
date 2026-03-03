#!/bin/bash
# Claude Code tmux statusbar integration
# Reads ~/.claude/.tmux-state (written by statusline-command.sh) and outputs
# a formatted status string with tokyo-night theme colors.

set -euo pipefail

readonly STATE_FILE="$HOME/.claude/.tmux-state"
readonly STALE_SECONDS=90

# ── Color constants (tokyo-night) ────────────────
readonly GREEN="#9ece6a"
readonly YELLOW="#e0af68"
readonly RED="#f7768e"
readonly BLUE="#7aa2f7"
readonly RESET_FG="#a9b1d6"

# ── Check state file existence and freshness ─────
if [[ ! -f "$STATE_FILE" ]]; then
  exit 0
fi

# Get file age in seconds (macOS stat)
file_mtime=$(stat -f %m "$STATE_FILE" 2>/dev/null || echo 0)
now=$(date +%s)
age=$(( now - file_mtime ))

if [[ "$age" -gt "$STALE_SECONDS" ]]; then
  exit 0
fi

# ── Parse state JSON (single jq call) ────────────
_raw=$(jq -r '[(.model // ""), (.context_pct // ""), (.agent // "")] | join("\u001f")' "$STATE_FILE" 2>/dev/null) || exit 0
IFS=$'\x1f' read -r model context_pct agent <<< "$_raw"

if [[ -z "$model" ]]; then
  exit 0
fi

# ── Context indicator with color ─────────────────
ctx_display=""
if [[ -n "$context_pct" ]]; then
  pct_int=$(printf "%.0f" "$context_pct")

  if [[ "$pct_int" -gt 50 ]]; then
    ctx_display="#[fg=${GREEN}]● ${pct_int}%%"
  elif [[ "$pct_int" -gt 20 ]]; then
    ctx_display="#[fg=${YELLOW}]◐ ${pct_int}%%"
  else
    ctx_display="#[fg=${RED}]⚠ ${pct_int}%%"
  fi
fi

# ── Agent indicator ──────────────────────────────
agent_display=""
if [[ -n "$agent" ]]; then
  agent_display=" #[fg=${RESET_FG}]${agent}"
fi

# ── Assemble output ──────────────────────────────
printf "#[fg=${BLUE}] %s %s%s #[default]" "$model" "$ctx_display" "$agent_display"
