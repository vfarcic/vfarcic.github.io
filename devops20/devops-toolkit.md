The DevOps 2.0 Toolkit
======================

When Agile appeared, it solved (some of the) problems we were facing at that time. It changed the idea that months long iterations were the way to go. We learned that delivering often provides numerous benefits. It taught us to organize teams around the idea of having all the skills required to deliver iterations, as oposed to horizontal departments organized around technical skills (developers, testers, managers, and so on). It thought us that automated testing and continuous integration we the best way to move fast and deliver often. Test-driven development, pair-programming, daily stand-ups, and so on. We changed a lot since waterfall days.

**Agile changed the way we develop software, but it failed to change how we deliver it.**

Now we know that what we learned back then is not enough. The problems we are facing today are not the same as problems we were facing back then. Hence, DevOps movement emerged. It thought us that operations are as important as any other skill and it must join the team. In today's fast paced industry that operates at scale, operations require development, and development requires operations. DevOps is, in a way, continuation of Agile principles that, this time, includes operations into the mix.

What is DevOps? It is a cross-disciplinary community of practice dedicated to the study of **building**, **evolving** and **operating** **rapidly-changing** **resilient systems** at **scale**. It is as much a cultural as technological change in the way we deliver software, from requirements all the way until production. Today, I will explore only the technological changes introduced by DevOps that, later on, evolved into **DevOps 2.0**.

By adding operations into existing (Agile) practices and teams, DevOps united, previously excluded, parts of organizations and thought us that most (if not all) of what we do after committing code to a repository can be automated. However, it failed to introduce a real technological change. With it, we got, more or less, the same as we had before but, this time, automated. Applications and services architecture stayed the same but was deliver automatically. Tools stayed the same, but it was used to its fullest. Processes stayed the same but with less human involvement.

DevOps 2.0 is a reset. It tries to redefine (almost) everything we do and provide benefits modern tools and processes provide. It introduces changes to processes, tools, and architecture. It enables continuous deployment at scale and self-healing systems. Today, I'll focus on tools which, consequently, influence processes and architecture. Let's, quickly, go through some of them.

Configuration Management
------------------------

Configuration management (CM) or provisioning tools have been around for quite some time. They are one of the first type of tool adopted by operation teams. They removed the idea that servers provisioning and applications deployment should be manual. Everything, from installing base OS, through infrastructure setup, all the way until deployment of services we are developing, moved into hands of tools like CFEngine, Puppet, and Chef. They removed operations from being a bottleneck. Later on, they evolved into self-service idea where operators could prepare scripts in advance and developers would need only to select how many instances of a certain type they want. Due to promise theory they are based on, by running them periodically, we got self-healing in its infancy. This were automated and proactive.

The most important improvement those tools brought is the concept of infrastructure defined as code. Now, we can put definitions into code repository and use the same processes we are already accustomed with the code we write. Today, everything is code (infrastructure included), and the role of UIs is limited to stats and reports.

Today, with the emergence of Docker, configuration management and provisioning continues having a very important role but the scope of what they should do got reduced. They are not in charge of deployment any more, other tools do that. They do not have to set up complicated environments since many things are now packed into containers. Their main role is to define infrastructure. Create private networks, open ports, create users, and other similar tasks.

For those, and other reasons, adoption of simpler (but equally powerful) tools become widespread. With it's push system and a simple syntax, **Ansible got hold on the market** and, today, is my tool of choice.

Why did Docker take away deployment from CM tools?

Containers and Immutable Deployments
------------------------------------

Even though CM alleviated some of the infrastructure problems, it did not make it go away. The problem is still there in a smaller measure. Even though it is now defined as code and automated, infrastructure hell continuous to haunt us. Too many, often conflicting dependencies quickly become a nightmare to manage. As a result, we tended to define standards. You can use only JDK7, web server must be JBoss, these are the mandatory libraries, and so on.

Then we should add testing into the mix. How do you test a Web application on many of browsers? How do you make sure that your comercial framework works on different operating systems and with different infrastructure? The list of testing combinations is infinite. More importantly, how do we make sure that testing environment is exactly the same as production? Do we create a new environement every time a set of tests is run? If we do, how much time such an action takes?

CM tools were not addressing the cause of the problem but trying to tame it. The difficulty lies in the concept of mutable deployments. Every release brings something new and updates the previous version. That, in itself, introduces a high level of unreliability.

The solution to those, and a few other problems lies in immutable deployments. As a concept, immutability is not new. We could create a new VM with each release and move it through the deployment pipeline all the way until production. The problem with VMs, in this context, is that they are heavy on resources and slow to build and instantiate. We want both fast and reliable. Either of those without the other does not cut in today's market. Those are some of the reasons why Google has been using containers for a long time. Why didn't everyone use containers? The answer is simple. Making containers work is difficult. That's where Docker enters the game. First they made containers easy to use. Then, they extended them with some of the things that were reserved only for a selected few.

**With Docker we got an easy way to create and run containers that provide immutable and fast deployments and isolation of processes. We got a lighweight and self-sufficient way to deploy applications and services without having to worry about infrastructure.**

However, Docker itself proved not to be enough. Today, we do not run things on servers but inside clusters and we need more than containers to manage such deployments.

Cluster Orchestration
---------------------

When I was an apprentice, I was thought to treat servers as pets. I would treat them with care. I would make sure that they are healthy and well fed. If one of them gets sick, finding the cure was of utmost priority. I even game them names. One was Garfield, the other was Gandalf. Most companies I worked for had a theme for naming their servers. Mythical creatures, comic book characters, animals, and so on. Today, when working with clusters, the approach is different. Cloud changed it all. Pets become cattle. When one of them gets sick, we kill them. We know that there's almost an infinite number of healthy specimens so curing a sick one is a waste of time. When something goes wrong, destroy it and create a new one. Our applications are built with scaling and fault tolerance in mind so a temporary loss of a single node is not a problem. This goes hand in hand with a change in architecture.

If we want to be able to deploy and scale easily and efficiently, we want our services to be small. Smaller things are easier to reason with. **The excuse for not defining our architecture around microservices is gone**. They were producing too many problems related with operations. After all, the more things to deploy, the more problems infrastructure department has trying to configure and monitor everything. With containers, each service is self-sufficient and does not create infrastructure chaos making microservices an attractive choice for many scenarios.

With microservices packed inside containers and deploy to a cluster, there is a need for a different set of tools. There is a need for cluster orchestration. Hence, we got Mesos, Kubernetes, and Docker Swarm (just to name a few). With those tools, the need to manual SSH into servers disappeared. We got an automated way to deploy and scale services that will get rescheduled in case of a failure. If a container stops working, it will be deployed again. If a whole node fails, everything running on it will be moved to a healthy one. And all that without human intervention. We design a behavior and let machines take over. **We are closer then ever to a widespread use of self-healing systems that do not need us**.

While solving some of the problems, cluster orchestration tools created new ones. Namely, if we don't know, in advance, where will our services run, how to we configure them?

Service Discovery
-----------------

Service discovery is the answer configurations of our services when deployed to clusters that exhibit a high level of dynamism and elasticity. Static configuration is not an option any more. How can we statically configure a proxy if we do not know where are services will be deployed. Even if we do, they will be scale, descaled, and rescheduled. The situation might change from one minute to another. If configuration is static, we would need an army of operators monitoring the cluster and changing the configuration. Even if we could afford it, downtime produced by manually applying changes would result in downtime and, probably, prevent us from continuous delivery or deployment. **Manual configuration of our services would be another bottleneck that, even with the rest of improvements we discussed, would slow everything down**.

Hence, service discovery enters the scene. The idea is simple. Have a place where everything will be registered automatically and from where others can request info. It always has three components. **Service discovery consists of a registry, registration process and discovery or templating**.

There must be a place where information is stored. That must be a kind of a lightweight database that is resistant to failure. It must have an API that can be used to put and get data. Some of the commonly used tools for these types are *Zookeeper*, *etcd*, and *Consul*.

Next, we need a way to register information whenever a new service is deployed, scaled, or stopped. *[Registrator](https://github.com/gliderlabs/registrator)* is one of those. It monitors Docker events and puts or removed data from a Registry of choice. If one of the cluster orchestration tool are adopted, they tend to have registration process incorporated.

Finally, we need a way to change a configurations whenever data in the registry is updated. There are plenty of tools in this area, *confd* and *Consul Template* being just a few. This can quickly turn into an endeavour that is too complicated to maintain. Another approach is to incorporate discovery into our services. That should be avoided when possible since it introduces too much coupling. Both approaches to discovery are slowly fading in favour of software defined networks (SDN). The idea is that SDNs are created around services that form a group so that all the communication is going without any predefined values. Instead finding out where the database is, let SDN have a target called DB. That way, your service would not need to know anything but network endpoint.

Service discovery creates another question. What should we do with a proxy?

Dynamic Proxies
---------------

TODO: Continue from [http://localhost:8080/devops20/index.html#/proxy](http://localhost:8080/devops20/index.html#/proxy)