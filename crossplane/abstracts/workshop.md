# Crossplane: Using Kubernetes API To Manage Everything

If we had to define the most significant benefit Kubernetes provides, that would not be the ability to run containers, fault-tolerance, or immutability. The main benefit is its API. It is well defined, versatile, and extensible. It might be the main culprit behind the "explosion" of the ecosystem created around Kubernetes.

Can we take Kubernetes API to the next level? Can we use it to manage not only the workloads running inside Kubernetes clusters but for everything else? Wouldn't it be beneficial if we had a **single API** and a **universal control plane** responsible for managing applications, infrastructure, services, and everything else?

In this hands-on workshop, we'll explore the principles behind the **universal control plane** implemented through the open-source project **Crossplane** combined with quite a few tools from the Kubernetes ecosystem like, for example, **GitOps** with **Argo CD**, policy management with **Kyverno**, and quite a few others.
