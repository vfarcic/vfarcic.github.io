Title
=====

Microservices Lifecycle Workshop
--------------------------------

Co-Presenter
============

Featured Participants
=====================

Track
=====

Architecture

Session Type
============

Talk

Audience Level
==============

Learning

Room Setup
==========

Theater

Duration
========

6-8 hours

Keywords
========

Architecture, microservices, continuous delivery, continuous deployment, containers, Docker

Abstract
========

Microservices are becoming more and more popular and, as with every other new trend, often implemented without enough experience. Idea behind them easy to explain. Brake monolithic application into smaller independent services. That's it. That is what many think microservices are about. However, implementation is much harder to master. There are many things to consider when embarking down this path. How do we organize microservices? Which technologies to use and how? Should they be mutable or not? How to test them? How to deploy them? How to create scalable and fault tolerant systems? Self-healing, zero-downtime and logging? How should the teams be organized? Today's successful implementations of microservices require all those and many other questions to be answered. It's not only about splitting things into smaller pieces. The whole development ecosystem needs to be changed and we need to take a hard look at the microservices development lifecycle.

This workshop will go through the whole **microservices development lifecycle**. We'll start from the very beginning. We'll define and design architecture. From there on we'll move from requirements, technological choices and development environment setup, through coding and testing all the way until the final deployment to production. We won't stop there. Once our new services are up and running we'll see how to maintain them, scale them depending on resource utilization and response time, recuperate them in case of failures and create central monitoring and notifications system. We'll try to balance the need for creative manual work and the need to automate as much of the process as possible.

This will be a journey through all the aspects of the lives of microservices and everything that surrounds them. We'll see how microservices fit into continuous deployment and immutable containers concepts and why the best results are obtained when those three are combined into one unique framework.

During the workshop we'll explore tools Docker, Docker Swarm, Docker Compose, Ansible, Consul, etcd, confd, Registrator, nginx, HAProxy, ElasticSearch, LogStash, Kibana, and so on.

Learning Outcomes
=================

* Microservices architecture
* Immutable deployments with Docker containers
* Continuous deployment
* Auto-discovery
* Failure recuperation
* Zero-downtime
* Automated self-healing
* Scaling

Prerequisite Knowledge
======================

Information for Review Team
===========================

Presentation History
====================

Presentation Sample
===================

Bio
===

Viktor Farcic is a Software Architect at everis.

He coded using plethora of languages starting with Pascal (yes, he is old), Basic (before it got Visual prefix), ASP (before it got .Net suffix), C, C++, Perl, Python, ASP.Net, Visual Basic, C#, JavaScript, etc. He never worked with Fortran. His current favorites are **Scala** and **JavaScript** even though most of his office hours are spent with **Java**.

His big passions are Microservices, Continuous Deployment and Test-Driven Development (TDD).

He often speaks at community gatherings and conferences.

He wrote the Test-Driven Java Development book published by Packt Publishing.

Contact Details:

* Blog: http://technologyconversations.com/
* E-mail: viktor@farcic.com
* Twitter: @vfarcic
* Skype: vfarcic
* LinkedIn: https://www.linkedin.com/in/viktorfarcic

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
vagrant ssh cd -c "ansible-playbook /vagrant/ansible/prod.yml -i /vagrant/ansible/hosts/prod" # Answer "yes" when asked
vagrant ssh prod -c "sudo /vagrant/scripts/preload_prod.sh"
vagrant halt prod

vagrant up serv-disc-01 serv-disc-02 serv-disc-03
vagrant ssh cd -c "ansible-playbook /vagrant/ansible/consul.yml -i /vagrant/ansible/hosts/serv-disc" # Answer "yes" when asked
vagrant ssh serv-disc-01 -c "sudo /vagrant/scripts/preload_serv_disc.sh"
vagrant ssh serv-disc-02 -c "sudo /vagrant/scripts/preload_serv_disc.sh"
vagrant ssh serv-disc-03 -c "sudo /vagrant/scripts/preload_serv_disc.sh"
vagrant halt serv-disc-01 serv-disc-02 serv-disc-03

vagrant up proxy
vagrant ssh cd -c "ansible-playbook /vagrant/ansible/docker.yml -i /vagrant/ansible/hosts/proxy" # Answer "yes" when asked
vagrant ssh proxy -c "sudo /vagrant/scripts/preload_proxy.sh"
vagrant halt proxy

vagrant up swarm-master swarm-node-1 swarm-node-2
vagrant ssh cd -c "ansible-playbook /vagrant/ansible/docker.yml -i /vagrant/ansible/hosts/swarm" # Answer "yes" when asked
vagrant ssh swarm-master -c "sudo /vagrant/scripts/preload_swarm.sh"
vagrant ssh swarm-node-1 -c "sudo /vagrant/scripts/preload_swarm.sh"
vagrant ssh swarm-node-1 -c "sudo /vagrant/scripts/preload_swarm_node.sh"
vagrant ssh swarm-node-2 -c "sudo /vagrant/scripts/preload_swarm.sh"
vagrant ssh swarm-node-2 -c "sudo /vagrant/scripts/preload_swarm_node.sh"
vagrant halt swarm-master swarm-node-1 swarm-node-2

vagrant halt cd
```
