# Internal Developer Platform Day 2 Operations Solved with Kubernetes and Crossplane

## Description

In most, cases, if we work very very very hard, we could enable developers to create something meaningful. Most of us do that by creating abstractions. Instead of forcing developers to spend years trying to understand the intricacies of Kubernetes, we create Helm charts that enable developers to modify a simple YAML values file and apply charts to the cluster. If we are advanced, we create CRDs and controllers that result in even better abstractions and start resembling services that developers can consume. We progress further from there by creating services not only for applications but also for databases, clusters, or anything else. We, platform engineers, become service providers and developers start consuming those services.

Here's the problem though. All that tends to help only with day zero operations. Developers can create or update something in a very easy way but when it comes to operating and observing that something, they often end up being equally confused as they were before. Our services **do not show the information** they need so they need to dig deeper into lower-level resources to find out what's going on. That negates some of the main reasons we started offering them services. That's horrible. We're building something that looks useful when someone starts using it and it turns **useless** afterwards.

In this talk we tackle a major challenge in Internal Developer Platforms built on top of Kubernetes: enabling developers to not only manage their applications and infrastructure but also to observe and troubleshoot them effectively. We demonstrate how to propagate meaningful status information to top-level resources using Crossplane and the Status Transformer Function. We will solve real-world issues by making day 2 operations easier for developers without overwhelming them with low-level details. We'll learn how to create custom resource definitions (CRDs) and controllers that simplify the developer experience and propagate relevant information up the hierarchy tree.

This is a live coding session.
