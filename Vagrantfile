# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-18.04"
  config.vm.synced_folder ".", "/vagrant"

  config.vm.provision :shell, inline: <<-EOT
    cd /vagrant
    sh setup.sh
  EOT
end
