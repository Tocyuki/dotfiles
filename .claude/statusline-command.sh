#!/bin/bash

# Claude Code Status Line - Optimized for development workflow
# Shows: Model | Context | Project/Dir | Git Status | Vim Mode | Agent

# Read JSON input
input=$(cat)

# Extract values
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // ""')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir // ""')
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')
agent_name=$(echo "$input" | jq -r '.agent.name // empty')

# Build status line components
components=()

# 1. Model name (shortened)
model_short=$(echo "$model" | sed 's/Claude //' | sed 's/ /-/g')
components+=("${model_short}")

# 2. Context remaining (with color indicator)
if [ -n "$remaining" ]; then
  # Convert to integer for comparison
  remaining_int=$(printf "%.0f" "$remaining")

  if [ "$remaining_int" -gt 50 ]; then
    context_indicator="●"  # Good
  elif [ "$remaining_int" -gt 20 ]; then
    context_indicator="◐"  # Warning
  else
    context_indicator="○"  # Critical
  fi

  components+=("${context_indicator} ${remaining}%")
fi

# 3. Directory info (show project name or current dir basename)
if [ -n "$project_dir" ] && [ "$project_dir" != "$cwd" ]; then
  # In a subdirectory of project
  project_name=$(basename "$project_dir")
  rel_path=$(echo "$cwd" | sed "s|$project_dir||" | sed 's|^/||')
  if [ -n "$rel_path" ]; then
    components+=("${project_name}/${rel_path}")
  else
    components+=("${project_name}")
  fi
else
  # Not in a project or at project root
  dir_name=$(basename "$cwd")
  components+=("${dir_name}")
fi

# 4. Git status (branch + status indicators)
if [ -d "$cwd/.git" ] || git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  # Get current branch
  branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null || echo "detached")

  # Get git status indicators
  git_status=""

  # Check for uncommitted changes
  if ! git -C "$cwd" --no-optional-locks diff --quiet 2>/dev/null; then
    git_status+="*"  # Modified files
  fi

  # Check for staged changes
  if ! git -C "$cwd" --no-optional-locks diff --cached --quiet 2>/dev/null; then
    git_status+="+"  # Staged files
  fi

  # Check for untracked files
  if [ -n "$(git -C "$cwd" --no-optional-locks ls-files --others --exclude-standard 2>/dev/null)" ]; then
    git_status+="?"  # Untracked files
  fi

  if [ -n "$git_status" ]; then
    components+=("git:${branch} ${git_status}")
  else
    components+=("git:${branch}")
  fi
fi

# 5. Vim mode (if enabled)
if [ -n "$vim_mode" ]; then
  case "$vim_mode" in
    INSERT)
      vim_indicator="-- INSERT --"
      ;;
    NORMAL)
      vim_indicator="-- NORMAL --"
      ;;
    *)
      vim_indicator="-- ${vim_mode} --"
      ;;
  esac
  components+=("${vim_indicator}")
fi

# 6. Agent info (if running in agent mode)
if [ -n "$agent_name" ]; then
  components+=("agent:${agent_name}")
fi

# Join components with separator
separator=" | "
printf "%s" "${components[0]}"
for i in "${components[@]:1}"; do
  printf "%s%s" "$separator" "$i"
done
