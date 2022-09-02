# Canary Deployments To Kubernetes Using Istio and Friends

Kubernetes provides a few “decent” deployment strategies out of the box. However, they might not be enough. Canary is missing.

What is the canary deployments process? How should we implement it in Kubernetes? Which tools should we use? We’ll try to answer those and quite a few other questions.

This workshop will guide you through the journey of practical implementation of canary deployments. We’ll use Kubernetes because it makes many things easier than any other platform before it. We’ll need service mesh because, after all, most of the canary process is controlled through networking and changes to Kubernetes definitions. We’ll need a few other tools, and we might even need to write our own scripts to glue everything into a cohesive process.

The end result will be a set of instructions and hans-on exercises aimed at providing a fully operational canary deployment process that can be plugged into any continuous delivery tool. We’ll define the process, and we’ll choose some tools. Nevertheless, we’ll do all that while making the process agnostic and applicable to any toolset you might pick.

## Agenda

### Introduction to deployment strategies and canary deployments

* "Big Bang" Deployments
* Rolling update deployments
* Canary deployments
* The Problem With Microservices
* What Is Service Mesh?
* Why Istio?

### Installing Istio And Injecting Sidecar Proxies

* Introduction
* Installing Istio CLI
* Creating Kubernetes Cluster
* Installing Istio
* Manual Sidecar Injection
* Automatic Sidecar Injection

### Enabling Incoming Traffic

* Introduction
* Using Istio Gateway
* Using Istio Ingress

### Running Canary Deployments Manually

* Introduction
* Deploying The First Release
* Deploying A New Release
* Splitting Traffic
* Rolling Forward
* Finishing The Deployment

### Using Metrics To Validate Progress

* Introduction
* Querying Metrics
* Measuring Error Rate
* Measuring Average Request Duration
* Measuring Maximum Request Duration
* Visualizing Metrics

### Automating Canary Deployments With Flagger

* Introduction
* Installing Flagger
* Deploying The Application
* Deploying Flagger Resource
* Deploying A New Release
* Visualizing Metrics

### Automating Rollbacks Of Canary Deployments

* Introduction
* Rolling Back On Errors
* Rolling Back On Maximum Request Duration
* Rolling Forward

### Integrating Canary Deployments With Continuous Delivery

* Introduction
* Exploring The Script
* Observing Successful Canary Deployment
* Observing Failed Canary Deployment

## Prerequisites

* [Git](https://git-scm.com/)
* Bash terminal (use WSL or GitBash if running Windows)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

During the workshop, we will create a Kubernetes cluster (unless you already have one). Instructions will be provided for the following "flavors" (you can use any other):
* [minikube](https://minikube.sigs.k8s.io/docs/start/)
* [Docker Desktop](https://www.docker.com/products/docker-desktop)
* AWS EKS (you'll need [AWS account with admin privileges](https://aws.amazon.com/), [aws CLI](https://aws.amazon.com/cli/), and [eksctl](https://eksctl.io/introduction/installation/)
* Azure AKS (you'll need [Azure account with admin privileges](https://azure.microsoft.com/) and [az CLI](https://docs.microsoft.com/cli/azure))
* Google GKE (you'll need [Google Cloud with admin privileges](https://cloud.google.com/) and [gcloud](https://cloud.google.com/sdk/gcloud/))

Please make sure that you have all the listed tools installed, including those related to the platform you choose to run Kubernetes (local, AWS, Azure, Google Cloud).
