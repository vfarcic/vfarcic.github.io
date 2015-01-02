Introduction
============

At the beginning applications were simple and small due to simple requirements. With time requirements and needs grew and with them our applications became bigger and more complex. That resulted in monolithic servers developed and deployed as a single unit. Microservices are, in a way, return to basics with simple applications that are fulfilling today's needs for complexity by working together through utilization of each others APIs.

What are monolithic servers?
============================

Microservices are best explained when compared with their opposite; **monolithic** or, as I like to call them, **monster** servers. Monolithic applications are developed and deployed as a single unit. In case of Java, the end result is often a single WAR or JAR file. Same is true for C++, .Net, Scala and many other programming languages.

Most of the short history of applications development is marked by continuous increment in sizes of applications we develop. As time passes we're adding more and more to our applications continuously **increasing their complexity and size** and **decreasing our development, testing and deployment speed**.

With time we started dividing our applications into layers: presentation layer, business layer, data access layer, etc. This separation is more logical than physical. While development got a bit easier we still needed to test and deploy everything every time there was a change or a release. It is not uncommon in enterprise environments to have applications that take hours to build and deploy. Testing, especially regression, tends to be a nightmare that in some cases lasts for months. As time passes, our ability to make changes that affect only one module is decreasing. The main objective of layers is to make them in a way that they can be easily replaced or upgraded. That promise was never really fulfilled. Replacing something in big monolithic applications is almost never easy and without risks.  

Scaling such servers means scaling the entire application producing very unbalanced utilization of resources. If we need more resources we are forced to duplicate everything on a new server even if a bottleneck is one module.


What are microservices?
=======================

Microservices are an approach to architecture and development of a single application composed of small services. The key to understanding microservices is their independence. Each is developed, tested and deployed separately from each other. Each service runs as a separate process. The only relation between different services is data exchange accomplished through APIs they're exposing. On top of microservices there is often a lightweight server that makes sure that all requests are redirected to an appropriate microservice.

Key aspects of microservices are:

* They do one thing or are responsible for one functionality.
* Each microservice can be built by any set of tools or languages since each is independent from others.
* Real loose coupling since each microservice is physically separated from others.
* Relative independence between different teams developing different microservices (assuming that APIs they expose are defined in advance).
* Easier testing and continuous delivery or deployment

One of the problems with microservices is the decision when to use them. At the beginning, while application is still small, problems that microservices are trying to solve do not exist. However, once the application grows and the case for microservices can be made, the cost of switching to a different architecture style might be too hard. Experienced teams might use microservices from the very start knowing that technical debt they might have to pay later will be more expensive than working with microservices from the very beginning. Often, as it was the case with Netflix, eBay and Amazon, monolithic applications start evolving towards microservices gradually. New modules are developed as microservices and integrated with the rest of the system. Once they prove their worth, parts of the existing monolithic application gets refactored into microservices.

Arguments against microservices
===============================

Major argument against microservices is increased operational and deployment complexity. This argument is true but thanks to relatively new tools it can be mitigated. Configuration Management (CM) tools can handle environment setups and deployments with relative ease. Utilization of containers with [Docker](https://www.docker.com/) greatly reduces deployment pains that microservices can cause. CM tools together with Docker allow us to deploy and scale microservices easily. An example can be found in the article [Continuous Deployment: Implementation with Ansible and Docker](http://technologyconversations.com/2014/12/29/continuous-deployment-implementation-with-ansible-and-docker/). In my opinion, this argument usually does not take in account advances we saw during last years and is greatly exaggerated. That does not mean that part of the work is not shifted from development to devops. It definitely is. However, benefits are in many cases bigger than inconvenience that increased deployment complexity produces.

Another counter argument is reduced performance produced by remote process calls. Internal calls through classes and methods are faster and this problem cannot be removed. How much that loss of performance affects a system depends from case to case. Important factor is how we split our system. If we take it towards the extreme with very small microservices (some propose that they should not have more than 10-100 LOC) this impact might be considerable. I like to create microservices organized around funcionality like users, shopping cart, products, etc. This reduces amount of remote process calls. Also, it's important to note that if calls from one microservice to another is going through fast interlan LAN, negative impact is relatively small.

Advantages
==========

Following are only few advantages that microservices can bring. That does not means that same advantages are not brough with different types of architecture but that with microservices they might be a bit more prominent that with some other options.

Scaling
-------

Scaling microservices is much easier than monolithic applications. While in the later case we duplicate the whole application to a new machine, with microservices we duplicate only those that need scaling. Not only that we can scale what needs to be scaled but we can distribute things better. We can, for example, put service that has heavy utilization of CPU together with another one that uses a lot of RAM while moving a second, CPU demanding service, to a different another hardware.


Best practices
==============

Most of the following best practices can be applied to services oriented architecture in general. However, with microservices they become even more important. Due to a potentially big number of microservices deployed, problems that might get occur are multiplied exponentially. 

Containers
----------

Dealing with many microservices where each is potentially written in a different programming language, requires a different (hopefully light) server or uses a different set of libraries can easily become a very complex endeavour. If each service is packed as a container, all those problems will go away. All we have to do is run the container with, for example, Docker and trust than everything that microservice needs is inside it. 

Proxy microservices or API gateway
----------------------------------

Big enterprise front-ends might need to invoke tens or even hundreds of HTTP requests (as is the case with [Amazon.com](http://www.amazon.com/)). Requests often take more time to be invoked than to receive response data. Proxy microservices might help in that case. Their goal is to invoke different microservices and return an aggregated service. They should not contain any logic but simply group several responses together and responde with aggregated data to the consumer.

Rever proxy
-----------

Never expose microservice API directly. If there isn't some type of orchestrator, dependency between the consumer and microservices becomes so big that it might remove freedome that microservices are supposed to give us. Lightweight servers like [nginx](http://nginx.org/) and [Apache Tomcat](http://tomcat.apache.org/) are very good at performing reverse proxy tasks and can easily be employed with very little overhead. Please consult [Continuous Deployment: Implementation](http://technologyconversations.com/2014/12/08/continuous-deployment-implementation/) article for one possible way to employ reverse proxy with Docker and few other tools.
 
Minimalistic approach
---------------------

Microservices should contain only packages, libraries and frameworks that they really need. The smaller they are, the better. This is quite in contrast with the approach used with monolithic applications. While previously we might have used JEE servers like JBoss that packed all the tools that we do, might or might not need, microservices work best with much more minimalistic solutions. Having hundreds of microservices with each of them having a full JBoss server becomes overkill. [Apache Tomcat](http://tomcat.apache.org/), for example, is a much better solution. I tend to go for even smaller solutions with, for example, [Spray](http://spray.io/) as a very lightweight RESTful API solution. Don't pack what you don't need.
 
Same approach should be applied to OS level as well. If we're deploying microservices as Docker containers, [CoreOS](https://coreos.com/) might be a better solution than, for example, Red Hat or Ubuntu. It's free from things we do not need allowing us to better utilize resources.
  
Configuration management is a must
----------------------------------

As the number of microservices grows, the need for Configuration Management (CM) increases. Deploying many microservices without tools like [Puppet](http://puppetlabs.com/), [Chef](https://www.chef.io/) or [Ansible](http://www.ansible.com/) (just to name few) quickly becomes a nightmare. Actually, not using CM tools for any but simplest solutions is a waste with or without microservices.

TODO
====

* Innovation (Changes, different frameworks, programming languages...)
* Explain difference between separation into layers and functional separation of microservices
* Pros: small (code easier to understand, IDE faster to work in, starup and deployment much faster), CD (can be deployed independently), better at scaling (can be multiplied easier and better utilization of needed resources (i.e. memory, CPU, HD, etc)), fault isolation and auto-recovery (self healing), no need for long term commitment (can utilize any programming language, framework or server), easier refactoring, failure due to change (for example server) has less impact.
* DB included in microservice
* Crossfunctional: UI, API, DB, etc.
* Method invocation vs APIs
* Right tool for the job (different programming languages, servers, DBs, etc)
* API versioning
* Decentralized data storage
* Linux example with pipes
* Diagrams: monolith, UI, business/DAO, DB separated, microservices
* Shifting complexity from development to CM
* X-axis scaling: multiple identical applications behind a load balancer
* Z-axis scaling: multiple identical applications behind a load balancer but each server is responsible only for a subset of data 
* Y-axis scaling: functional decomposition
* Split UI?
* Resources utilization