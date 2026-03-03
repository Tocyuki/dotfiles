#!/bin/bash
# Claude Code tmux popup launcher
# Provides a menu to launch Claude Code in different modes.

set -euo pipefail

readonly BLUE='\033[34m'
readonly CYAN='\033[36m'
readonly DIM='\033[2m'
readonly BOLD='\033[1m'
readonly RESET='\033[0m'

if ! command -v claude &>/dev/null; then
  printf "\n  Error: claude command not found\n"
  printf "  Install: npm install -g @anthropic-ai/claude-code\n"
  read -r -n 1
  exit 1
fi

clear
printf "${BOLD}${BLUE}"
cat << 'BANNER'
   _____ _                 _
  / ____| |               | |
 | |    | | __ _ _   _  __| | ___
 | |    | |/ _` | | | |/ _` |/ _ \
 | |____| | (_| | |_| | (_| |  __/
  \_____|_|\__,_|\__,_|\__,_|\___|

BANNER
printf "${RESET}\n"

printf "${BOLD} Claude Code Launcher${RESET}\n"
printf "${DIM}─────────────────────────────────${RESET}\n\n"
printf "  ${CYAN}1)${RESET} claude            ${DIM}対話モード${RESET}\n"
printf "  ${CYAN}2)${RESET} claude --resume   ${DIM}セッション復帰${RESET}\n"
printf "  ${CYAN}3)${RESET} claude -p \"...\"   ${DIM}ワンショットクエリ${RESET}\n"
printf "  ${CYAN}q)${RESET} quit              ${DIM}キャンセル${RESET}\n"
printf "\n"

read -r -p "  Select [1-3/q]: " choice

case "$choice" in
  1)
    exec claude
    ;;
  2)
    exec claude --resume
    ;;
  3)
    printf "\n"
    read -r -p "  Prompt: " prompt
    if [[ -n "$prompt" ]]; then
      claude -p "$prompt"
      printf "\n${DIM}Press any key to close...${RESET}"
      read -r -n 1
    fi
    ;;
  q|Q)
    exit 0
    ;;
  *)
    printf "\n  ${DIM}Invalid selection${RESET}\n"
    exit 1
    ;;
esac
