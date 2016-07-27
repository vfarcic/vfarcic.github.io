Service Discovery: The Key to Distributed Services
==================================================

> *It does not take much strength to do things, but it requires a great deal of strength to decide what to do*
>
> -- Elbert Hubbard

The more services we have, the bigger the chance for a conflict to occur if we are using predefined ports. After all, there can be no two services listening on the same port. Managing an accurate list of all the ports used by, let's say, a hundred services is a challenge in itself. Add to that list the databases those services need and the number grows even more. For that reason, we should deploy services without specifying ports and letting Docker assign random ones for us. The only problem is that we need to discover the port number and let others know about it.

Things will get even more complicated later on when we start working on a distributed system with services deployed into one of the multiple servers. We can choose to define in advance which service goes to which server, but that would cause a lot of problems. We should try to utilize server resources as best we can, and that is hardly possible if we define in advance where to deploy each service. Another problem is that automatic scaling of services would be difficult at best, and not to mention automatic recuperation from, let's say, server failure. On the other hand, if we deploy services to the server that has, for example, least number of containers running, we need to add the IP to the list of data needed to be discovered and stored somewhere.

There are many other examples of cases when we need to store and retrieve (discover) some information related to the services we are working with.

To be able to locate our services, we need at least the following two processes to be available for us.

* **Service registration** process that will store, as a minimum, the host and the port service is running on.
* **Service discovery** process that will allow others to be able to discover the information we stored during the registration process.

Besides those processes, we need to consider several other aspects. Should we unregister the service if it stops working and deploy/register a new instance? What happens when there are multiple copies of the same service? How do we balance the load among them? What happens if a server goes down? Those and many other questions are tightly related to the registration and discovery processes and will be the subject of the next chapters. For now, we'll limit the scope only to the *service discovery* (tthe common name that envelops both processes mentioned above) and the tools we might use for such a task. Most of them feature highly available distributed key/value storage.

Service Registry
----------------

The goal of the service registry is simple. Provide capabilities to store service information, be fast, persistent, fault-tolerant, and so on. In its essence, service registry is a database with a very limited scope. While other databases might need to deal with a vast amount of data, service registry expects a relatively small data load. Due to the nature of the task, it should expose some API so that those in need of it's data can access it easily.

There's not much more to be said (until we start evaluating different tools) so we'll move on to service registration.

Service Registration
--------------------

Microservices tend to be very dynamic. They are created and destroyed, deployed to one server and then moved to another. They are always changing and evolving. Whenever there is any change in service properties, information about those changes needs to be stored in some database (we'll call it *service registry* or simply *registry*). The logic behind service registration is simple even though the implementation of that logic might become complicated. Whenever a service is deployed, its data (IP and port as a minimum) should be stored in the service registry. Things are a bit more complicated when a service is destroyed or stopped. If that is a result of a purposeful action, service data should be removed from the registry. However, there are cases when service is stopped due to a failure and in such a situation we might choose to do additional actions meant to restore the correct functioning of that service. We'll speak about such a situation in more details when we reach the self-healing chapter.

There are quite a few ways service registration can be performed.

### Self-Registration

*Self-registration* is a common way to register service information. When a service is deployed it notifies the registry about its existence and sends its data. Since each service needs to be capable of sending its data to the registry, this can be considered an anti-pattern. By using this approach, we are breaking *single concern* and *bounded context* principles that we are trying to enforce inside our microservices. We'd need to add the registration code to each service and, therefore, increase the development complexity. More importantly, that would couple services to a specific registry service. Once their number increases, modifying all of them to, for example, change the registry would be a very cumbersome work. Besides, that was one of the reasons we moved away from monolithic applications; freedom to modify any service without affecting the whole system. The alternative would be to create a library that would do that for us and include it in each service. However, this approach would severally limit our ability to create entirely self-sufficient microservices. We'd increase their dependency on external resources (in this case the registration library).

De-registration is, even more, problematic and can quickly become quite complicated with the self-registration concept. When a service is stopped purposely, it should be relatively easy to remove its data from the registry. However, services are not always stopped on purpose. They might fail in unexpected ways and the process they're running in might stop. In such a case it might be difficult (if not impossible) to always be able to de-register the service from itself.

While self-registration might be common, it is not an optimum nor productive way to perform this type of operations. We should look at alternative approaches.

### Registration Service

Registration service or third party registration is a process that manages registration and de-registration of all services. The service is in charge of checking which microservices are running and should update the registry accordingly. A similar process is applied when services are stopped. The registration service should detect the absence of a microservice and remove its data from the registry. As an additional function, it can notify some other process of the absence of the microservice that would, in turn, perform some corrective actions like re-deployment of the absent microservice, email notifications, and so on. We'll call this registration and de-registration process *service registrator* or simply *registrator* (actually, as you'll soon see, there is a product with the same name).

A separate registration service is a much better option than self-registration. It tends to be more reliable and, at the same time, does not introduce unnecessary coupling inside our microservices code.

Since we established what will be the underlying logic behind the services registration process, it is time to discuss the discovery.

Service Discovery
-----------------

Service discovery is the opposite of service registration. When a client wants to access a service (the client might also be another service), it must know, as a minimum, where that service is. One approach we can take is self-discovery.

### Self-Discovery

Self-discovery uses the same principles as self-registration. Every client or a service that wants to access other services would need to consult the registry. Unlike self-registration that posed problems mostly related to our internal ways to connect services, self-discovery might be used by clients and services outside our control. One example would be a front-end running in user browsers. That front-end might need to send requests to many separate back-end services running on different ports or even different IPs. The fact that we do have the information stored in the registry does not mean that others can, should, or know how to use it. Self-discovery can be effectively used only for the communication between internal services. Even such a limited scope poses a lot of additional problems many of which are the same as those created by self-registration. Due to what we know by now, this option should be discarded.

### Proxy Service

Proxy services have been around for a while and proved their worth many times over. The next chapter will explore them in more depth so we'll go through them only briefly. The idea is that each service should be accessible through one or more fixed addresses. For example, the list of books from our *books-ms* service should be available only through the *[DOMAIN]/api/v1/books* address. Notice that there is no IP, port nor any other deployment-specific detail. Since there will be no service with that exact address, something will have to detect such a request and redirect it to the IP and port of the actual service. Proxy services tend to be the best type of tools that can fulfill this task.

Now that we have a general, and hopefully clear, idea of what we're trying to accomplish, let's take a look at some of the tools that can help us out.

Service Discovery Tools
-----------------------

The primary objective of *service discovery tools* is to help services find and talk to one another. To perform their duty, they need to know where each service is. The concept is not new, and many tools existed long before Docker was born. However, containers brought the need for such tools to a whole new level.

The basic idea behind *service discovery* is for each new instance of a service (or application) to be able to identify its current environment and store that information. Storage itself is performed in a registry usually in key/value format. Since the discovery is often used in distributed system, registry needs to be scalable, fault-tolerant and distributed among all nodes in the cluster. The primary usage of such a storage is to provide, as a minimum, IP and port of a service to all interested parties that might need to communicate with it. This data is often extended with other types of information.

Discovery tools tend to provide some API that can be used by a service to register itself as well as by others to find the information about that service.

Let's say that we have two services. One is a provider, and the other one is its consumer. Once we deploy the provider, we need to store its information in the *service registry* of choice. Later on, when the consumer tries to access the provider, it would first query the registry and call the provider using the IP and port obtained from the registry. To decouple the consumer from a particular implementation of the registry, we often employ some *proxy service*. That way the consumer would always request information from the fixed address that would reside inside the proxy that, in turn, would use the discovery service to find out the provider information and redirect the request. Actually, in many cases, there is no need for the proxy to query the service registry if there is a process that updates its configuration every time data in the registry changes. We'll go through *reverse proxy* later on in the book. For now, it is important to understand that the flow that is based on three actors; consumer, proxy, and provider.

What we are looking for in the service discovery tools is data. As a minimum, we should be able to find out where the service is, whether it is healthy and available, and what is its configuration. Since we are building a distributed system with multiple servers, the tool needs to be robust, and failure of one node should not jeopardize data. Also, each of the nodes should have the same data replica. Further on, we want to be able to start services in any order, be able to destroy them, or to replace them with newer versions. We should also be able to reconfigure our services and see the data change accordingly.

Let's take a look at a few of the tools we can use to accomplish the goals we set.

The DevOps 2.0 Toolkit
======================

This article is an excerpt from one of the chapters of [The DevOps 2.0 Toolkit: Automating the Continuous Deployment Pipeline with Containerized Microservices](http://www.amazon.com/dp/B01BJ4V66M) book.

The book is about different techniques that help us architect software in a better and more efficient way with *microservices* packed as *immutable containers*, *tested* and *deployed continuously* to servers that are *automatically provisioned* with *configuration management* tools. It's about fast, reliable and continuous deployments with *zero-downtime* and ability to *roll-back*. It's about *scaling* to any number of servers, the design of *self-healing systems* capable of recuperation from both hardware and software failures and about *centralized logging and monitoring* of the cluster.

In other words, this book envelops the full *microservices development and deployment lifecycle* using some of the latest and greatest practices and tools. We'll use *Docker, Ansible, Ubuntu, Docker Swarm and Docker Compose, Consul, etcd, Registrator, confd, Jenkins, nginx*, and so on. We'll go through many practices and, even more, tools.

The book is available from Amazon ([Amazon.com](http://www.amazon.com/dp/B01BJ4V66M) and other worldwide sites) and [LeanPub](https://leanpub.com/the-devops-2-toolkit).