# How To Apply GitOps Without Making Developers Go Crazy

GitOps provides a lot of advantages. We have a single source of truth of the desired state, automated sync, drift detection and reconciliation, and so on. However, our manifests are still too complex for everyone to understand. They tend to describe Kubernetes resources instead of applications. On the other hand, the tools that do treat applications as applications instead of resources, tend to be focused mostly on CLI and UI, often ignoring the need to define everything as code.

Can we combine both? Can we have application specs that are easy for developers to understand, write, and manage? Can we combine that with GitOps so that we can focus on pushing changes to Git instead of operating clusters? Can we make everything so easy that anyone can use it no matter whether they are "Kubernetes ninjas" or application developers that just want their apps to run?

In this session, we'll combine Argo CD with Crossplane, and a few other tools in the search for a way to implement GitOps without making developers go crazy. 
