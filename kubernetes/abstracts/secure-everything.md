# How To Secure Everything Without Making Everyone Suffer?

What makes a system secure? How do we secure everything, no matter whether it's running inside Kubernetes clusters, Cloud providers like AWS, Azure, or Google Cloud (GCP), or anything else?

To answer those questions, we'll have to answer the following:
1. Is the access to your system secure? Is it done in a way that prevents unauthorized access to humans and processes. If that's the case, what can those who do have access do.
2. Once you do have access to manage specific types of resources, what is required to ensure that you will follow good practices so that resources are created and managed following specific rules?
3. How do you know what you are running, what are all the components included?
4. Are you sure that what you're running has not been tempered by anyone or anything else?
5. How do you know that there are no known vulnerabilities in what you're running?
6. How do you store and retrieve confidential information?

Now, you probably heard those questions before, but the answers might be different than what you think.

In this talk, we'll design a system from scratch in a way that it is secured without sacrificing productivity of the people using it.

## Benefit the ecosystem?

This presentation covers a set of tools inside the CNCF ecosystem, including, but not limited to, KubeVirt, Cluster API, Crossplane, KubeVela, OPA Gatekeeper, Kyverno, Argo CD, Flux, Helm, and quite a few others.

The goal is to show how to use open source tools to design a secure system that is easy to use and maintain.
