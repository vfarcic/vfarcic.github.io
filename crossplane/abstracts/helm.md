# How To Manage Infrastructure With Helm

Helm is a powerful package manager. Most of us are using it. Yet, it is limited to applications running in Kubernetes.

Would it make sense to start managing **everything** as Kubernetes manifests and package them into Helm charts? Why not use Helm to also package and manage infrastructure and services?

If we could define everything as (custom) Kubernetes resources, we could convert Helm from being an application manager into a tool used to package and manage everything. That's where Crossplane comes into play. As a universal control plane based on Kubernetes, it enables us to define and manage everything as Kubernetes resources (e.g., AWS, Azure, Google Cloud, on-prem, services, etc.).

In this session, we'll explore combining Helm and Crossplane as a way to package and manage not only applications but also infrastructure and services.