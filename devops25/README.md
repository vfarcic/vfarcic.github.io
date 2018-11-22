# Talk: The DevOps 2.5 Toolkit: Monitoring, Logging, and Auto-Scaling Kubernetes: Making Resilient, Self-Adaptive, And Autonomous Kubernetes Clusters

## Abstract (short)

What do you do after you learn Kubernetes, after you deploy your applications to a production cluster, and after you fully automate continuous deployment pipeline? You work on making your cluster self-sufficient by adding monitoring, alerting, logging, and auto-scaling.

Kubernetes already has the tools that provide metrics and visibility into logs. It allows us to create auto-scaling rules. Yet, we might discover that Kuberentes alone is not enough and that we might need to extend our system with additional processes and tools. We'll discuss how to make **your clusters and applications truly dynamic and resilient and that they require minimal manual involvement. We'll try to make our system self-adaptive.**

## Abstract

What do you do after you learn Kubernetes, after you deploy your applications to a production cluster, and after you fully automate continuous deployment pipeline? You work on making your cluster self-sufficient by adding monitoring, alerting, logging, and auto-scaling.

The fact that we can run (almost) anything in Kubernetes and that it will do its best to make it fault tolerant and highly available, does not mean that our applications and clusters are bulletproof. We need to monitor the cluster, and we need alerts that will notify us of potential issues. When we do discover that there is a problem, we need to be able to query metrics and logs of the whole system. We can fix an issue only once we know what the root cause is. In highly dynamic distributed systems like Kubernetes, that is not as easy as it looks.

Further on, we need to learn how to scale (and de-scale) everything. The number of Pods of an application should change over time to accommodate fluctuations in traffic and demand. Nodes should scale as well to fulfill the needs of our applications.

Kubernetes already has the tools that provide metrics and visibility into logs. It allows us to create auto-scaling rules. Yet, we might discover that Kuberentes alone is not enough and that we might need to extend our system with additional processes and tools. We'll discuss how to make **your clusters and applications truly dynamic and resilient and that they require minimal manual involvement. We'll try to make our system self-adaptive.**

## Benefits

Learn how to make your clusters more resilient through self-adaptation based on metrics.