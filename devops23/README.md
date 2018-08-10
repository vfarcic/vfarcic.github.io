# [Workshop: Kubernetes: Deploying and managing highly-available and fault-tolerant applications at scale (3 days)](http://vfarcic.github.io/devops23/workshop.html)
# Practical Kubernetes

## Abstract

Kubernetes is a container scheduler and quite a lot more. We can use it to deploy our services, to roll out new releases without downtime, and to scale (or de-scale) those services. It is portable. It can run on a public or private cloud. It can run on-premise or in a hybrid environment. Kubernetes, in a way, makes your infrastructure vendor agnostic. We can move a Kubernetes cluster from one hosting vendor to another without changing (almost) any of the deployment and management processes. Kubernetes can be easily extended to serve nearly any needs. We can choose which modules we'll use, and we can develop additional features ourselves and plug them in.

If we choose to use Kubernetes, we decide to relinquish control. Kubernetes will decide where to run something and how to accomplish the state we specify. Such control allows Kubernetes to place replicas of a service on the most appropriate server, to restart them when needed, to replicate them, and to scale them. We can say that self-healing is a feature included in its design from the start. On the other hand, self-adaptation is coming as well. At the time of this writing, it is still in its infancy. Soon it will be an integral part of the system.

Zero-downtime deployments, fault tolerance, high availability, scaling, scheduling, and self-healing should be more than enough to see the value in Kubernetes. Yet, that is only a fraction of what it provides. We can use it to mount volumes for stateful applications. It allows us to store confidential information as secrets. We can use it to validate the health of our services. It can load balance requests and monitor resources. It provides service discovery and easy access to logs. And so on and so forth. The list of what Kubernetes does is long and rapidly increasing. Together with Docker, it is becoming a platform that envelops whole software development and deployment lifecycle.

In this live training course, you will learn how to create and manage basic Kubernetes objects.

## What you'll learn-and how you can apply it

* How to build Docker images that will be used in a Kubernetes cluster
* What is Kubernetes and why we need it
* How to run a Kubernetes cluster locally
* What are Pods and how to run them
* How to scale Pods with ReplicaSets
* How to enable communication between Pods through Services
* How to deploy new releases without downtime
* How to enable external traffic through Ingress
* How to use Volumes to access host's file system
* How to inject configurations into containers
* How to inject secrets into containers
* How to split cluster into Namespaces
* How to authorize users to access the cluster
* How to fine-tune resources used by containers and how to limit their usage within Namespaces
* How to persist stateful applications
* How to deploy stateful applications

## This training course is for you because...

The course is aimed at DevOps Engineers, developers and IT Operations who want to enhance the DevOps culture using Kubernetes. If you have been struggling to find the time to gain proficiency and confidence with Kubernetes, here is your one stop solution!

## Prerequisites

Materials, downloads, or Supplemental Content needed in advance:

* [Git](https://git-scm.com)
* [jq](https://stedolan.github.io/jq/)
* GitBash (if using Windows)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Docker For Windows](https://www.docker.com/docker-windows), [Docker For Mac](https://www.docker.com/docker-mac), or [Docker Server](https://docs.docker.com/install/#server) if using Linux
* [Docker Hub account](https://hub.docker.com/)
* [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/) or admin access to AWS

If you are a Windows user, please make sure that your Git client is configured to check out the code AS-IS. Otherwise, Windows might change carriage returns to the Windows format.

Please double check that VirtualBox, minikube, and kubectl work by executing:

```bash
minikube start —vm driver=virtualbox

kubectl gets nodes

minikube delete
```

## Schedule

The timeframes are only estimates and may vary according to how the class is progressing

## DAY 1 (4 HOURS)

### Section 1: Building Docker Images (45 min - instructor lecture + Q&A)

Create a Dockerfile with Multi-Stage builds that envelops whole CI process from running unit tests, through building binaries, all the way until a Docker image is created and pushed to a registry. We'll build one Docker image based on https://github.com/vfarcic/go-demo-3/blob/master/Dockerfile. Later on, we'll use mongo, jenkins, golang, and a few other images

### Section 2: What Is A Container Scheduler? (15 min - instructor lecture + Q&A)

Learn the short history of software and infrastructure development, why we need containers and container schedulers, and what is Kubernetes.

### Section 3: Running A Kubernetes Cluster Locally (1 hour - instructor lecture+ Q&A)

Minikube creates a single-node cluster inside a VM on your laptop. While that is not ideal since we won't be able to demonstrate some of the features Kubernetes provides in a multi-node setup, it should be more than enough to explain most of the concepts behind Kubernetes. Later on, we'll move into a more production-like environment and explore the features that cannot be demonstrated in Minikube.

### Section 4 : Creating Pods (1 hour - instructor lecture+ Q&A)

A Pod encapsulates one or more containers. It provides a unique network IP, it attaches storage resources, and it decides how containers should run. Everything in a Pod is tightly coupled.

### Section 5: Scaling Pods With ReplicaSets (1 hour - instructor lecture + Q&A)

ReplicaSet’s primary, and pretty much only function, is to ensure that a specified number of replicas of a Pod matches the actual state (almost) all the time. That means that ReplicaSets make Pods scalable.

## DAY 2 (4HOURS 30 MIN)

### Section 6: Using Services To Enable Communication Between Pods (1 hour - instructor lecture + Q&A)

We need a stable, never-to-be-changed address that will forward requests to whichever Pod is currently running. Kubernetes Services provide addresses through which associated Pods can be accessed.

### Section 7: Deploying Releases With Zero-Downtime (1 hour - instructor lecture + Q&A)

While we might never be able to reach 100% availability, we should certainly not cause downtime ourselves and must minimise other factors that could cause downtime. We'll try to accomplish zero-downtime deployment of new releases through Kubernetes Deployments.

### Section 8: Using Ingress To Forward Traffic (1 hour - instructor lecture + Q&A)

Ingress objects manage external access to the applications running inside a Kubernetes cluster. It provides an API that allows us to accomplish path and domain routing and SSL certifications, in addition to a few other features we expect from a dynamic cluster.

### Section 9: Using Volumes To Access Host's File System (1 hour - instructor lecture + Q&A)

Kubernetes Volumes solve the need to preserve the state across container crashes. In essence, Volumes are references to files and directories made accessible to containers that form a Pod.

### Wrap-up: Summary, Discussions (30 min)

Interactive Discussion and final Q&A


## Bio (short)

Viktor Farcic is a Principal Consultant at CloudBees, a member of the Docker Captains group, and published author.

His big passions are DevOps, Microservices, Continuous Integration, Delivery and Deployment (CI/CD) and Test-Driven Development (TDD).

He often speaks at community gatherings and conferences.

He published "The DevOps Toolkit Series" books the Test-Driven Java Development.

His random thoughts and tutorials can be found in his blog TechnologyConversations.com.
