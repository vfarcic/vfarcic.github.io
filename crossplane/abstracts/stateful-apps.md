# Shifting Left Stateful Applications In Kubernetes

Stateless apps are easy to manage. More often than not, a Kubernetes Deployment, with a Service, Ingress, and Horizontal Pod Autoscaler (HPA) is enough. Almost everyone can do it. But, when it comes to stateful applications, things become a bit more complicated. We might need a database and storage. We might need to manage database users and schema. We might need to consider quite a few other things. Stateful apps are harder for everyone, especially if we want to shift left and enable developers to do it themselves.

In this talk, we'll try to make the management of stateful applications easy for everyone. We'll accomplish that by creating easy-to-consume services that are made specifically for the needs of our organizations. We'll see how to create new Kubernetes Custom Resource Definitions (CRDs) and controllers using Crossplane. Those controllers will envelop all the tools, resources, and processes we might need. As a result, ops can focus on creating such services while everyone else can consume them (create and manage everything related to stateful apps) without opening JIRA tickets and waiting for others to complete their tasks.

## Pitch

How can we make management of stateful applications easy for everyone?

## Benefits to the Ecosystem

When working with cloud-native technologies, it is easy to get deep into one part of the system and lose sight of the bigger picture. On the other hand, the big picture can be difficult to make out because there are such a huge number of considerations, use cases, and CNCF projects.  

This talk will discuss one path towards enabling developers to self-serve themselves using CNCF projects.
