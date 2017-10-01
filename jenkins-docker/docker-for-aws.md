# Docker for AWS

---

[youtu.be/r5cofUYqnn8](https://youtu.be/r5cofUYqnn8)

![](../img/qr/docker-for-aws.png)


## Prerequisites

---

* [Docker Hub](https://hub.docker.com/) account
* [Docker](https://www.docker.com/)
* [AWS account](https://aws.amazon.com/)
* SSH client (e.g. [Putty](http://www.putty.org/))
* [Git](https://git-scm.com/) & GitBash (if Windows)


## Creating AWS Key Pair

---

* Open [AWS Console](http://console.aws.amazon.com)
* Click the *EC2* link
* Click the *Key Pairs* link
* Click the *Create Key Pair* button
* Name it *workshop*
* Click the *Create* button

```bash
chmod 0400 workshop.pem
```


## Creating a Docker Cluster

---

* Open [Docker Community Edition for AWS](https://store.docker.com/editions/community/docker-ce-aws)
* Click the *Get Docker* button
* Click the *Next* button
* Type *jenkins-is-cool* as the *Stack name*
* Change the *Number of Swarm worker nodes* to *0*
* Select *workshop* as your SSH key in *Which SSH key to use*
* Select *yes* as *Enable daily resource cleanup*
* Select *no* as *Use Cloudwatch for container logging*

Note:
We'll use https://docs.docker.com/docker-for-aws/. It is a very simple way to create a Docker cluster. I put this at the very beginning, since the process, even though it is fully automated, takes around 15 minutes. We can go through theoretical slides that follow while clusters are being created.


## Creating a Docker Cluster

---

* Select *yes* as *Create EFS prerequsities for CloudStor*
* Choose *t2.medium* as *Swarm manager instance type*
* Click the *Next* button
* Click the *Next* button
* Select *I acknowledge that AWS CloudFormation might create IAM resources*
* Click the *Create button*


## Entering The Cluster

---

* Click the *Output* tab in CloudFormation Stacks screen
* Copy *DefaultDNSTarget*

```bash
CLUSTER_DNS=[...]
```

* Click the link next to *Managers*
* Select any of the nodes
* Copy *IPv4 Public IP* value

```bash
CLUSTER_IP=[...]

ssh -i workshop.pem docker@$CLUSTER_IP

docker node ls

exit
```
