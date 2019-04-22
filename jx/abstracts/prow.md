# Talk: Combining Serverless Continuous Delivery With ChatOps

## Abstract

Jenkins does not scale. There's no denying it. If we need more power because the number of concurrent builds increased, we cannot scale Jenkins. We cannot hook it into Kubernetes HorizontalPodAutoscaler that would increase or decrease the number of replicas based on metrics like the number of concurrent builds.

Simply put, Jenkins does not scale. At times, our Jenkins is struggling under heavy load. At others, it is wasting resources when it is underutilized. As a result, we might need to increase its requested memory and CPU as well as its limits to cover the worst-case scenario. As a result, when fewer builds are running in parallel, it is wasting resources, and when more builds are running, it is slow due to insufficient amount of assigned resources. And if it reaches its memory limit, it'll be shut down and rerun (potentially on a different node), thus causing delays or failed builds.

Except, that there is no Jenkins in Jenkins X. And the good news is that it is serverless. It combines Kubernetes with Prow, Tekton, and Pipeline Operator. And that's not all. It is based on GitOps principles, and it comes with ChatOps capabilities.

We'll explore how we can combine different tools and processes to accomplish Kubernetes-first Cloud-native continuous delivery based on GitOps principles combined with ChatOps. But, before we do that, you'll need to forget everything you know about Jenkins or similar tools.
