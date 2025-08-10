.PHONY: $(shell egrep -o ^[a-zA-Z_-]+: $(MAKEFILE_LIST) | sed 's/://')

PYTHON_INTERPRETER=`which python3`

help: ## Print this help
	@echo "Usage: make [target]"
	@echo
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init: ## Install homebrew & ansible for Mac
	@sh init.sh
	@brew install ansible
	@ansible-galaxy collection install community.general

deploy: ## Install all packages & Linking dotfiles
	@ansible-playbook -i localhost, -c local ansible/main.yml -K -e "ansible_python_interpreter=${PYTHON_INTERPRETER}"

install-brew: ## Install brew packages
	@ansible-playbook -i localhost, -c local ansible/main.yml --tags brew -K -e "ansible_python_interpreter=${PYTHON_INTERPRETER}"

install-tools: ## Install tools via aqua
	@ansible-playbook -i localhost, -c local ansible/main.yml --tags tools -e "ansible_python_interpreter=${PYTHON_INTERPRETER}"

install-fonts: ## Install fonts
	@ansible-playbook -i localhost, -c local ansible/main.yml --tags fonts -e "ansible_python_interpreter=${PYTHON_INTERPRETER}"

setup-zsh: ## Setup zsh
	@ansible-playbook -i localhost, -c local ansible/main.yml --tags zsh -e "ansible_python_interpreter=${PYTHON_INTERPRETER}"

setup-ghostty: ## Setup ghostty
	@ansible-playbook -i localhost, -c local ansible/main.yml --tags ghostty -e "ansible_python_interpreter=${PYTHON_INTERPRETER}"

setup-tmux: ## Setup tmux
	@ansible-playbook -i localhost, -c local ansible/main.yml --tags tmux -e "ansible_python_interpreter=${PYTHON_INTERPRETER}"

setup-neovim: ## Setup neovim
	@ansible-playbook -i localhost, -c local ansible/main.yml --tags neovim -e "ansible_python_interpreter=${PYTHON_INTERPRETER}"

dotfiles: ## Linking dotfils
	@ansible-playbook -i localhost, -c local ansible/main.yml --tags dotfiles -e "ansible_python_interpreter=${PYTHON_INTERPRETER}"

