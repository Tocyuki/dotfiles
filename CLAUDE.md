# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Language Preference

**日本語で対話してください** - Please interact in Japanese for all communications and explanations.

## Repository Overview

This is a dotfiles repository for macOS that uses Ansible for configuration management and aqua for tool version management. The setup is designed for a complete development environment with tools like Neovim, Ghostty terminal, tmux, and various CLI utilities.

## Common Commands

### Initial Setup
```bash
make init    # Install homebrew & ansible
make deploy  # Install all packages & link dotfiles
```

### Component-specific Setup
```bash
make install-brew      # Install brew packages only
make install-tools     # Install tools via aqua
make setup-neovim      # Setup Neovim configuration
make setup-ghostty     # Setup Ghostty terminal
make setup-tmux        # Setup tmux configuration
make setup-zsh         # Setup zsh shell
make dotfiles          # Link dotfiles only
```

### Development Commands
```bash
make help              # Show all available commands
actionlint             # Lint GitHub Actions workflows (via aqua)
```

## Architecture

### Configuration Management
- **Ansible**: Primary configuration management tool using playbooks in `ansible/` directory
- **Makefile**: Provides user-friendly commands that wrap Ansible playbooks
- **aqua.yaml**: Declarative CLI tool version management for development tools

### Key Components
- **ansible/main.yml**: Master playbook that orchestrates all setup tasks
- **ansible/*.yml**: Individual task files for different components (brew, neovim, ghostty, etc.)
- **.config/**: Contains application-specific configuration files
- **init.sh**: Bootstrap script for initial homebrew and Claude CLI installation

### Neovim Configuration
- Modern Lua-based configuration split across multiple files
- Plugin management structure in `.config/nvim/lua/plugins/`
- User-specific settings in `.config/nvim/lua/user/`

### Tool Management
All CLI tools are managed via aqua (aqua.yaml) including:
- Development tools (go, node, terraform, kubectl)
- Utilities (fzf, ripgrep, bat, jq, lazygit)
- Linters and formatters (actionlint, ruff, tflint)

### Testing
CI/CD runs installation tests on macOS via GitHub Actions to ensure the setup works correctly.