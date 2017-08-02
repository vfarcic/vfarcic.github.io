# Introduction


## Prerequisites

---

* [Docker](https://www.docker.com/)
* [Docker Hub](https://hub.docker.com/) account
* [AWS account](https://aws.amazon.com/)
* SSH client (e.g. [Putty](http://www.putty.org/))
* SSH key named `workshop` in AWS and locally (see [Amazon EC2 Key Pairs](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html))
* `0400` permissions on the `workshop.pem` key (if not Windows)
* [Git](https://git-scm.com/) & GitBash (if Windows)

Note:
AWS account must be private, not corporate. Otherwise, we might have to deal with customizations that would prevent attendees to follow the workshop. We could use http://labs.play-with-docker.com/, but that would prevent us from running CJE (everything else should be OK).


## Creating a Docker Cluster

---

* Open [Docker Community Edition for AWS](https://store.docker.com/editions/community/docker-ce-aws)
* Click the `Get Docker` button
* Click the `Next` button
* Type `jenkins-is-cool` as the `Stack name`
* Change the `Number of Swarm worker nodes` to `0`
* Select `workshop` as your SSH key in `Which SSH key to use`
* Select `yes` as `Enable daily resource cleanup`
* Select `no` as `Use Cloudwatch for container logging`

Note:
We'll use https://docs.docker.com/docker-for-aws/. It is a very simple way to create a Docker cluster. I put this at the very beginning, since the process, even though it is fully automated, takes around 15 minutes. We can go through theoretical slides that follow while clusters are being created.


## Creating a Docker Cluster

---

* Select `yes` as `Create EFS prerequsities for CloudStor`
* Choose `t2.small` as `Swarm manager instance type`
* Click the `Next` button
* Click the `Next` button
* Select `I acknowledge that AWS CloudFormation might create IAM resources`
* Click the `Create button`


## What Is DevOps?

---

* It's a cultural change
* It's about removing silos
* It's about new architecture
* It's about new tools, concepts, and processes
* It's about automation
* It's about coming back from 1999 to present time

Note:
A short and purely theoretical introduction to DevOps. The message is that DevOps is what everyone should be doing but we cannot go through it in this workshop since Jenkins is only a fraction of the toolkit. Instead, we'll focus on two main DevOps players; Jenkins and Docker.


## What Is Continuous Delivery And Deployment?

---

* Every commit is production ready if green
* No manual actions after a commit (except **deploy** button)
* It's full automation of the process
* Developer comes last
* Jenkins rules this area

Note:
A short and purely theoretical introduction to Continuous delivery and deployment. This is something that we (CB) truly control. While DevOps is a great sales pitch (everyone wants it), we should focus on what we can deliver and that is CD.


## What Is Jenkins?

---

* Continuous integration (if you must)
* Continuous delivery
* Continuous deployment
* Tasks scheduler
* Automation orchestrator

Note:
There's no need to spend much time explaining what Jenkins is since only Jenkins users will opt for this workshop. Instead, we can use it to promote new stuff like Blue Ocean, CJE, and so on.


## What Is Jenkins?

---

## Jenkins == tasks executor
## Jenkins == automation
## DevOps == Automation + much more


## What Is Docker?

---

* Process isolation
* Scheduling
* Fault tolerance
* Scalability
* Speed
* Optimization of resource usage


## What Is Docker Ecosystem?

---

* Docker Engine
* Docker Client
* Docker Swarm
* Docker Hub
* LinuxKit
* ...

Note:
This is mostly introduction to Docker Ecosystem. We should quickly mention Docker Engine and client, Docker Compose, Docker Swarm, and Docker Machine. We should not spend much time here since they will be used heavily throughout hands-on exercises.
