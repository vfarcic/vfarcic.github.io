# GitOps


# Desired State In Git


## A process that converges the actual state into the desired state?


# GitOps Principles

* Declarative
* Versioned and immutable
* Pulled automatically
* Continuously reconciled


# Kubernetes Operators


# Kubernetes

* Extensible API
* Drift-detection and reconciliation


# Only applications?


# Kubernetes resources are NOT the actual state


# The actual state

* Containers
* External LBs
* Storage
* ...


## Kubernetes is sometimes the actual state...


## ... and at other times the intermediary between the desired and the actual state


## The actual state is also...

* Databases
* Non-Kubernetes apps
* Servers
* Clusters
* Third-party apps
* Services
* Kubernetes itself
* ...


# Why only apps?


# Kubernetes
## can be extended through 
## Custom Resource Definitions (CRD)


## We need Custome Resource Definitions and operators that represent "real" resources


![](../img/products/crossplane.png)


![](../img/products/upbound.png)
