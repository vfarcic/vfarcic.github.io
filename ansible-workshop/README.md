Ansible Workshop
================

Prerequisites
-------------

Install [Virtual Box](https://www.virtualbox.org/), [Vagrant](https://www.vagrantup.com/) and [Git](https://git-scm.com/).

Note to Windows Users
---------------------

*If you are using Windows, please make sure that Git is configured to use "Checkout as-is". This can be accomplished during the setup by selecting the second or third option from the screen.*

![Windows Git Setup](git-windows.png)

*Vagrant tends to create problems with file permissions when linux VMs are created from a Windows host. If you are a Windows user, please follow the following instructions. After cloning the code, open the Vagrantfile in your text editor (I tend to use [NotePad++](https://notepad-plus-plus.org/)). Inside, you'll find the following two lines:*

```
config.vm.synced_folder ".", "/vagrant"
# config.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=700,fmode=600"]
```

*Please comment the first and uncomment the second line. The end result should be as follows.*

```
# config.vm.synced_folder ".", "/vagrant"
config.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=700,fmode=600"]
```

*Also, if you do not have SSH installed, please make sure that [PATH_TO_GIT]\bin is added to your PATH.**

Pre-Workshop Instructions
-------------------------

Run the following commands:

```bash
git clone https://github.com/vfarcic/ansible-workshop.git

cd ansible-workshop

vagrant up

vagrant halt
```

