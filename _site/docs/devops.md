<!-- .slide: data-background="../img/background/devops21.jpg" -->
# DevOps

Note:
Everyone talks about DevOps. Many are trying to implement it but only a few succeeded to truly harness its power. The reason is simple. DevOps is a huge change in the way we work. It is a cultural and technological shift. Even though DevOps is not the main focus of this workshop, we have to quickly go through it since DevOps processes are very closely related to Docker and containers in general.


<!-- .slide: data-background="../img/background/monolith.jpeg" -->
# Changed everything

---

### Monoliths

### become microservices

## Why now? <!-- .element: class="fragment" -->

Note:
**Monolithic applications** are developed and deployed as a single unit. In the case of Java, the result is often a single WAR or JAR file. Similar statement is true for C++, .Net, Scala and many other programming languages.

Most of the short history of software development is marked by a continuous increment in size of the applications we are developing. As time passes, we're adding more and more to our applications continuously increasing their complexity and size and decreasing our development, testing and deployment speed.

We started dividing our applications into layers: presentation layer, business layer, data access layer, and so on. This separation is more logical than physical, and each of those layers tends to be in charge of one particular type of operations. This kind of architecture often provided immediate benefits since it made clear the responsibility of each layer. We got separation of concerns on a high level. Life was good. Productivity increased, time-to-market decreased and overall clarity of the code base was better. Everybody seemed to be happy, for a while.

With time, the number of features our application was required to support was increasing and with that comes increased complexity. One feature on UI level would need to speak with multiple business rules that in turn require multiple DAO classes that access many different database tables. No matter how hard we try, the sub-division within each layer and communication between them gets ever more complicated and, given enough time, developers start straying from the initial path. After all, a design made initially often does not pass the test of time. As a result, modifications to any given sub-section of a layer tends to be more complicated, time demanding and risky since they might affect many different parts of the system with often unforeseen effects.

As time passes, things start getting worse. In many cases, the number of layers increases. We might decide to add a layer with a rules engine, API layer, and so on. As things usually go, the flow between layers is in many cases mandatory. That results in situations where we might need to develop a simple feature that under different circumstances would require only a few lines of code but, due to the architecture we have, those few lines turn up to be hundreds or even thousands because all layers need to be passed through.

The development was not the only area that suffered from monolithic architecture. We still needed to test and deploy everything every time there was a change or a release. It is not uncommon in enterprise environments to have applications that take hours to test, build and deploy. Testing, especially regression, tends to be a nightmare that in some cases lasts for months. As time passes, our ability to make changes that affect only one module is decreasing. The primary objective of layers is to make them in a way that they can be easily replaced or upgraded. That promise is almost never actually fulfilled. Replacing something in big monolithic applications is hardly ever easy and without risks.

Scaling monoliths often mean scaling the entire application thus producing very unbalanced utilization of resources. If we need more resources, we are forced to duplicate everything on a new server even if a bottleneck is one module. In that case, we often end up with a monolith replicated across multiple nodes with a load balancer on top. This setup is sub-optimum at best.

**Microservices** are an approach to architecture and development of a single application composed of small services. The key to understanding microservices is their independence. Each is developed, tested and deployed separately from each other. Each service runs as a separate process. The only relation between different microservices is data exchange accomplished through APIs they are exposing. They inherit, in a way, the idea of small programs and pipes used in Unix/Linux. Most Linux programs are small and produce some output. That output can be passed as input to other programs. When chained, those programs can perform very complex operations. It is complexity born from a combination of many simple units.

In a way, microservices use the concepts defined by SOA. Then why are they called differently? SOA implementations went astray. That is especially true with the emergence of ESB products that themselves become big and complex enterprise applications. In many cases, after adopting one of the ESB products, the business went as usual with one more layer sitting on top of what we had before. Microservices movement is, in a way, reaction to misinterpretation of SOA and the intention to go back to where it all started. The main difference between SOA and microservices is that the latter should be self-sufficient and deployable independently of each other while SOA tends to be implemented as a monolith.

Let's see what Gartner has to say about microservices. While I'm not a big fan of their predictions, they do strike the important aspect of the market by appealing to big enterprise environments. Their evaluations of market tendencies usually mean that we passed the adoption by greenfield projects, and the technology is ready for the big enterprises. Here's what Gary Olliffe said about microservices at the beginning of 2015.

Microservice architectures promise to deliver flexibility and scalability to the development and deployment of service-based applications. But how is that promise delivered?  In short, by adopting an architecture that allows individual services to be built and deployed independently and dynamically; an architecture that embraces DevOps practices.

Microservices are simpler, developers get more productive and systems can be scaled quickly and precisely, rather than in large monolithic globs. And I haven't even mentioned the potential for polyglot coding and data persistence.

Key aspects of microservices are as follows.

* They do one thing or are responsible for one functionality.
* Each microservice can be built by any set of tools or languages since each is independent of others.
* They are truly loosely coupled since each microservice is physically separated from others.
* Relative independence between different teams developing different microservices (assuming that APIs they expose are defined in advance).
* Easier testing and continuous delivery or deployment.

One of the problems with microservices is the decision when to use them. In the beginning, while the application is still small, problems that microservices are trying to solve do not exist. However, once the application grows and the case for microservices can be made, the cost of switching to a different architecture style might be too big. Experienced teams tend to use microservices from the very start knowing that technical debt they might have to pay later will be more expensive than working with microservices from the very beginning. Often, as it was the case with Netflix, eBay, and Amazon, monolithic applications start evolving towards microservices gradually. New modules are developed as microservices and integrated with the rest of the system. Once they prove their worth, parts of the existing monolithic application gets refactored into microservices as well.

All that being said, microservices are nothing new. They are used for a long time. The real question is why did they become popular now. Why hardly no one talked about them before? **Why are we interested microservices now?**


<!-- .slide: data-background="../img/background/servers.jpg" -->
# Changed everything

---

### OS infrastructure

### moves to containers

### and becomes immutable

## Consequences? <!-- .element: class="fragment" -->

Note:
Dealing with many microservices can quickly become a very complex endeavor. Each can be written in a different programming language, can require a different (hopefully light) application server or can use a different set of libraries. If each service is packed as a container, most of those problems will go away. All we have to do is run the container with, for example, Docker and trust that everything needed is inside it.

Containers are self-sufficient bundles that contain everything we need (with the exception of the kernel), run in an isolated process and are immutable. Being self-sufficient means that a container commonly has the following components.

* Runtime libraries (JDK, Python, or any other library required for the application to run)
* Application server (Tomcat, nginx, and so on)
* Database (preferably lightweight)
* Artifact (JAR, WAR, static files, and so on)

Fully self-sufficient containers are the easiest way to deploy services but pose a few problems with scaling. If we'd like to scale such a container on multiple nodes in a cluster, we'd need to make sure that databases embedded into those containers are synchronized or that their data volumes are located on a shared drive. The first option often introduces unnecessary complexity while shared volumes might have a negative impact on performance. Alternative is to make containers almost self-sufficient by externalizing database into a separate container. In such a setting there would be two different containers per each service. One for the application and the other for the database. They would be linked (preferably through software defined network). While such a combination slightly increases deployment complexity, it provides greater freedom when scaling. We can deploy multiple instances of the application container or several instances of the database depending performance testing results or increase in traffic. Finally, nothing prevents us to scale both if such a need arises.

Being self-sufficient and immutable allows us to move containers across different environments (development, testing, production, and so on) and always expect the same results. Those same characteristics combined with microservices approach of building small applications allows us to deploy and scale containers with very little effort and much lower risk than other methods would allow us.

However, there is a third commonly used combination when dealing with legacy systems. Even though we might decide to gradually move from monolithic applications towards microservices, databases tend to be the last parts of the system to be approved for refactoring. While this is far from the optimal way to perform the transition, the reality, especially in big enterprises is that data is the most valuable asset. Rewriting an application poses much lower risk than the one we'd be facing if we decide to restructure data. It's often understandable that management is very skeptical of such proposals. In such a case we might opt for a shared database (probably without containers). While such a decision would be partly against what we're trying to accomplish with microservices, the pattern that works best is to share the database but make sure that each schema or a group of tables is exclusively accessed by a single service. The other services that would require that data would need to go through the API of the service assigned to it. While in such a combination we do not accomplish clear separation (after all, there is no clearer more apparent than physical), we can at least control who accesses the data subset and have a clear relation between them and the data. Actually, that is very similar to what is commonly the idea behind horizontal layers. In practice, as the monolithic application grows (and with it the number of layers) this approach tends to get abused and ignored. Vertical separation (even if a database is shared), helps us keep much clearer bounded context each service is in charge of.


<!-- .slide: data-background="../img/background/scaling.jpeg" -->
# Changed everything

---

### Servers

### become cluster

## The result? <!-- .element: class="fragment" -->

Note:
We should discuss the high-level strategies before we start exploring tools and processes that will help us create and operate a "real" cluster. How are we going to treat our servers? Are they going to be pets or cattle?

How do you know whether you are treating your servers as pets or cattle? Ask yourself the following question. What will happen if several of your servers went offline right now? If they are pets, such a situation will cause a significant disruption for your users. If they are cattle, such an outcome will go unnoticed. Since you are running multiple instances of a service distributed across multiple nodes, failure of a single server (or a couple of them), would not result in a failure of all replicas. The only immediate effect would be that some services would run fewer instances and would have a higher load. Failed replicas would be rescheduled so the original number would soon be restored. In parallel, failed nodes would be replaced with new VMs. The only adverse effect of a failure of a couple of servers would be increased response time due to lower capacity. After a couple of minutes, everything would get back to normal with failed replicas rescheduled, and failed nodes replaced with new VMs. And the best thing is, it would all happen without manual interaction. If that's how your cluster is operating right now, you are treating your servers as cattle. Otherwise, you have pets in your data center.

Traditional systems administration is based on physical servers. To add a new machine to a data center, we need to purchase it upfront, wait until it arrives from the vendor, configure it in our office, move it to the data center location, and plug it in. The whole process can take a considerable amount of time. It is not uncommon for weeks, or even months to pass until we get a new fully provisioned server operating inside a data center.

Considering such a big waiting period and the costs, it is only natural that we do our best to keep servers as healthy as possible. If one of them starts behaving badly, we will do everything in our power to fix it as quickly as possible. What else can we do? Wait for weeks or months until a replacement arrives? Of course not. SSH into the faulty machine, find out what's wrong, and fix it. If a process died, bring it up again. If a hard disk broke, replace it. If a server is overloaded, add more memory.

It is only natural that, in such circumstances, we develop an emotional attachment to each of our servers. It starts with a name. Each new server gets one. There is Garfield, Mordor, Spiderman, and Sabrina. We might even decide on a theme. Maybe all our servers will get a name based on comic book superheroes. Or perhaps you prefer mythical creatures? How about ex-boyfriends and ex-girlfriends? Once we give a server a name, we start treating it as a pet. How do you feel? Do you need something? What's wrong? Should I take you to a veterinary? Each pet server is unique, hand raised, and cared for.

The change started with virtualization. The ability to create and destroy virtual machines allowed us to take a different approach to computing. Virtualization enabled us to stop treating our servers as pets. If virtualized servers are created and destroyed on a whim, it is pointless to give them names. There is no emotional attachment since their lifespan can be very short. Instead of *Garfield*, now we have *vm262.ecme.com*. Tomorrow, when we try to log into it, we might discover that it was replaced with *vm435.ecme.com*.

With virtualization, we started treating our servers as cattle. They do not have names, but numbers. We don't deal with them individually but as a herd. If a specimen is sick, we kill it. Curing it is slow and runs a risk of infecting the rest of the herd. If a server starts manifesting problems, terminate it immediately, and replace it with a new one.

The problem with this approach lies in habits we have accumulated over the years working with physical hardware. The switch from pets to cattle requires a mental change. It requires unlearning obsolete practices before switching to new ways of working.

Even though on-premise virtualization opened doors to quite a few new possibilities, many continued treating virtualized servers in the same way as they were treating physical nodes. Old habits die hard. Even though our servers became a herd, we keep treating each as pets. Part of the reason for the difficulty making a switch towards more elastic and dynamic computing lies in physical limitations of our data center. New VMs can be created only if there are available resources. Once we reach the limit, a VM has to be destroyed for a new one to be created. Our physical servers are still a valuable commodity. VMs gave us elasticity that is still bound by limitations imposed by the total of the computing power we possess.

We treat our valuable possessions with care since they are not cheap or easy to replace. We take good care of them since they should last for a long time. On the other hand, we have an entirely different approach to cheap things that are easy to replace. If a glass breaks, you probably don't try to glue the pieces together. You throw them to trash. There are plenty of other glasses in a cupboard, and all we have to do when their number becomes too small is buy a new set the next time we visit a shopping mall. Today we do not even need to go to a shopping mall but can order a new set online, and it will be delivered to our doorstep the same day. We should apply the same logic to servers.

Cloud computing made a big difference. Servers are no longer a valuable possession but a commodity. We can replace a node at any time without any additional cost. We can add a dozen servers to our cluster in a matter of minutes. We can remove them when we don't need them and reduce the cost.

Cloud computing is fundamentally different from "traditional" data centers. When utilized to its full potential, no server is indispensable or unique. The worst thing we can do is transition to the cloud without changing our processes and architecture. If we simply move our on-premise servers to the cloud without changing the processes we use to maintain them, the only thing we'll accomplish is higher cost.

With cloud computing, the notion of a server, its value, and the time required to get it, changed drastically. Such a significant change needs to be followed with a new set of processes and tools that execute them. Fault tolerance is the goal, speed is the key, and automation is a must.


<!-- .slide: data-background="../img/background/truth.jpg" -->
# Changed everything

---

### Cluster

### changes software architecture

### into immutable, stateless services

### that communicate through service discovery

## The need for new processes! <!-- .element: class="fragment" -->

Note:
The more services we have, the bigger the chance for a conflict to occur if we are using predefined ports. After all, there can be no two services listening on the same port. Managing an accurate list of all the ports used by, let's say, a hundred services is a challenge in itself. Add to that list the databases those services need and the number grows even more. For that reason, we should deploy services without specifying ports and letting Docker assign random ones for us. The only problem is that we need to discover the port number and let others know about it.

Things will get even more complicated later on when we start working on a distributed system with services deployed into one of the multiple servers. We can choose to define in advance which service goes to which server, but that would cause a lot of problems. We should try to utilize server resources as best we can, and that is hardly possible if we define in advance where to deploy each service. Another problem is that automatic scaling of services would be difficult at best, and not to mention automatic recuperation from, let's say, server failure. On the other hand, if we deploy services to the server that has, for example, least number of containers running, we need to add the IP to the list of data needed to be discovered and stored somewhere.

There are many other examples of cases when we need to store and retrieve (discover) some information related to the services we are working with.

To be able to locate our services, we need at least the following two processes to be available for us.

* **Service registration** process that will store, as a minimum, the host and the port service is running on.
* **Service discovery** process that will allow others to be able to discover the information we stored during the registration process.

Besides those processes, we need to consider several other aspects. Should we unregister the service if it stops working and deploy/register a new instance? What happens when there are multiple copies of the same service? How do we balance the load among them? What happens if a server goes down? Those and many other questions are tightly related to the registration and discovery processes and will be the subject of the next chapters. For now, we'll limit the scope only to the *service discovery* (the common name that envelops both processes mentioned above) and the tools we might use for such a task. Most of them feature highly available distributed key/value storage.


<!-- .slide: data-background="../img/background/agile.jpg" -->
# Changed everything

---

### Agile

### changed how we develop software

### but it failed to deliver it

## It excluded operations! <!-- .element: class="fragment" -->

Note:
When Agile appeared it changed the way we develop software. It thought us how to split tasks into short iterations (sprints). It thought us the value of communication and dangers of silos. Through XP it showed us the value of automated tests and test-driven development. Even if you are not working in an Agile environment, the chances are that you know what agile is. If you don't, either you are very young or you lived isolated from the rest of the world. Therefore, I won't spend any more of your time speaking about Agile.

What I will say is that agile failed with one of its main goals. It failed to unite people into self-sufficient teams. Sure, it joined different skills into a single team. We got product owner in charge of requirements (user stories). Developers learned how to apply test-driven development. Testers started working closely with developers. And so on and so forth. People with different skills stopped working in silos and learned how to work as a single team capable of delivering features at rapid, but sustainable pace. The problem is that delivering was missunderstood by many. People in charge of deploying software and monitoring it often remained isolated and continued working in silos. They continued working in isolation from the new Agile teams and, as a result, become a bottleneck.


<!-- .slide: data-background="../img/background/devops21.jpg" -->
# Changed everything

---

### DevOps is new agile

### It enables teams to be in full control

## The result? <!-- .element: class="fragment" -->


<!-- .slide: data-background="../img/background/continuous-deployment.png" -->
# Changed everything

---

### DevOps

### enables teams to be in full control

## It enables continuous deployment <!-- .element: class="fragment" -->


<!-- .slide: data-background="../img/background/truth.jpg" -->
# Changed everything

---

### You are NOT a coder,

### a tester, or an operator

## You need to know everything <!-- .element: class="fragment" -->

## and then specialize <!-- .element: class="fragment" -->
