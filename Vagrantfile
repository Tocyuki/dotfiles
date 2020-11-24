# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.synced_folder ".", "/vagrant"

  config.vm.provision "ansible_local" do |ansible|
    ansible.install_mode = :pip
    ansible.playbook = "/vagrant/ansible/main.yml"
    ansible.inventory_path = "/vagrant/ansible/hosts"
    ansible.limit = "clients"
  end
end
