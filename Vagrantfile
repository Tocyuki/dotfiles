# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.synced_folder ".", "/vagrant"

  config.vm.provision "ansible_local" do |ansible|
    ansible.install_mode = :default
    ansible.galaxy_role_file = '/vagrant/ansible/requirements.yml'
    ansible.galaxy_command = 'ansible-galaxy collection install -r %{role_file} --force'
    ansible.playbook = "/vagrant/ansible/main.yml"
    ansible.inventory_path = "/vagrant/ansible/hosts"
    ansible.extra_vars = { ansible_python_interpreter:"/usr/bin/python3" }
    ansible.limit = "clients"
  end
end
