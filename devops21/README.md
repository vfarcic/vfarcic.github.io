# The DevOps 2.1 Toolkit: Continuously Deploying Microservices To a Swarm Cluster

## Abstract: Talk

This talk focuses on architectural changes and new tools we should adopt to be able to tackle the problems presented by a demand for modern, responsive, fault tolerant and elastic systems. It is based on the material published in [The DevOps 2.1 Toolkit: Building, testing, deploying, and monitoring services inside Docker Swarm clusters](https://leanpub.com/the-devops-2-1-toolkit).

The talk will go through the whole microservices development lifecycle. We’ll start from the very beginning. We’ll define and design architecture. From there on we’ll move from requirements, technological choices and development environment setup, through coding and testing all the way until the final deployment to production. We won’t stop there. Once our new services are up and running we’ll see how to maintain them, scale them depending on resource utilization and response time, and recover them in case of failures. We’ll try to balance the need for creative manual work and the need to automate as much of the process as possible.

The goal will be to design a fully automate continuous deployment (CDP) pipeline. We’ll see how microservices fit into CDP and immutable containers concepts and why the best results are obtained when those three are combined into one unique framework.

During the talk we’ll explore tools like Docker, Docker Swarm, Docker Compose, Jenkins, HAProxy, and a few others.

## Abstract: Workshop

This workshop focuses on architectural changes and new tools we should adopt to be able to tackle the problems presented by a demand for modern, responsive, fault tolerant and elastic systems. It is based on the material published in [The DevOps 2.1 Toolkit: Building, testing, deploying, and monitoring services inside Docker Swarm clusters](https://leanpub.com/the-devops-2-1-toolkit).

The workshop will go through the whole microservices development lifecycle. We’ll start from the very beginning. We’ll define and design architecture. From there on we’ll move from requirements, technological choices and development environment setup, through coding and testing all the way until the final deployment to production. We won’t stop there. Once our new services are up and running we’ll see how to maintain them, scale them depending on resource utilization and response time, and recover them in case of failures. We’ll try to balance the need for creative manual work and the need to automate as much of the process as possible.

The goal will be to design a fully automate continuous deployment (CDP) pipeline. We’ll see how microservices fit into CDP and immutable containers concepts and why the best results are obtained when those three are combined into one unique framework.

During the workshop we’ll explore tools like Docker, Docker Swarm, Docker Compose, Jenkins, HAProxy, and a few others.

We'll explore the practices and tools required to run a Swarm cluster. We'll go beyond a simple deployment. We'll explore how to create a continuous deployment process. We'll set up multiple clusters. One will be dedicated to testing and the other for production. We'll see how to accomplish zero-downtime deployments, what to do in case of a failover, how to run services at scale, how to monitor the systems, and how to make it heal itself. We'll explore the processes that will allow us to run the clusters on a laptop as well as on different cloud providers.

## Abstract: Webinar Jenkins

We'll explore the practices and tools required to run Jenkins inside a Swarm cluster. We'll go beyond a simple deployment. We'll explore how to create a continuous deployment process. We'll set up multiple clusters. One will be dedicated to testing and the other for production. We'll see how to accomplish zero-downtime deployments, what to do in case of a failover, how to run services at scale, how to monitor the systems, and how to make it heal itself. We'll explore the processes that will allow us to run the clusters on a laptop as well as on different cloud providers.

The examples will set up Jenkins master in a way that it is fault tolerant and create a dynamic cluster for running agents. Once Jenkins is up and running, we'll use Pipeline to define a continuous deployment flow for one of the services.

# Learning Outcomes

* DevOps: A cross-disciplinary community of practice dedicated to the study of building, evolving and operating rapidly-changing resilient systems at scale.
* The DevOps Toolkit

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