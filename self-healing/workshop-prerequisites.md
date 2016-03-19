Self-Healing Systems Workshop
=============================

Prerequisites
-------------

* Git
* Vagrant

Pre-Workshop Preparation
------------------------

```bash
git clone https://github.com/vfarcic/ms-lifecycle

cd ms-lifecycle

vagrant up cd swarm-master swarm-node-1 swarm-node-2

vagrant ssh cd -c "sudo chmod +x /vagrant/scripts/*"

vagrant ssh cd -c "sudo /vagrant/scripts/preload_cd.sh"

vagrant ssh cd -c "ansible-playbook /vagrant/ansible/swarm.yml -i /vagrant/ansible/hosts/prod"

vagrant ssh swarm-master -c "/vagrant/scripts/preload_swarm.sh"

vagrant ssh swarm-node-1 -c "/vagrant/scripts/preload_swarm_node.sh"

vagrant ssh swarm-node-2 -c "/vagrant/scripts/preload_swarm_node.sh"

vagrant halt
```