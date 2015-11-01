Ansible Workshop
================

Pre-Workshop Instructions
-------------------------

Install [Virtual Box](https://www.virtualbox.org/), [Vagrant](https://www.vagrantup.com/) and [Git](https://git-scm.com/).

__If you are using Windows, please make sure that Git is configured to use "Checkout as-is". This can be accomplished during the setup by selecting the second or third option from the screen.__

![Windows Git Setup](git-windows.png)

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

Run the following commands:

```bash
git clone https://github.com/vfarcic/ansible-workshop.git

cd ansible-workshop

vagrant up

vagrant halt
```

