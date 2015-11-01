Title
=====

Ansible Workshop
----------------

Co-Presenter
============

Featured Participants
=====================

Track
=====

DevOps

Session Type
============

Workshop

Audience Level
==============

Learning

Room Setup
==========

Duration
========

2 hours

Keywords
========

Ansible, Docker, Docker Swarm, Ubuntu

Abstract
========

Learning Outcomes
=================

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

```bash
git clone https://github.com/vfarcic/ansible-workshop.git

cd ansible-workshop
```

__Vagrant tends to create problems with file permissions when linux VMs are created from a Windows host. If you are a Windows user, please follow the following instructions. After cloning the code, open the Vagrantfile in your text editor (I tend to use [NotePad++](https://notepad-plus-plus.org/)). Inside, you'll find the following two lines:__

```
config.vm.synced_folder ".", "/vagrant"
# config.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=700,fmode=600"]
```

__Please comment the first and uncomment the second line. The end result should be as follows.__

```
# config.vm.synced_folder ".", "/vagrant"
config.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=700,fmode=600"]
```

Create virtual machines.

```bash
vagrant up

vagrant halt
```

