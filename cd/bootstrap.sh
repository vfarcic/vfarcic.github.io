#!/bin/bash

echo "Installing Ansible..."
apt-get install software-properties-common
apt-add-repository ppa:ansible/ansible
apt-get update
apt-get install -y ansible
cd /vagrant/ansible