Pre-Workshop Instructions
=========================

Install [Virtual Box](https://www.virtualbox.org/), [Vagrant](https://www.vagrantup.com/) and [Git](https://git-scm.com/).

__If you are using Windows, please make sure that Git is configured to use "Checkout as-is". This can be accomplished during the setup by selecting the second or third option from the screen.__

![Windows Git Setup](git-windows.png)

__Vagrant tends to create problems with file permissions when linux VMs are created from a Windows host. If you are a Windows user, please follow the following instructions. After cloning the code, open the Vagrantfile in your text editor (I tend to use [NotePad++](https://notepad-plus-plus.org/)). Inside, you'll find the following two lines:__

```
  config.vm.synced_folder ".", "/vagrant"
  # config.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=700,fmode=600"]
```

*Please comment the first and uncomment the second line. The end result should be as follows.*

```
  # config.vm.synced_folder ".", "/vagrant"
  config.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=700,fmode=600"]
```

*This process of changing synced_folder in the Vagrantfile should be repeated every time we clone some code from the GitHub repository into a Windows host. Also, if you do not have SSH installed, please make sure that [PATH_TO_GIT]\bin is added to your PATH.*

Run the following commands:

```bash
vagrant plugin install vagrant-cachier

git clone https://github.com/vfarcic/books-ms.git

cd books-ms

vagrant up dev
vagrant ssh dev -c "sudo chmod +x /vagrant/*.sh"
vagrant ssh dev -c "sudo /vagrant/preload.sh"
vagrant halt dev

cd ..
git clone https://github.com/vfarcic/ms-lifecycle.git
cd ms-lifecycle

vagrant up cd
vagrant ssh cd -c "sudo chmod +x /vagrant/scripts/*"
vagrant ssh cd -c "sudo /vagrant/scripts/preload_cd.sh"

vagrant up prod
vagrant ssh cd -c "ansible-playbook /vagrant/ansible/prod.yml -i /vagrant/ansible/hosts/prod"
vagrant ssh prod -c "sudo /vagrant/scripts/preload_prod.sh"
vagrant halt prod

vagrant up serv-disc-01 serv-disc-02 serv-disc-03
vagrant ssh cd -c "ansible-playbook /vagrant/ansible/consul.yml -i /vagrant/ansible/hosts/serv-disc"
vagrant ssh serv-disc-01 -c "sudo /vagrant/scripts/preload_serv_disc.sh"
vagrant ssh serv-disc-02 -c "sudo /vagrant/scripts/preload_serv_disc.sh"
vagrant ssh serv-disc-03 -c "sudo /vagrant/scripts/preload_serv_disc.sh"
vagrant halt serv-disc-01 serv-disc-02 serv-disc-03

vagrant up proxy
vagrant ssh cd -c "ansible-playbook /vagrant/ansible/docker.yml -i /vagrant/ansible/hosts/proxy"
vagrant ssh proxy -c "sudo /vagrant/scripts/preload_proxy.sh"
vagrant halt proxy

vagrant up swarm-master swarm-node-1 swarm-node-2
vagrant ssh cd -c "ansible-playbook /vagrant/ansible/swarm.yml -i /vagrant/ansible/hosts/prod"
vagrant ssh swarm-master -c "sudo /vagrant/scripts/preload_swarm.sh"
vagrant ssh swarm-node-1 -c "sudo /vagrant/scripts/preload_swarm_node.sh"
vagrant ssh swarm-node-2 -c "sudo /vagrant/scripts/preload_swarm_node.sh"
vagrant halt swarm-master swarm-node-1 swarm-node-2

vagrant halt cd
```
