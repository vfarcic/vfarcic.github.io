Pre-Workshop Instructions
=========================

Install [Virtual Box](https://www.virtualbox.org/), [Vagrant](https://www.vagrantup.com/) and [Git](https://git-scm.com/).

__If you are using Windows, please make sure that Git is configured to use "Checkout as-is". This can be accomplished during the setup by selecting the second or third option from the screen.__

![Windows Git Setup](git-windows.png)

__Vagrant tends to create problems with file permissions when linux VMs are created from a Windows host. If you are a Windows user, please follow the following instructions. After cloning the code, open the Vagrantfile in your text editor (I tend to use [NotePad++](https://notepad-plus-plus.org/)). Inside, you'll find the following two lines:__

Run the following commands:

```bash
vagrant plugin install vagrant-cachier

cd ..
git clone https://github.com/vfarcic/ms-lifecycle.git
cd ms-lifecycle

vagrant up cd
vagrant ssh cd -c "sudo chmod +x /vagrant/scripts/*"
vagrant ssh cd -c "sudo /vagrant/scripts/preload_cd_no_build.sh"

vagrant up swarm-master swarm-node-1 swarm-node-2
vagrant ssh cd -c "ansible-playbook /vagrant/ansible/swarm.yml -i /vagrant/ansible/hosts/prod"
vagrant ssh swarm-master -c "sudo /vagrant/scripts/preload_swarm.sh"
vagrant ssh swarm-node-1 -c "sudo /vagrant/scripts/preload_swarm_node.sh"
vagrant ssh swarm-node-2 -c "sudo /vagrant/scripts/preload_swarm_node.sh"

vagrant halt
```
