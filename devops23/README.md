# [Workshop: Kubernetes: Deploying and managing highly-available and fault-tolerant applications at scale (3 days)](http://vfarcic.github.io/devops23/workshop.html)

## Abstract

Kubernetes is a container scheduler and quite a lot more. We can use it to deploy our services, to roll out new releases without downtime, and to scale (or de-scale) those services. It is portable. It can run on a public or private cloud. It can run on-premise or in a hybrid environment. Kubernetes, in a way, makes your infrastructure vendor agnostic. We can move a Kubernetes cluster from one hosting vendor to another without changing (almost) any of the deployment and management processes. Kubernetes can be easily extended to serve nearly any needs. We can choose which modules we'll use, and we can develop additional features ourselves and plug them in.

If we choose to use Kubernetes, we decide to relinquish control. Kubernetes will decide where to run something and how to accomplish the state we specify. Such control allows Kubernetes to place replicas of a service on the most appropriate server, to restart them when needed, to replicate them, and to scale them. We can say that self-healing is a feature included in its design from the start. On the other hand, self-adaptation is coming as well. At the time of this writing, it is still in its infancy. Soon it will be an integral part of the system.

Zero-downtime deployments, fault tolerance, high availability, scaling, scheduling, and self-healing should be more than enough to see the value in Kubernetes. Yet, that is only a fraction of what it provides. We can use it to mount volumes for stateful applications. It allows us to store confidential information as secrets. We can use it to validate the health of our services. It can load balance requests and monitor resources. It provides service discovery and easy access to logs. And so on and so forth. The list of what Kubernetes does is long and rapidly increasing. Together with Docker, it is becoming a platform that envelops whole software development and deployment lifecycle.

In this course, you will learn (almost) everything you need to know about Kubernetes.

## Abstract (Intense)

Kubernetes is a container scheduler and quite a lot more. We can use it to deploy our services, to roll out new releases without downtime, and to scale (or de-scale) those services. It is portable. It can run on a public or private cloud. It can run on-premise or in a hybrid environment. Kubernetes, in a way, makes your infrastructure vendor agnostic. We can move a Kubernetes cluster from one hosting vendor to another without changing (almost) any of the deployment and management processes. Kubernetes can be easily extended to serve nearly any needs. We can choose which modules we'll use, and we can develop additional features ourselves and plug them in.

If we choose to use Kubernetes, we decide to relinquish control. Kubernetes will decide where to run something and how to accomplish the state we specify. Such control allows Kubernetes to place replicas of a service on the most appropriate server, to restart them when needed, to replicate them, and to scale them. We can say that self-healing is a feature included in its design from the start. On the other hand, self-adaptation is coming as well. At the time of this writing, it is still in its infancy. Soon it will be an integral part of the system.

Zero-downtime deployments, fault tolerance, high availability, scaling, scheduling, and self-healing should be more than enough to see the value in Kubernetes. Yet, that is only a fraction of what it provides. We can use it to mount volumes for stateful applications. It allows us to store confidential information as secrets. We can use it to validate the health of our services. It can load balance requests and monitor resources. It provides service discovery and easy access to logs. And so on and so forth. The list of what Kubernetes does is long and rapidly increasing. Together with Docker, it is becoming a platform that envelops whole software development and deployment lifecycle.

This will be a very fast paced show & tell type of workshop. The objective is to get introduced to some of the major Kubernetes concepts and resources that will serve as a base for a more detailed learning and practice.

## Agenda

### Day 1

* Building Docker Images

Create a Dockerfile with Multi-Stage builds that envelops whole CI process from running unit tests, through building binaries, all the way until a Docker image is created and pushed to a registry.

* What Is A Container Scheduler?

Learn the short history of software and infrastructure development, why we need containers and container schedulers, and what is Kubernetes.

* Running A Kubernetes Cluster Locally

Learn to create a Kubernetes cluster locally.

Minikube creates a single-node cluster inside a VM on your laptop. While that is not ideal since we won't be able to demonstrate some of the features Kubernetes provides in a multi-node setup, it should be more than enough to explain most of the concepts behind Kubernetes. Later on, we'll move into a more production-like environment and explore the features that cannot be demonstrated in Minikube.

* Creating Pods

A Pod encapsulates one or more containers. It provides a unique network IP, it attaches storage resources, and it decides how containers should run. Everything in a Pod is tightly coupled.

* Scaling Pods With ReplicaSets

ReplicaSet’s primary, and pretty much only function, is to ensure that a specified number of replicas of a Pod matches the actual state (almost) all the time. That means that ReplicaSets make Pods scalable.

* Using Services To Enable Communication Between Pods

We need a stable, never-to-be-changed address that will forward requests to whichever Pod is currently running. Kubernetes Services provide addresses through which associated Pods can be accessed.

* Deploying Releases With Zero-Downtime

While we might never be able to reach 100% availability, we should certainly not cause downtime ourselves and must minimise other factors that could cause downtime. We'll try to accomplish zero-downtime deployment of new releases through Kubernetes Deployments.

* Using Ingress To Forward Traffic

Ingress objects manage external access to the applications running inside a Kubernetes cluster. It provides an API that allows us to accomplish path and domain routing and SSL certifications, in addition to a few other features we expect from a dynamic cluster.

* Using Volumes To Access Host's File System

Kubernetes Volumes solve the need to preserve the state across container crashes. In essence, Volumes are references to files and directories made accessible to containers that form a Pod.

### Day 2

* Using ConfigMaps To Inject Configuration Files
* Using Secrets To Hide Confidential Information
* Dividing A Cluster Into Namespaces
* Securing Kubernetes Clusters
* Managing Resources
* Creating A Production-Ready Kubernetes Cluster
* Persisting State

### Day 3

* Deploying Stateful Applications At Scale
* Enabling Process Communication With Kube API Through Service Accounts
* Deploying Stateful Applications At Scale
* Defining Continuous Deployment
* Q&A

# Talk: Deploying Fault-Tolerant And Highly-Available Jenkins To Kubernetes

Jenkins is the de-facto standard for continuous integration, delivery, and deployment process. Docker allows us to package our applications into immutable images that can be reliably deployed anywhere. Kubernetes become undisputable king of container orchestration.

What happens when we combine the three? We'll explore the steps we might take to combine Jenkins, Docker, and Kubernetes into a reliable, fault-tolerant, and highly-available platform for continuous deployment processes.


# Bio (short)

Viktor Farcic is a Principal Consultant at CloudBees, a member of the Docker Captains group, and books author.

His big passions are DevOps, Microservices, Continuous Integration, Delivery and Deployment (CI/CD) and Test-Driven Development (TDD).

He often speaks at community gatherings and conferences.

He published "The DevOps Toolkit Series" books the Test-Driven Java Development.

His random thoughts and tutorials can be found in his blog TechnologyConversations.com.
