#!/usr/bin/env bash

set +e

git clone https://github.com/vfarcic/ms-lifecycle.git

cd ms-lifecycle

set -e

vagrant up cd swarm-master swarm-node-1 swarm-node-2

vagrant ssh cd -c "ansible-playbook /vagrant/ansible/swarm.yml -i /vagrant/ansible/hosts/prod"

set +e

vagrant ssh cd -c "git clone https://github.com/vfarcic/go-demo.git"

set -e

vagrant ssh cd -c "cd go-demo && docker-compose -f docker-compose-test.yml run --rm unit"

vagrant ssh cd -c "cd go-demo && docker build -t vfarcic/go-demo ."

vagrant ssh cd -c "cd go-demo && docker-compose pull"

vagrant ssh cd -c "cd go-demo && docker-compose -H tcp://swarm-master:2375 pull"

vagrant ssh cd -c "ansible-playbook /vagrant/ansible/jenkins-node-swarm.yml -i /vagrant/ansible/hosts/prod"

vagrant ssh cd -c "ansible-playbook /vagrant/ansible/jenkins.yml -c local"

vagrant ssh cd -c "git clone http://10.100.198.200:8080/workflowLibs.git /tmp/workflowLibs"

vagrant ssh cd -c "cd /tmp/workflowLibs && git checkout -b master"

vagrant ssh cd -c "mkdir /tmp/workflowLibs/vars"

vagrant ssh cd -c "cp ~/go-demo/jenkins/vars/dockerFlowWorkshop.groovy /tmp/workflowLibs/vars/dockerFlow.groovy"

vagrant ssh cd -c "git config --global user.name \"vfarcic\""

vagrant ssh cd -c "cd /tmp/workflowLibs && git add --all && git commit -a -m \"Docker Flow\""

vagrant ssh cd -c "cd /tmp/workflowLibs && git push --set-upstream origin master"

vagrant ssh cd -c "docker pull vfarcic/docker-flow-proxy"

vagrant halt