# The DevOps 2.X Toolkit: The State Of DevOps

## Abstract: Talk

DevOps requires both cultural and technological change. It teaches us to unite diverse teams and to automate all repetitive steps in our processes. However, the DevOps movement also comes with a host new technologies and supporting practices such as containers, microservices, cloud provides, and configuration management.

This talk will address the current state of DevOps. To do that, we'll go back in time and explore how we got here and what drove the industry to adopt the tools and the practices we're using today. Only with an understanding of the past can we understand the reasons behind modern DevOps technologies and practices.

We'll explore the DevOps culture and the need for change required for the adoption of modern technologies. Given that DevOps is first and foremost a cultural change, that will allow us to explore the reasons and the benefits behind some of the changes we need to apply to our infrastructure and software architecture. Culture together with new approaches to infrastructure and software architecture will allow us to reach nirvana in form of true continuous deployment and self-sufficient systems capable of operating without human intervention.

## Short Abstract: Talk

We'll explore the DevOps culture and the need for change required for the adoption of modern technologies. Given that DevOps is first and foremost a cultural change, that will allow us to explore the reasons and the benefits behind some of the changes we need to apply to our infrastructure and software architecture. Culture together with new approaches to infrastructure and software architecture will allow us to reach nirvana in form of true continuous deployment and self-sufficient systems capable of operating without human intervention.

## Abstract: Workshop

Agile changed the way we develop software, but it failed to change the way we deliver it. As a result of facing new challenges, we got **DevOps**. We got a cross-disciplinary community of practice dedicated to the study of building, evolving and operating rapidly changing resilient systems at scale.

DevOps is as much a cultural as technological change. While it united diverse teams and professionals and thought us how to automate all repetitive steps in our processes, it failed to introduce a real difference in the software landscape we use. Hence, DevOps 2.0 emerged with a drastic change in our methods, tools, and architecture. Finally, we have everything we need to build scalable, fault-tolerant, and self-healing systems delivered to production through continuous deployment.

This workshop focuses on architectural changes and new tools we should adopt to be able to tackle the problems presented by a demand for modern, responsive, fault tolerant, and elastic systems. It is based on the material published in [The DevOps Toolkit Series](http://www.devopstoolkitseries.com/) books.

The workshop will go through the whole **microservices development lifecycle**. We'll start from the very beginning. We'll define and design architecture. From there on we'll move from requirements, technological choices and development environment setup, through coding and testing all the way until the final deployment to production. We won't stop there. Once our new services are up and running we'll see how to maintain them, scale them depending on resource utilization and response time, recover them in case of failures and create central monitoring and notifications system. We'll try to balance the need for creative manual work and the need to automate as much of the process as possible.

This will be a journey through all the aspects of the lives of microservices and everything that surrounds them. We'll see how microservices fit into continuous deployment and immutable containers concepts and why the best results are obtained when those three are combined into one unique framework.

During the workshop we'll explore tools like **Docker, Docker Swarm, Docker Compose, Ansible, Consul, etcd, confd, Registrator, nginx, HAProxy, ElasticSearch, LogStash, Kibana**, and so on.

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

### Pitch

The talk describes best practices we're facing when working on distributed systems at scale.

### Bio

**Viktor Farcic** is a Principal Consultant at **[CloudBees](https://www.cloudbees.com/)**, a member of the **[Docker Captains](https://www.docker.com/community/docker-captains)** group, and published author.

He coded using a plethora of languages starting with Pascal (yes, he is old), Basic (before it got Visual prefix), ASP (before it got .Net suffix), C, C++, Perl, Python, ASP.Net, Visual Basic, C#, JavaScript, Java, Scala, etc. He never worked with Fortran. His current favorite is **Go**.

His big passions are DevOps, Microservices, Continuous Integration, Delivery and Deployment (CI/CD) and Test-Driven Development (TDD).

He often speaks at community gatherings and conferences (latest can be found [here](http://technologyconversations.com/2014/08/06/history/)).

He published [The DevOps 2.0 Toolkit: Automating the Continuous Deployment Pipeline with Containerized Microservices](https://www.amazon.com/DevOps-2-0-Toolkit-Containerized-Microservices-ebook/dp/B01BJ4V66M), [The DevOps 2.1 Toolkit: Docker Swarm: Building, testing, deploying, and monitoring services inside Docker Swarm clusters](https://www.amazon.com/dp/1542468914), [The DevOps 2.2 Toolkit: Self-Sufficient Docker Clusters](https://www.amazon.com/dp/1979347190), [The DevOps 2.3 Toolkit: Kubernetes: Deploying and managing highly-available and fault-tolerant applications at scale](https://www.amazon.com/dp/B07BSRNHSS), and the [Test-Driven Java Development](http://www.amazon.com/Test-Driven-Java-Development-Viktor-Farcic-ebook/dp/B00YSIM3SC).

His random thoughts and tutorials can be found in his blog [TechnologyConversations.com](http://technologyconversations.com/).

Contact Details:

* E-mail: viktor@farcic.com
* Twitter: @vfarcic
* Skype: vfarcic
* LinkedIn: https://www.linkedin.com/in/viktorfarcic
* Blog: http://technologyconversations.com/

# Bio (Short)

Viktor Farcic is a Principal Consultant at CloudBees, a member of the Docker Captains group, and published author.