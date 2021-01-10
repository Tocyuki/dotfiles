init.mac:
	@/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	@brew install ansible@2.8

deploy:
	@ansible-playbook -i localhost, -c local ansible/main.yml -K

deploy.package:
	@ansible-playbook -i localhost, -c local ansible/main.yml --tags package

deploy.fish:
	@ansible-playbook -i localhost, -c local ansible/main.yml -K --tags fish

deploy.vim:
	@ansible-playbook -i localhost, -c local ansible/main.yml --tags vim

deploy.tmux:
	@ansible-playbook -i localhost, -c local ansible/main.yml --tags tmux

deploy.dotfiles:
	@ansible-playbook -i localhost, -c local ansible/main.yml --tags dotfiles

