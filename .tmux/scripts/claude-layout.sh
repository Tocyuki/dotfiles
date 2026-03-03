#!/bin/bash
# Claude Code tmux layout manager
# Creates predefined pane layouts for Claude Code workflows.
#
# Usage: claude-layout.sh [dev|parallel|triple]

set -euo pipefail

layout="${1:-dev}"

case "$layout" in
  dev)
    # Main (70%) | Terminal (30%)
    # Left pane: Claude Code, Right pane: shell for tests/git
    tmux split-window -h -l 30%
    tmux select-pane -L
    tmux send-keys "claude" Enter
    ;;

  parallel)
    # Left (50%) | Right (50%)
    # Two Claude Code sessions side by side
    tmux split-window -h -l 50%
    tmux select-pane -L
    tmux send-keys "claude" Enter
    tmux select-pane -R
    tmux send-keys "claude" Enter
    ;;

  triple)
    # Main (50%) | Top-right (25%) + Bottom-right (25%)
    # Main: Claude Code, Top-right: review/test, Bottom-right: shell
    tmux split-window -h -l 40%
    tmux split-window -v -l 50%
    tmux select-pane -L
    tmux send-keys "claude" Enter
    ;;

  *)
    tmux display-message "Unknown layout: $layout (use: dev, parallel, triple)"
    exit 1
    ;;
esac
