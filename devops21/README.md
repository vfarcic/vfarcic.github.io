# The DevOps 2.1 Toolkit: Continuously Deploying Microservices To a Swarm Cluster
# Microservices Lifecycle Explained Through Docker And Continuous Deployment

## Abstract: Talk

The talk focuses on architectural changes and new tools we should adopt to be able to tackle the problems presented by a demand for modern, responsive, fault tolerant and elastic systems. It is based on the material published in [The DevOps 2.1 Toolkit: Building, testing, deploying, and monitoring services inside Docker Swarm clusters](https://leanpub.com/the-devops-2-1-toolkit).

The talk will go through the whole microservices development lifecycle. We’ll start from the very beginning and define and design architecture. From there on we’ll move from requirements, technological choices and development environment setup, through coding and testing all the way until the final deployment to production. We won’t stop there. Once our new services are up and running we’ll see how to maintain them, scale them depending on resource utilization and response time, and recover them in case of failures. We’ll try to balance the need for creative manual work and the need to automate as much of the process as possible.

The goal is to design a fully automated continuous deployment (CDP) pipeline. We’ll see how microservices fit into CDP and immutable containers concepts and why the best results are obtained when those three are combined into one unique framework.

## Abstract: Talk CDP

Docker changed the way we are implementing continuous deployment processes. It enables us to simplify and speed up the process and, through immutability, guarantee that services we are testing will reach production unchanged.

The goal is to design a fully automated continuous deployment (CDP) pipeline. Every commit will pass through a set of automated steps resulting in a deployment to production.

We’ll see how microservices fit into CDP and immutable containers concepts and why the best results are obtained when those three are combined into one unique framework.

## Abstract: Workshop

This workshop is based on the material published in [The DevOps 2.1 Toolkit: Building, testing, deploying, and monitoring services inside Docker Swarm clusters](https://leanpub.com/the-devops-2-1-toolkit).

The workshop will go through the whole microservices development lifecycle. We’ll start from the very beginning and define and design architecture. From there on we’ll move from requirements, technological choices and development environment setup, through coding and testing all the way until the final deployment to production. We won’t stop there. Once our new services are up and running we’ll see how to maintain them, scale them depending on resource utilization and response time, and recover them in case of failures. We’ll try to balance the need for creative manual work and the need to automate as much of the process as possible.

The goal will be to design a fully automated continuous deployment (CDP) pipeline. We’ll see how microservices fit into CDP and immutable containers concepts and why the best results are obtained when those three are combined into one unique framework.

During the workshop we’ll explore tools like Docker, Docker Swarm, Docker Compose, Jenkins, HAProxy, and a few others.

We'll explore the practices and tools required to run a Swarm cluster. We'll go beyond a simple deployment. We'll explore how to create a continuous deployment process. We'll set up multiple clusters. One will be dedicated to testing and the other for production. We'll see how to accomplish zero-downtime deployments, what to do in case of a failover, how to run services at scale, how to monitor the systems, and how to make it heal itself. We'll explore the processes that will allow us to run the clusters on a laptop as well as on different cloud providers.

## Schedule: Workshop

* Introduction to DevOps
* Immutable infrastructure as code
* Continuous integration with Docker
* Setting up a Swarm cluster and running services
* Running Jenkins inside a cluster
* Centralized logging
* Monitoring metrics

## Abstract: Worshop (Short)

The workshop will go through the whole microservices development lifecycle. We’ll start from the very beginning and define and design architecture. From there on we’ll do some coding and testing all the way until the final deployment to production. Once our new services are up and running we’ll see how to maintain them, scale them, and recover them in case of failures.

The goal will be to design a fully automated continuous deployment (CDP) pipeline with Docker containers.

During the workshop we’ll explore tools like Docker, Docker Swarm, Docker Compose, Jenkins, HAProxy, and a few others.

## Abstract: Webinar Jenkins

We'll explore the practices and tools required to run Jenkins inside a Swarm cluster. We'll go beyond a simple deployment. We'll explore how to create a continuous deployment process. We'll set up multiple clusters. One will be dedicated to testing and the other for production. We'll see how to accomplish zero-downtime deployments, what to do in case of a failover, how to run services at scale, how to monitor the systems, and how to make it heal itself. We'll explore the processes that will allow us to run the clusters on a laptop as well as on different cloud providers.

The examples will set up Jenkins master in a way that it is fault tolerant and create a dynamic cluster for running agents. Once Jenkins is up and running, we'll use Pipeline to define a continuous deployment flow for one of the services.

### Pitch: Workshop

The workshop walks the audience through some of the best practices we're facing when working on distributed systems at scale.

## Requirements

This workshop contains a vast amount of topics and will be performed at a very fast pace. The recommendation is to observe the commands I will be executing and concentrate on understanding the logic behind them. Everything will be posted online after the workshop and you will be able to repeat it later on at your own pace. If you agree with the recommendation, you will not be required to bring anything.

On the other hand, you are welcome to follow along and try to reproduce everything during the workshop. If you choose that approach, you will need:

* [Git](https://git-scm.com/)
* [AWS account](https://aws.amazon.com/)
* [AWS CLI](https://aws.amazon.com/cli/)
* [Packer](https://www.packer.io/)
* [Terraform](https://www.terraform.io/downloads.html)
* [jq](https://stedolan.github.io/jq/)
* GitBash (if Windows)

If you are a Windows user, please make sure that your Git client is configured to check out the code *AS-IS*. Otherwise, Windows might change carriage returns to the Windows format. You will also need an [AWS account](https://aws.amazon.com/) and [AWS CLI](https://aws.amazon.com/cli/). Please note that it should be free from any customizations and limitations your company might have introduced. If in doubt, please use your personal account.

## Learning Outcomes

* DevOps: A cross-disciplinary community of practice dedicated to the study of building, evolving and operating rapidly-changing resilient systems at scale.
* The DevOps Toolkit

  * Containers
  * Configuration management and provisioning
  * Immutable deployments
  * Service discovery
  * Dynamic proxies
  * Zero-downtime continuous deployment
  * Cluster management
  * Self-healing
  * Centralized monitoring and logging
  * ... and much more

* The objective: everything after a commit fully automated without human intervention
* Configuration management: repeatable, automated, and fast provisioning; not for deploying applications
* Deployments: immutable, through containers (Docker) or VMs (in special cases)
* Cluster orchestration: cannot be manual, treat servers as cattle
* Service discovery: replaces traditional (static) configuration
* Proxy: needs to be dynamic
* Deployment downtime: blue-green or rolling upgrades
* Continuous delivery/deployment: decentralized and defined as code
* Logging: must be centralized
* Fault tolerance: requires self-healing
* Architecture: needs to change towards smaller services
* Culture: needs to follow technological changes (and vice versa)