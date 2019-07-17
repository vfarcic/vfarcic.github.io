# Continuous Deployment to Kubernetes

## Continuously deploying applications with Jenkins to a Kubernetes cluster

Kubernetes adoption has grown in leaps and bounds, over the past few months and it's the most popular container orchestration tool available. Led by expert, Victor Farcic, this course will help you start using Kubernetes to build a solid deployment pipeline. You'll work with the Kube API and you'll understand why continuous deployment should begin with shell scripts, rather than jumping into Jenkins. Once you're confident of packaging and distributing your applications, you'll set up Jenkins and create an automated continuous delivery pipeline. By the end you'll be a confident engineer, capable of creating a fully autonomous and automated continuous deployment pipeline.

## What is this training about, and why is it important?

This training is not your first contact with Kubernetes. You should already be proficient with Deployments, ReplicaSets, Pods, Ingress, Services, PersistentVolumes, PersistentVolumeClaims, Namespaces and a few other things. Certain level of Kubernetes knowledge and hands-on experience is needed. If that's not the case, what follows might be too confusing and advanced. If you’d still like to participate, please read [The DevOps 2.3 Toolkit: Kubernetes](https://amzn.to/2GvzDjy) first, or consult the Kubernetes documentation before you attend.

## What you’ll learn—and how you can apply it

* Build a solid continuous delivery pipeline using Kubernetes, Jenkins, Helm and other tools
* Discover new features such as auto scaling, rolling updates, resource quotas, and cluster size
* Master the art of reliably rolling out new software versions without downtime or errors

## This Training is for you because…

Administrators and DevOps professionals who are eager to learn how to create autonomous CD pipelines using Kubernetes. You want to automate your release process by applying continuous delivery or deployment principles. You already have atleast basic understanding how Kubernetes works and you want to leverage that to create a fully automated deployment pipeline using Jenkins.

# Workshop Prerequisites

A fully operational Kubernetes cluster with NGINX Ingress controller and a default StorageClass. The following Kubernetes platforms were tested for this course. Please note that Gists are provided in case you need to create a cluster specific for this course.

* [devops24-docker.sh](https://gist.github.com/vfarcic/3fbf532b1716d40ae60552baf83b8ed1): Docker for Mac with 4 CPUs, 4GB RAM, and with nginx Ingress controller.
* [devops24-minikube.sh](https://gist.github.com/vfarcic/f5863c66867bbe87722998683ea20c41): minikube with 4 CPUs, 4GB RAM, and with ingress, storage-provisioner, and default-storageclass addons enabled.
* [devops24-kops.sh](https://gist.github.com/vfarcic/0552be5ccbd5c8d7f87a9dfadb5e66dc): kops in AWS with 3 t2.medium masters and 3 t2.medium nodes spread in three availability zones, and with nginx Ingress controller.
* [devops24-eks.sh](https://gist.github.com/vfarcic/b6ed77d257964fa2e19c2722739ddad6): Elastic Kubernetes Service (EKS) with 3 t2.medium nodes, and with nginx Ingress controller.
* [gke.sh](https://gist.github.com/5c52c165bf9c5002fedb61f8a5d6a6d1): Google Kubernetes Engine (GKE) with 3 n1-standard-1 (1 CPU, 3.75GB RAM) nodes (one in each zone), with Cluster Autoscaler, and with nginx Ingress controller running on top of the "standard" one that comes with GKE.

If you are a Windows user, please use GitBash as a terminal for running the commands.

If you are running a local Kubernetes cluster with Docker For Mac/Windows, please install Vagrant (if you do not have it already).

Besides the cluster, you’ll need [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).

If you have problems fulfilling the requirements, please contact me through [DevOps20](http://slack.devops20toolkit.com/) Slack (my user is vfarcic) or send me an email to viktor@farcic.com.

## Schedule

### Enabling Process Communication With Kube API Through Service Accounts

Humans are not the only ones who rely on a cluster. Processes in containers often need to invoke Kube API as well. When using RBAC for authentication, we need to decide which users will have permissions to perform specific actions. The same holds true for the processes running inside containers.

### Defining Continuous Deployment

The work on defining Continuous Deployment (CDP) steps should not start in Jenkins or any other similar tool. Instead, we should focus on Shell commands and scripts and turn our attention to the CI/CD tools only once we are confident that we can execute the full process with only a few commands.

### Packaging Kubernetes Applications

Using YAML files to install or upgrade applications in a Kubernetes cluster works well only for static definitions. The moment we need to change an aspect of an application we are bound to discover the need for templating and packaging mechanisms.

### Distributing Kubernetes Applications

Being able to package applications is of no use unless we can distribute them. A Kubernetes application is a combination of one or more container images and YAML files that describe them. If we are to distribute our applications, we need to store both container images and YAML definitions in repositories.

### Installing and Setting Up Jenkins

When used by engineers, UIs are evil. They sidetrack us from repeatability and automation. We’ll try to fully automate Jenkins setup through a single CLI command.

### Creating A Continuous Deployment Pipeline With Jenkins

Having A Continuous Deployment pipeline capable of the fully automated application life-cycle is a true sign of maturity of an organization. We’ll do our best to create a pipeline that works without any manual (human) involvement.