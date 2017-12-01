# The DevOps 2.2 Toolkit: Jenkins

## Abstract: Workshop

This workshop is based on the material published in [The DevOps 2.1 Toolkit: Building, testing, deploying, and monitoring services inside Docker Swarm clusters](https://leanpub.com/the-devops-2-1-toolkit).

The combination of Docker and Jenkins improves your continuous deployment pipeline using fewer resources. It also helps you scale up your builds, automate tasks, provide high availability, and speed up Jenkins performance with the benefits of Docker containerization.

The goal of the workshop is to design a fully automated continuous deployment (CDP) pipeline. We’ll see how microservices fit into CDP and immutable containers concepts and why the best results are obtained when those three are combined into one unique framework. We’ll explore tools like Docker, Docker Swarm, Docker Compose, Jenkins, HAProxy, and a few others. The end result will be a fully operational continuous deployment pipeline that will deploy a new release to production with every commit.

This workshop will walk you through setting up a Docker cluster and deploying Jenkins master and agent services. This course will then provide steps to run unit tests and build applications as Docker images. Once we understand the process through Docker commands we'll automate it through Jenkins pipeline. Further on, we'll explore how we can extend the pipeline with functional and other types of automated tests that will give us confidence that the application under test passed all the quality requirements. Moving on you will learn how to deploy new releases to production without downtime and run post-production deployment tests. We'll extend Jenkins pipeline to include all the steps thus creating a fully functional continuous deployment process.

Moving on, we'll explore how to optimize the continuous deployment pipeline. You'll learn how to use shared libraries for the common code used across different pipelines and how to store those pipelines in a version control repository (e.g., GitHub) and allow teams in charge of applications to take control of their continuous deployment processes while still leveraging commonly used snippets.


