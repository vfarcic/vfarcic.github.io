# Forget About Apps. It's All About Resource Abstractions.

In the past, an application was a binary or a package. It was a thing that you could install and run.

Today, it's much harder to define what an application is. Is it only a container? Do we combine it with a Service and an Ingress so that it can be reached by other processes and by users? Does it contain external storage and an external load balancer? If it does, then it's not just a container anymore. It's a collection of resources. Does it need a database? If it does, is that database yet another application or is it a service?

Today, applications are a collection of resources. Only when we combine them all together do we get a meaningful application. And that's why we need to stop thinking about applications and start thinking about resources. Moreover, resources are too complex to be managed individually. We need to abstract them into resource abstractions tailored to specific use cases.

Let's see how we can do that with Crossplane and friends.

## Benefits to the Ecosystem

When working with cloud-native technologies, it is easy to get deep into one part of the system and lose sight of the bigger picture. On the other hand, the big picture can be difficult to make out because there are such a huge number of considerations, use cases, and CNCF projects.  

This talk will discuss one path towards understanding how Kubernetes resources works and how to benefit from abstractions.
