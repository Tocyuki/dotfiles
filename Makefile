.PHONY: $(shell egrep -o ^[a-zA-Z_-]+: $(MAKEFILE_LIST) | sed 's/://')

PYTHON_INTERPRETER=`which python3`

help: ## Print this help
	@echo "Usage: make [target]"
	@echo
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init-mac: ## Install homebrew & ansible for Mac
	@/bin/bash -c "`curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh`"
	@echo '# Set ATH, MANPATH, etc., for Homebrew.' >> /Users/`users`/.zprofile
	@echo 'eval "`/opt/homebrew/bin/brew shellenv`"' >> /Users/`users`/.zprofile
	@eval "`/opt/homebrew/bin/brew shellenv`"
	@brew install ansible
	@ansible-galaxy collection install community.general

init-ubuntu: ## Install homebrew & ansible for Ubuntu
	@sudo apt -y update
	@sudo apt -y install make
	@sudo apt -y install software-properties-common
	@sudo apt-add-repository --yes --update ppa:ansible/ansible
	@sudo apt -y install ansible
	@sudo ansible-galaxy collection install community.general

deploy: ## Deploy all playbook
	@ansible-playbook -i localhost, -c local ansible/main.yml -K -e "ansible_python_interpreter=${PYTHON_INTERPRETER}"

dotfiles: ## Linking dotfils
	@ansible-playbook -i localhost, -c local ansible/main.yml --tags dotfiles -e "ansible_python_interpreter=${PYTHON_INTERPRETER}"
