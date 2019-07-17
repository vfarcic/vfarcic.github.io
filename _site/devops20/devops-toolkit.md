The DevOps 2.0 Toolkit
======================

When Agile appeared, it solved (some of) the problems we were facing at that time. It changed the idea that months-long iterations were the way to go. We learned that delivering often provides numerous benefits. It taught us to organize teams around all the skills required to deliver iterations, as opposed to horizontal departments organized around technical expertise (developers, testers, managers, and so on). It thought us that automated testing and continuous integration are the best way to move fast and deliver often. Test-driven development, pair-programming, daily stand-ups, and so on. A lot changed since waterfall days.

As a result, **Agile changed the way we develop software, but it failed to change how we deliver it**.

Now we know that what we learned through Agile is not enough. The problems we are facing today are not the same as those we were facing back then. Hence, DevOps movement emerged. It thought us that operations are as important as any other skill and that teams need to be able not only to develop but also to deploy software. And by deploy, I mean **reliably deploy often, at scale, and without downtime**. In today's fast-paced industry that operates at scale, operations require development, and development requires operations. DevOps is, in a way, the continuation of Agile principles that, this time, included operations into the mix.

What is DevOps? It is a cross-disciplinary community of practice dedicated to the study of **building**, **evolving** and **operating** **rapidly-changing** **resilient systems** at **scale**. It is as much a cultural as technological change in the way we deliver software, from requirements all the way until production.

Let's explore technological changes introduced by DevOps that, later on, evolved into **DevOps 2.0**.

By adding operations into existing (Agile) practices and teams, DevOps united, previously excluded, parts of organizations and thought us that most (if not all) of what we do after committing code to a repository can be automated. However, it failed to introduce a real technological change. With it, we got, more or less, the same as we had before but, this time, automated. Software architecture stayed the same but we were able to deliver automatically. Tools remained the same, but were used to its fullest. Processes stayed the same but with less human involvement.

DevOps 2.0 is a reset. It tries to redefine (almost) everything we do and provide benefits modern tools and processes provide. It introduces changes to processes, tools, and architecture. It enables continuous deployment at scale and self-healing systems.

In this blog series, I'll focus on tools which, consequently, influence processes and architecture. Or, is it the other way around? It's hard to say. Most likely each has an equal impact on the others. Never the less, today's focus are tools.

Configuration Management (The DevOps 2.0 Toolkit)
-------------------------------------------------

Configuration management (CM) or provisioning tools have been around for quite some time. They are one of the first types of tools adopted by operation teams. They removed the idea that servers provisioning and applications deployment should be manual. Everything, from installing base OS, through infrastructure setup, all the way until deployment of services we are developing, moved into the hands of tools like CFEngine, Puppet, and Chef. They removed operations from being the bottleneck. Later on, they evolved into the self-service idea where operators could prepare scripts in advance and developers would need only to select how many instances of a particular type they want. Due to the promise theory, those tools are based on, by running them periodically we got self-healing in its infancy.

The most notable improvement those tools brought is the concept of infrastructure defined as code. Now, we can put definitions into code repository and use the same processes we are already accustomed with the code we write. Today, everything is (or should be) defined as code (infrastructure included), and the role of UIs is (or should be) limited to reporting.

With the emergence of Docker, configuration management and provisioning continues having a critical role but the scope of what they should do got reduced. They are not in charge of deployment anymore. Other tools do that. They do not have to set up complicated environments since many things are now packed into containers. Their main role is to define infrastructure. We use them to create private networks, open ports, create users, and other similar tasks.

For those, and other reasons, adoption of simpler (but equally powerful) tools become widespread. With its push system and a simple syntax, **Ansible got hold on the market** and, today, is my CM weapon of choice.

The real question is why did Docker take away deployment from CM tools?

Containers and Immutable Deployments (The DevOps 2.0 Toolkit)
-------------------------------------------------------------

Even though CM alleviated some of the infrastructure problems, it did not make them go away. The problem is still there, only in a smaller measure. Even though it is now defined as code and automated, infrastructure hell continuous to haunt us. Too many, often conflicting dependencies quickly become a nightmare to manage. As a result, we tended to define standards. You can use only JDK7. Web server must be JBoss. These are the mandatory libraries. And so on, and so forth. The problem with such standards is that they are an innovation killer. They prevent us from trying new things (at least during working hours).

We should also add testing into the mix. How do you test a Web application on many of browsers? How do you make sure that your commercial framework works on different operating systems and with different infrastructure? The list of testing combinations is infinite. More importantly, how do we make sure that testing environments are exactly the same as production? Do we create a new environment every time a set of tests is run? If we do, how much time such an action takes?

CM tools were not addressing the cause of the problem but trying to tame it. The difficulty lies in the concept of mutable deployments. Every release brings something new and updates the previous version. That, in itself, introduces a high level of unreliability.

The solution to those, and a few other problems, lies in immutable deployments. As a concept, immutability is not something that came into being yesterday. We could create a new VM with each release and move it through the deployment pipeline all the way until production. The problem with VMs, in this context, is that they are heavy on resources and slow to build and instantiate. We want both fast and reliable. Either of those without the other does not cut in today's market. Those are some of the reasons why Google has been using containers for a long time. Why didn't everyone use containers? The answer is simple. Making containers work is challenging and that's where Docker enters the game. First, they made containers easy to use. Then they extended them with some of the things that we, today, consider a norm.

**With Docker we got an easy way to create and run containers that provide immutable and fast deployments and isolation of processes. We got a lightweight and self-sufficient way to deploy applications and services without having to worry about infrastructure.**

However, Docker itself proved not to be enough. Today, we do not run things on servers but inside clusters and we need more than containers to manage such deployments.

Cluster Orchestration (The DevOps 2.0 Toolkit)
----------------------------------------------

When I was an apprentice, I was thought to treat servers as pets. I would treat them with care. I would make sure that they are healthy and well fed. If one of them gets sick, finding the cure was of utmost priority. I even gave them names. One was Garfield, and the other was Gandalf. Most companies I worked for had a theme for naming their servers. Mythical creatures, comic book characters, animals, and so on. Today, when working with clusters, the approach is different. Cloud changed it all. Pets become cattle. When one of them gets sick, we kill them. We know that there's almost an infinite number of healthy specimens so curing a sick one is a waste of time. When something goes wrong, destroy it and create a new one. Our applications are built with scaling and fault tolerance in mind, so a temporary loss of a single node is not a problem. This approach goes hand in hand with a change in architecture.

If we want to be able to deploy and scale easily and efficiently, we want our services to be small. Smaller things are easier to reason with. Today, we are moving towards smaller, easier to manage, and shorter lived services. **The excuse for not defining our architecture around microservices is gone**. They were producing too many problems related to operations. After all, the more things to deploy, the more problems infrastructure department has trying to configure and monitor everything. With containers, each service is self-sufficient and does not create infrastructure chaos thus making microservices an attractive choice for many scenarios.

With microservices packed inside containers and deployed to a cluster, there is a need for a different set of tools. There is the need for cluster orchestration. Hence, we got Mesos, Kubernetes, and Docker Swarm (just to name a few). With those tools, the need to manually SSH into servers disappeared. We got an automated way to deploy and scale services that will get rescheduled in case of a failure. If a container stops working, it will be deployed again. If a whole node fails, everything running on it will be moved to a healthy one. And all that is done without human intervention. We design a behavior and let machines take over. **We are closer than ever to a widespread use of self-healing systems that do not need us**.

While solving some of the problems, cluster orchestration tools created new ones. Namely, if we don't know, in advance, where will our services run, how to we configure them?

Service Discovery (The DevOps 2.0 Toolkit)
------------------------------------------

Service discovery is the answer to the problem of trying to configuration our services when they are deployed to clusters. In particular, the problem is caused by a high level of dynamism and elasticity. Services are not, anymore, deployed to a particular server but somewhere within a cluster. We are not specifying the destination but the requirement. Deploy anywhere as long as there is the specified amount of CPUs and memory, certain type of hard disk, and so on.

Static configuration is not an option anymore. How can we statically configure a proxy if we do not know where will our services be deployed? Even if we do, they will be scaled, descaled, and rescheduled. The situation might change from one minute to another. If a configuration is static, we would need an army of operators monitoring the cluster and changing the configuration. Even if we could afford it, the time required to apply changes manually would result in downtime and, probably, prevent us from continuous delivery or deployment. **Manual configuration of our services would be another bottleneck that, even with the rest of improvements would slow down  everything**.

Hence, service discovery enters the scene. The idea is simple. Have a place where everything will be registered automatically and from where others can request info. It always has three components. **Service discovery consists of a registry, registration process, and discovery or templating**.

There must be a place where information is stored. That must be a kind of a lightweight database that is resistant to failure. It must have an API that can be used to put, get, and remove data. Some of the commonly used tools for these types are *etcd* and *Consul*.

Next, we need a way to register information whenever a new service is deployed, scaled, or stopped. *[Registrator](https://github.com/gliderlabs/registrator)* is one of those. It monitors Docker events and puts or removes data from the registry of choice.

Finally, we need a way to change configurations whenever data in the registry is updated. There are plenty of tools in this area, [confd](https://github.com/kelseyhightower/confd) and [Consul Template](https://github.com/hashicorp/consul-template) being just a few. However, this can quickly turn into an endeavor that is too complicated to maintain. Another approach is to incorporate discovery into our services. That should be avoided when possible since it introduces too much coupling. Both approaches to discovery are slowly fading in favor of software-defined networks (SDN). The idea is that SDNs are created around services that form a group so that all the communication is flowing without any predefined values. Instead finding out where the database is, let SDN have a target called DB. That way, your service would not need to know anything but the network endpoint.

Service discovery creates another question. What should we do with a proxy?

Dynamic Proxies (The DevOps 2.0 Toolkit)
----------------------------------------

The decline of hardware proxies started a long time ago. They were too expensive and inflexible even before cloud computing become mainstream. These days, almost all proxies are based on software. The major difference is what we expect from them. While, until recently, we could define all redirections as static configuration files, that changed in favor of more dynamic solutions. Since our services are being constantly deployed, redeployed, scaled, and, in general, moved around, the proxy needs to be capable of updating itself with this ever changing end-point locations.

We cannot wait for an operator to update configurations with every new service (or release) we are deploying. We cannot expect him to monitor the system 24/7 and react to a service being scaled as a result of increased traffic. We cannot hope that he will be fast enough to catch a node failure which results in all services being automatically rescheduled to a healthy node. Even if we could expect such tasks to be performed by humans, the cost would be too high since an increase in the number of services and instanced we're running would mean an increase in workforce required for monitoring and reactive actions. Even if such a cost is not an issue, we are slow. We cannot react as fast as machines can and that discrepancy between a change in the system and proxy reconfiguration could, at best, result in performance issues.

Among software based proxies, [Apache](https://httpd.apache.org/) ruled the scene for a long time. Today, age shows its face. It is rarely the weapon of choice due to its inability to perform well under stress and relative inflexibility. Newer tools like **[nginx](http://nginx.org/) and [HAProxy](http://www.haproxy.org/) took over**. They are capable of handling a vast amount of concurrent requests without posing a severe strain on server resources.

Even *nginx* and *HAProxy* are not enough by themselves. They were designed with static configuration in mind and require us to add additional tools to the mix. An example would be a combination of templating tools like Consul Template that can monitor changes in service registry, modify proxy configurations, and reload them.

Today, we see another shift. Typically, we would use proxy services not only to redirect requests but, also, to perform load balancing among all instances of a single service. **With the emergence of the (new) Docker Swarm (shipped with the Docker Engine release v1.12), load balancing (LB) is moved towards software defined network (SDN)**. Instead performing LB among all instances, a proxy would redirect a request to an SDN end-point which, in turn, would perform load balancing.

Services architecture is switching towards microservices and, as a result, deployment and scheduling processes and tools are changing. Proxies and expectations we have from them are following those changes.

The deployment frequency is becoming higher and higher, and that poses another question. How do we deploy often without any downtime?

Zero-Downtime Deployment (The DevOps 2.0 Toolkit)
-------------------------------------------------

In most cases, we employ the deployment strategies that result in the current release being replaced with the new one. The old release is stopped, and the new one is deployed in its place. Such a set of actions produces downtime. During a (hopefully) short period neither release is running. As a result, there is a millisecond, second, a minute, or even a longer period during which our service is inaccessible. In today's market, such a strategy is unacceptable. If our software is not operational, our users will go somewhere else. Even if they don't, downtime produces all other kinds of undesirable effect. Money is lost, the support team is overwhelmed with calls, reputation is damaged, and so on. We are expected to be uo and running 24/7. That's the part of the reason why iterations were long in the past. If we are going to have a downtime produced by a deployment of a new release, better not do it often. However, today we cannot afford not to do release software often. Our users expect constant improvements. Even if they don't, we do. Short iterations proved its value on all levels. Today, we see a continuous redefinition of what *short* means. While, not so long ago, short meant months or weeks, today it means multiple times a day. The ultimate goal? Every commit deployed to production. If deployments produce downtime, the previous sentence could be translated to *every commit creates downtime*. We don't want that. So, how can we avoid deployment downtime? Or, to put it in other words, how can we accomplish **zero-downtime deployments**?

Over time, **two approaches proved to be the most reliable way to accomplish zero-downtime deployments; blue-green and rolling updates**.

In its essence, **the idea behind blue-green deployments is that at least one release is running at any given moment**. The process is as follows.

We deploy the first release (we'll call it *blue*) and configure the proxy to redirect all requests to it. When the time comes, we deploy the second release (we'll call it *green*) in parallel with the previous (*blue*). At this moment, the proxy is still redirecting all requests to the *blue* release. Once our newly deployed service is running, we can proceed with automated testing (in production) or any other type of deployment validation. When we are convinced that the new release is not only running but also working as expected, we can reconfigure the proxy to redirect all requests to it. Only once this process is finished, and all previously initiated requests received their responses, we can stop the old (*blue*) release. With each new release, the same process is be repeated over and over again. The third release would be *blue*, the fourth, *green*, and so on.

**The idea behind rolling updates is to gradually upgrade the release, one, or a few instances at the time**.

Let's say that we have five instances of a service running in production. When deploying the new release, we would replace one instance of the previous release and monitor the outcome during some time. As the result, we would have one instance of the new release and four instances of the old. Later on, if no anomaly is detected, we would repeat the process and end up having two instances running the new release and three instances running the old one. We would continue with the same process until all instances are running the new release. If an anomaly (undesired behavior) is detected, instances running the new release would be stopped, and the old release would be rolled back.

The important thing to note is that both processes assume that the new release is, as a minimum, compatible with the previous. That is most evident in APIs. Since both methods assume that two releases will run at the same time, we cannot guarantee which one will be accessed by a user. The same can be said for databases. Schema changes need to be done in a way that they work with not only the new but also with the current release.

Needless to say, those processes are easiest to implement when architecture is oriented towards microservices. That does not mean that *blue-green deployment* and *rolling updates* do not work with other types of architecture. They do. The major difference is that the smaller the service, the faster the process. Also, smaller services require less resources. That applies in particular to the case of *blue-green deployments* which, during a short period, duplicate resource usage.

The advantage of *blue-green deployments* is that we can test the deployment before making it available to the general public. On the other hand, *rolling updates* might be more appropriate if a service is scaled to a large number of instances and running both releases in parallel would put too much demand on resources.

Now that there is no downtime caused by the deployment process, the door opens for the implementation of *continuous deployments*.

Continuous Integration, Delivery, And Deployment (The DevOps 2.0 Toolkit)
-------------------------------------------------------------------------

We cannot discuss continuous deployment without, briefly, going through the concepts behind continuous integration.

Continuous integration (CI) is represented by an automated integration flow. Every commit is detected by a CI tool of choice, the code is checked out from the version control, and the integration flow is initiated. If any of the steps of the flow fails, the team prioritizes fixing the broken build over any other activity. For continuous integration to be truly continuous, the team must merge into the main branch often (at least once a day) or, even better, commit directly to it. Without such a strategy, we have automated, but not continuous integration.

**The problem with continuous integration is that there is no clear objective. We know where it starts (with each commit), but we don't know where it ends.** The process assumes that there are manual actions after the automated flow, but it does not specify where the automation stops and humans take over. As a result, many companies jumped into the CI train and ended without tangible results. A part of testing continued being manual and time to market did not decrease as much as hoped. After all, the total speed is the speed of the slowest. With CI we start fast only to end with a crawl. That does not mean that CI does not provide a lot of benefits. It's just that they are not enough for what is expected from us today. Simply put, **continuous integration is not a process that produces production ready software**. It only gets us half-way there.

Then came continuous delivery. You're practicing it when:

* You are already doing continuous integration. Continuous delivery is an extended version of the automation required for CI.
* Each build that passed the whole flow is deployable. With continuous delivery, anyone can press a button and deploy any build to production. The decision whether to deploy or not is not technical. All (green) builds are production ready. Whether one is deployed or not is based on a decision when should a certain feature be available to our users.
* The team prioritizes keeping software deployable. If a build fails, fixing the problem is done before anything else.
* Anybody can get fast and automated feedback on production readiness.
* Software can be deployed by pressing a single button.

If any of those points is not entirely fulfilled, you are not doing continuous delivery. You are, most likely, still in the continuous integration phase.

This poses a question what continuous deployment is.

**While continuous delivery means that every commit can be deployed to production, continuous deployment results in every commit being deployed to production**. There no button to push. There is no decision to make. Every commit that passed the automated flow is deployed to production.

Now that we have the definitions and understand the goals of continuous delivery or deployment, let us try to, briefly, define what should we expect from the tools.

CD, often, results in a complex set of steps. There are many things to be done if the process will be robust enough to give us enough confidence to deploy to production without human intervention. Therefore, the tool of choice needs to be able to define complex flows. Such flows are complicated, and sometimes even impossible to define through UIs. They need to be expressed as code.

Another thing to note is that the tool should not prevent team's autonomy. If a team that produces commits that are automatically deployed (or ready to be deployed )to production is not autonomous, the continuous ceases to exist. They (members of the team) need to have the ability to define and maintain the definition of the CD flow so that, whenever it requires changes, they can implement them without waiting for someone else to do them. If autonomy is the key, the tool cannot have the flows centralized. The code that defines a flow should reside in the same repository as the code of the service (or the application) the team is maintaining.

If we add the need for the tool to be capable of operating on a large scale, there are only a few products available today. One of them is, without a doubt, [Jenkins](https://jenkins.io/) combined with the [Pipeline](https://jenkins.io/solutions/pipeline/) defined as [Jenkinsfile](https://jenkins.io/doc/pipeline/jenkinsfile/). Is it the only product that exerts the features we require from a modern CD tool? That's hard to say since new tools are emerging on almost daily basis. What is true is that Jenkins proved itself over and over again. It, in a way, defined CI processes and, today, continues leading the CD movement.

Are We Done Now? (The DevOps 2.0 Toolkit)
-----------------------------------------

Are we, finally, done with an overview of the modern DevOps toolkit that should reside in our toolbelt? Not even close! Once we adopt all the tools and practices we discussed, there is still much to do.

Automating the process all the way until deployments to production is only half of the story. We need to evaluate (and automate) processes that will make sure that our software continues running and behaves as desired. Such a system would need to exert some level of self-healing, not much different than the processes that perform similar functions in our bodies. Viruses constantly attack us, our cells are dying, we are getting hurt, and so on. To cut the long story short, if our bodies were not able to self-heal, we would not last a day. And, yet, we, and life itself, continue to persist no matter what happens. We should learn from ourselves (and evolution) and apply those lessons to the systems we're building.

We haven't touched the cultural and architectural changes required by the adoption of new processes and technology. The subject is so vast that it requires much more than a series of posts.

Even though we only scratched the surface, I hope you got some ideas and a possible direction to take. If you are interested in more details in the form of (mostly) hands-on practices, please consider purchasing [The DevOps 2.0 Toolkit: Automating the Continuous Deployment Pipeline with Containerized Microservices](http://www.amazon.com/dp/B01BJ4V66M) book.

The DevOps 2.0 Toolkit
----------------------

If you liked this article, you might be interested in [The DevOps 2.0 Toolkit: Automating the Continuous Deployment Pipeline with Containerized Microservices](http://www.amazon.com/dp/B01BJ4V66M) book.

The book is about different techniques that help us architect software in a better and more efficient way with *microservices* packed as *immutable containers*, *tested* and *deployed continuously* to servers that are *automatically provisioned* with *configuration management* tools. It's about fast, reliable and continuous deployments with *zero-downtime* and ability to *roll-back*. It's about *scaling* to any number of servers, the design of *self-healing systems* capable of recuperation from both hardware and software failures and about *centralized logging and monitoring* of the cluster.

In other words, this book envelops the full *microservices development and deployment lifecycle* using some of the latest and greatest practices and tools. We'll use *Docker, Ansible, Ubuntu, Docker Swarm and Docker Compose, Consul, etcd, Registrator, confd, Jenkins, nginx*, and so on. We'll go through many practices and, even more, tools.

The book is available from Amazon ([Amazon.com](http://www.amazon.com/dp/B01BJ4V66M) and other worldwide sites) and [LeanPub](https://leanpub.com/the-devops-2-toolkit).