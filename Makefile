.PHONY: $(shell egrep -o ^[a-zA-Z_-]+: $(MAKEFILE_LIST) | sed 's/://')

help: ## Print this help
	@echo "Usage: make [target]"
	@echo
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init: ## Install homebrew & ansible
	@/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	@brew install ansible
	@ansible-galaxy collection install community.general

deploy: ## Deploy all playbook
	@ansible-playbook -i localhost, -c local ansible/main.yml -K

package: ## Install require packages
	@ansible-playbook -i localhost, -c local ansible/main.yml --tags package

fish: ## Install fish
	@ansible-playbook -i localhost, -c local ansible/main.yml -K --tags fish

tmux: ## Install tmux
	@ansible-playbook -i localhost, -c local ansible/main.yml --tags tmux

dotfiles: ## Linking dotfils
	@ansible-playbook -i localhost, -c local ansible/main.yml --tags dotfiles

