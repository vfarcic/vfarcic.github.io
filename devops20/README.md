The DevOps 2.0 Toolkit
======================

Abstract
--------

Agile changed the way we develop software, but it failed to change the way we deliver it. As a result of facing new challenges, we got DevOps. We got a cross-disciplinary community of practice dedicated to the study of building, evolving and operating rapidly changing resilient systems at scale.

DevOps is as much a cultural as technological change. While it united diverse teams and professionals and thought us how to automate all repetitive steps in our processes, it failed to introduce a real difference in the software landscape we use. Hence, DevOps 2.0 emerged with a drastic change in our methods, tools, and architecture. Finally, we have everything we need to build scalable, fault-tolerant, and self-healing systems delivered to production through continuous deployment.

This talk focuses on architectural changes and new tools we should adopt to be able to tackle the problems presented by a demand for modern, responsive, fault tolerant, and elastic systems. It is based on the material published in [The DevOps 2.0 Toolkit: Automating the Continuous Deployment Pipeline with Containerized Microservices](https://www.amazon.com/dp/B01BJ4V66M) book.

Learning Outcomes
=================

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