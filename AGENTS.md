# Repository Guidelines

## Project Structure & Module Organization
Repository root holds automation entry points: `Makefile` for common tasks, `ansible/` for task files (`main.yml` orchestrates component playbooks), and `init.sh` for first-time bootstrap. Dotfiles live beside their targets (for example `.zshrc`, `.tmux.conf`, `.claude/settings.json`) and are linked into `$HOME` by Ansible. Application configs stay in `.config/` (e.g. `nvim/`, `ghostty/`, `lazygit/`), while usage docs and walkthroughs sit in `docs/`.

## Build, Test, and Development Commands
Run `make help` to list targets. Use `make init` once per machine to install Homebrew and Ansible, followed by `make deploy` to apply the full environment. Component-specific refreshes (e.g. `make setup-neovim`, `make setup-zsh`) re-run only the relevant Ansible tags. `make install-tools` triggers aqua to install CLI tools; `actionlint` (provided via aqua) validates GitHub Actions locally. For ad-hoc checks you can run `ansible-playbook -i localhost, -c local ansible/main.yml --check`.

## Coding Style & Naming Conventions
YAML files use two-space indentation and lowercase-with-dashes keys, matching existing playbooks. Lua sources under `.config/nvim` follow two-space indentation and snake_case locals; keep modules grouped by domain (`user/` for core settings, `plugins/` for plugin specs). Shell scripts stay POSIX-compatible with `set -eu`, and aliases or environment variables go in `.zshrc` using uppercase names. Prefer ASCII in configuration comments unless Japanese context already exists.

## Testing Guidelines
Automation is validated through the `Test` GitHub Actions workflow and `actionlint` job; ensure both stay green. Before opening a PR, run `make deploy` or the narrower target you touched plus `actionlint`. New tooling or playbook logic should include idempotency checks (`--check` mode) and document verification steps in `docs/` if user interaction changes.

## Commit & Pull Request Guidelines
Follow the existing concise, imperative commit style (`add e1s installation`, `update dotfiles`). Reference related issues in the message body when applicable. Pull requests should summarize scope, list manual verification (`make` targets, screenshots if UI-facing), and call out any secrets or machine-specific prerequisites. Keep diffs reproducible by updating Ansible tasks and associated dotfiles together.

## Security & Configuration Tips
Avoid committing machine-specific secrets; use environment variables or personal vaults instead. When adding packages to `ansible/brew.yml` or `aqua.yaml`, confirm they are widely trusted and note any licenses or login requirements in the PR description. Update `.claude/settings.json` only when access policies change, and highlight those adjustments to reviewers.
