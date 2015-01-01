Introduction
============

At the beginning applications were simple and small due to simple requirements. With time requirements and needs grew and with them our applications became bigger and more complex. That resulted in monolithic servers developed and deloyed as a single unit. Microservices are, in a way, return to basics with simple applications that are fulfilling todays needs for complexity by working together through utilization of each others APIs.

What are monolithic servers?
============================

Microservices are best explained when compared with their opposite; **monolithic** or, as I like to call them, "monster" servers. Monolithic applications are developed as a single unit or project. In case of Java, the end result is often a single WAR or JAR file. Same is true for C++, .Net, Scala and many other programming languages.

Most of the short history of applications development is marked by continuous increment in sizes of applications we develop. As time passes we're adding more and more to our applications continuously **increasing their complexity and size** and **decreasing our development, testing and deployment speed**.

With time we started dividing our applications into layers; presentation layer, business layer, data access layer, etc. This separation is more logical than physical. While development got a bit easier we still needed to test and deploy everything every time there was a change or a release. It is not uncommon in enterprise environments to have applications that take hours to build and deploy. Testing, especially regression, tends to be a nightmare that in some cases lasts for months. As time passes, our ability to make changes that affect only one module is decreasing. The main objective of layers is to make them in a way that they can be easily replaced or upgraded. That promise was never really fulfilled. Replacing something in big monolithic applications is almost never easy and without risks.  

Scaling of such servers means scaling of the entire application producing very unbalanced utilization of resources. If we need more resources we are forced to get duplicate everything on a new server even if a bottleneck is one module.


What are microservices?
=======================

Microservices are an approach to architecture and development of a single application composed of small services. The key to understanding microservices is their independence. Each is developed, tested and deployed separately from each other. Each service should run in a separate process. The only relation between different services is data exchange accomplished through APIs they're exposing. On top of microservices there is often an lightweight server that makes sure that all requests are redirected to an appropriate microservice. Key aspects of microservices are:

* They do one thing or are responsible for one functionality
* Each microservice can be built by any set of tools or languages since each is independent from others
* Loose coupling
* Relative independence between different teams developing different microservices (assuming that APIs they expose are defined in advance)
* Easier testing and continuous delivery or deployment

One of the problems with microservices is the decision when to use them. At the beginning, while application is still small, problems that microservices are trying to solve do not exist. However, once the application grows and the case for microservices can be made, the cost of switching to a different architecture style might be too hard. Experiences teams might use microservices from the very start knowing that technical debt they might have to pay later on will be more expensive than working with microservices from the very begining. Often, as it was the case with Netflix, eBay and Amazon, monolithic applications start evolving towards microservices gradually. New modules are developed as microservices and integrated with the rest of the system. Once they prove their worth, parts of the existing monolithic application start getting refactored into microservices.

TODO
====

* Proxy microservices or API gateway (combines responses from microservices and reduces number of consumer requests)
* Docker
* nginx
* CoreOS
* Ansible
* Physical separation
* Scaling
* Innovation (Changes, different frameworks, programming languages...)
* Explain difference between separation into layers and functional separation of microservices
* Pros: small (code easier to understand, IDE faster to work in, starup and deployment much faster), CD (can be deployed independently), better at scaling (can be multiplied easier and better utilization of needed resources (i.e. memory, CPU, HD, etc)), fault isolation and auto-recovery (self healing), no need for long term commitment (can utilize any programming language, framework or server), easier refactoring, failure due to change (for example server) has less impact.
* Cons: remote calls are more expensive than process calls, operational and deployment complexity.
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