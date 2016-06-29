#!/usr/bin/env bash

set +e

git clone https://github.com/vfarcic/ms-lifecycle.git

set -e

cd ms-lifecycle

vagrant up --provision cd swarm-master swarm-node-1 swarm-node-2

vagrant ssh cd -c "ansible-playbook /vagrant/ansible/swarm.yml -i /vagrant/ansible/hosts/prod"

vagrant ssh cd -c "ansible-playbook /vagrant/ansible/jenkins-node-swarm.yml -i /vagrant/ansible/hosts/prod"

vagrant ssh cd -c "ansible-playbook /vagrant/ansible/jenkins.yml -c local"

vagrant ssh cd -c "git clone https://github.com/vfarcic/go-demo.git"

vagrant ssh cd -c "docker pull vfarcic/docker-flow-proxy"

vagrant ssh cd -c "cd go-demo && docker-compose -f docker-compose-test.yml run --rm unit"

vagrant ssh cd -c "cd go-demo && docker build -t vfarcic/go-demo ."

vagrant ssh cd -c "cd go-demo && docker-compose -H tcp://swarm-master:2375 pull"

vagrant halt