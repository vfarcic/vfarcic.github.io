# Talk: Cloud-Native Kubernetes-First Continuous Delivery With Jenkins X

## Abstract

Jenkins X, an open source project introduced to the community by CloudBees, enables the rapid creation, delivery and orchestration of cloud-native applications based on continuous delivery best practices and the proven Kubernetes platform.

By combining the power of Jenkins, its community and the power of Kubernetes, the Jenkins X project provides a path to the future of continuous delivery for microservices and cloud-native applications.

Jenkins X is Jenkins and additional best of breed tools and software for Kubernetes. It provides an interactive command-line interface to instantiate applications, repositories, environments, and pipelines and orchestrate continuous integration and continuous delivery.

It is the CI/CD solution for development of modern cloud applications on Kubernetes.

We'll explore how to create a fully operational continuous delivery pipeline using Docker, Kubernetes, Jenkins X, and quite a few other tools.

# Talk: Running Serverless Continuous Delivery

## Abstract

Running applications for continuous delivery is a massive waste of resources. We spend gigabytes of RAM for running Jenkins, Bamboo, Team City, or whichever tool we're using. And yet, those tools are often sitting idle inside our cluster, waiting to eventually receive a webhook notifying them that something should be done. As a result, resources are wasted when those tools are idle, and they are slow when under heavy load. If we add agents to the mix, we can quickly end up with hundreds of unused servers, and yet not have enough.

What if we could run our tools only when we need them? What if we could scale them to any number of replicas to accommodate the increase in the number of builds, and scale them down to zero when there are no new commits? What if we can do all that with a single command? The answer to those and quite a few other questions is to go serverless with continuous delivery tools. Jenkins X happens to do just that. It is a cloud-native Kubernetes-first solution that embraced a serverless model for managing our pipelines.

# Talk: The Recipe For Continuous Delivery

## Abstract

What does it take to implement continuous delivery today? What is the recipe?

For years, all we needed was Jenkins and a few agents. Is that still the case? Can we keep up with technology and do continuous delivery as we did it during the last few years?

I bet that if I list all the ingredients, it will turn out that you haven't even heard about many of them. Kubernetes? That's an easy one. How about Helm, Knative, skaffold, ChartMuseum, KSync, and kaniko? What do you get when you mix those and quite a few others and sprinkle them with some GitOps and ChatOps? Is the result something that everyone can use, even if they never heard about those tools?

# Talk: Ten Commandments Of GitOps Applied To Continuous Delivery

## Abstract

We (humans) tend to follow our own rules unless some higher power defines them for us. Well... He did tell us that there are ten commandments we must follow, so we'll explore them, we'll memorize them, and we'll make sure that we follow them without hesitation. Otherwise, everything will fall apart, and we will end up in the bad place.

We'll learn about the **ten commandments of GitOps applied To continuous delivery**. We'll see why **the processes employed in Continuous Delivery and DevOps are similar to how Buckingham Palace operates and are very different from Hogwarts School of Witchcraft and Wizardry**. We'll also argue that **slavery is a good thing, as long as it does not involve humans**, that **being aristocracy is better than to work at a nail salon**, and that **butler is the essential role without which our system would fall apart**. Believe it or not, all that will lead us to establish practices that will significantly improve the way we work.

# Workshop: Cloud-Native Kubernetes-First Continuous Delivery With Jenkins X, Kubernetes, And Friends

## Abstract

A lot changed since we were introduced to cloud, Kubernetes, and containers. Whatever we did in the past might not be valid anymore. Our applications need to become cloud-native, we need to adopt Kubernetes as the first class citizen, and there is no doubt anymore that continuous delivery is a must for any company that wants to stay competitive. The problem is that Kubernetes is complicated and the ecosystem is vast. Understanding low-level details takes more time than we might have, and yet we need to get everyone on board. We need a tool that will allow us to leverage all the latest and greatest processes and tools. At the same time, we need them to be simple and straightforward so that everyone can benefit from them. That is the primary objective behind the Jenkins X project. It brings power by combining best practices and tools while keeping it so simple that anyone can use it.

Jenkins X, an open source project introduced to the community by CloudBees, enables the rapid creation, delivery and orchestration of cloud-native applications based on continuous delivery best practices and the proven Kubernetes platform.

By combining the power of Jenkins, its community and the power of Kubernetes, the Jenkins X project provides a path to the future of continuous delivery for microservices and cloud-native applications.

Jenkins X is Jenkins and additional best of breed tools and software for Kubernetes. It provides an interactive command-line interface to instantiate applications, repositories, environments, and pipelines and orchestrate continuous integration and continuous delivery.

It is the CI/CD solution for development of modern cloud applications on Kubernetes.

We'll explore how to create a fully operational continuous delivery pipeline using containers, Kubernetes, Jenkins X, and quite a few other tools.

## Agenda

* What Do We Expect From Continuous Delivery?
* How Do We Accomplish Continuous Delivery?
* Intro To Jenkins X
* Creating A CD Cluster
* Creating A Quickstart Project
* Importing Existing Projects Into Jenkins X
* Creating Buildpacks
* Understranding GitOps Principles
* Improving Local Development
* Creating Pull Requests
* Promoting To Production

# Workshop: Running Serverless Continuous Delivery

## Abstract

Running applications for continuous delivery is a massive waste of resources. We spend gigabytes of RAM for running Jenkins, Bamboo, Team City, or whichever tool we're using. And yet, those tools are often sitting idle inside our cluster, waiting to eventually receive a webhook notifying them that something should be done. As a result, resources are wasted when those tools are idle, and they are slow when under heavy load. If we add agents to the mix, we can quickly end up with hundreds of unused servers, and yet not have enough.

What if we could run our tools only when we need them? What if we could scale them to any number of replicas to accommodate the increase in the number of builds, and scale them down to zero when there are no new commits? What if we can do all that with a single command? The answer to those and quite a few other questions is to go serverless with continuous delivery tools. Jenkins X happens to do just that. It is a cloud-native Kubernetes-first solution that embraced a serverless model for managing our pipelines.

This workshop will guide you through the process of defining serverless continuous delivery with Jenkins X and friends.