# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network :forwarded_port, host: 8080, guest: 8080
  config.vm.synced_folder ".", "/vagrant"
  config.vm.provider "virtualbox" do |v|
    v.name = "cd-workshop"
    v.memory = 2048
  end
  config.vm.provision "shell", path: "bootstrap.sh"
  config.vm.define :cd do |cd|
    cd.vm.provision :shell, inline: 'ansible-playbook /vagrant/ansible/cd.yml -c local'
  end
end