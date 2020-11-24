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

