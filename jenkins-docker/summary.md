# Workshop Summary


## Prerequisites

---

* [AWS account](https://aws.amazon.com/)
* SSH client (TODO: link with instructions)
* SSH keys in AWS and locally (TODO: link with instructions)

Note:
AWS account must be private, not corporate. Otherwise, we might have to deal with customizations that would prevent attendees to follow the workshop. We could use http://labs.play-with-docker.com/, but that would prevent us from running CJE (everything else should be OK).


## Creating a Docker Cluster

---

TODO

Note:
We'll use https://docs.docker.com/docker-for-aws/. It is a very simple way to create a Docker cluster. I put this at the very beginning since the process, even though it is fully automated, takes around 15 minutes. We can go through theoretical slides that follow while clusters are being created.


## What Is DevOps?

---

TODO

Note:
A short and purely theoretical introduction to DevOps. The message is that DevOps is what everyone should be doing but we cannot go through it in this workshop since Jenkins is only a fraction of the toolkit. Instead, we'll focus on two main DevOps players; Jenkins and Docker.


## What Is Continuous Delivery And Deployment?

---

TODO

Note:
A short and purely theoretical introduction to Continuous delivery and deployment. This is something that we (CB) truly control. While DevOps is a great sales pitch (everyone wants it), we should focus on what we can deliver and that is CD.


## What Is Jenkins?

---

TODO

Note:
There's no need to spend much time explaining what Jenkins is since only Jenkins users will opt for this workshop. Instead, we can use it to promote new stuff like Blue Ocean, CJE, and so on.


## What Is Docker?

---

TODO

Note:
This is mostly introduction to Docker Ecosystem. We should quickly mention Docker Engine and client, Docker Compose, Docker Swarm, and Docker Machine. We should not spend much time here since they will be used heavily throughout hands-on exercises.


## Running Containers

---

TODO

Note:
Unlike most other Docker workshops, this one will use Jenkins for most of the examples while still providing enough knowledge how Docker works. We'll run a single Jenkins master and confirm that it works by opening it from a browser.


## Building Images

---

TODO

Note:
Build a custom Jenkins image with preloaded plugins.


## Running Services

---

TODO

Note:
Run Jenkins master as a service


## Volumes

---

TODO

Note:
Create a volume using CloudStor and incorporate it into Jenkins master service.


## Secrets

---

TODO

Note:
Build a new custom Jenkins image with the admin user retrieved from a Docker secret. Create secrets for Jenkins admin user and pass and incorporate it into Jenkins master service.


## Stacks

---

TODO

Note:
Convert Jenkins master service command into a stack and deploy it.


## Failover

---

TODO

Note:
Demonstrate failover by killing Jenkins container. Show that the state is persistent across failures and reschedules.


## Jenkins agents

---

TODO

Note:
Create a second cluster for CD and deploy a few Jenkins agents using Jenkins Swarm Plugin.


## Registry

---

TODO

Note:
Deploy a registry, build an image, push it and pull it to/from the registry


## Multi-stage builds

---

TODO

Note:
Show how unit tests and artifact builds can be done as part of the build of a Docker image without sacrificing the final size.


## Rolling Updates

---

TODO

Note:
Deploy a demo service and perform an rolling update to a new release


## Jenkins Pipeline

---

TODO

Note:
Create a Jenkins pipeline that incorporates all the knowledge from previous exercises


## Multi-Branch Pipeline

---

TODO

Note:
Explain Jenkinsfile and create a Multi-Branch Pipeline job that uses one of the demo repositories


## CJE

---

TODO

Note:
Create a CJE cluster and demonstrate some of its key features. Show how easy it is to set it up and administer it. Show how it provides much more features than when creating a custom solution on top of schedulers.