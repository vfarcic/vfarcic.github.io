# Kubernetes Chaos Engineering

The only thing more satisfying than being able to destroy things without consequences is to be awarded for destruction. If you do have destructive tendencies, but you'd like to convert them into something positive, chaos engineering might be just the thing you need.

Kubernetes facilitates and simplifies many operations that were very hard, if not impossible, in the past. It makes our applications resilient, fault-tolerant, and highly-available. Nevertheless, Kubernetes and the ecosystem around it do not guarantee those features but are making them available to us. Everything still depends on what we use, how we use it, and, above all, the architecture of our applications. We should always put all that to the test by employing chaos engineering principles.

We'll explore through a hands-on demo on how to use Chaos Toolkit to define and run chaos experiments inside a Kubernetes cluster with Istio. We'll see a few use-cases of potential problems that can be detected and solved. We'll automate the deployment of chaos experiments using Jenkins X and make them an integral part of our continuous delivery pipelines.
