# Kubernetes


## Kubernetes

# A container orchestrator?


## Kubernetes

# Cluster OS?


## Kubernetes

# A control plane?


## Kubernetes

# Something else?


## Kubernetes

# Architecture


<!-- .slide: data-background="img/what/control-plane.png" data-background-size="cover" -->


<!-- .slide: data-background="img/what/worker-node.png" data-background-size="cover" -->


<!-- .slide: data-background="img/what/external-resource.png" data-background-size="cover" -->


<!-- .slide: data-background="img/what/control-planes.png" data-background-size="cover" -->
Note: Decisions about the cluster (and beyond)<!-- .element: class="fragment" -->


<!-- .slide: data-background="img/what/worker-nodes.png" data-background-size="cover" -->
Note: That's where in-cluster workloads are running


<!-- .slide: data-background="img/what/external-resources.png" data-background-size="cover" -->
Note: Whatever is not inside the cluster


<!-- .slide: data-background="img/what/external-resource-storage.png" data-background-size="cover" -->


<!-- .slide: data-background="img/what/external-resource-elb.png" data-background-size="cover" -->


<!-- .slide: data-background="img/what/api.png" data-background-size="cover" -->
Note: Kubernetes front-end, Query and manipulate the state of resources, REST interface


<!-- .slide: data-background="img/what/scheduler.png" data-background-size="cover" -->
Note: Items: Watches resource capacity, Assigns workloads to nodes


<!-- .slide: data-background="img/what/controller-manager.png" data-background-size="cover" -->
Note: Makes sure that the shared state is operating as expected, Oversees various controllers


<!-- .slide: data-background="img/what/key-value.png" data-background-size="cover" -->
Note: Distributed, Contains the state of the cluster, Typically etcd


<!-- .slide: data-background="img/what/kubelet.png" data-background-size="cover" -->
Note: Tracks the state of Pods, Ensures that all the containers in Pods are running


<!-- .slide: data-background="img/what/kube-proxy.png" data-background-size="cover" -->
Note: Maintains network rules


TODO: Continue

* Header: Container runtime; Items: Responsible for running containers
* Header: Container; Items: Software package
* Header: Pod; Items: A group of containers
* Header: Controller; Items: Manages resources, Control loop, Containers inside Pods
* diag-kubernetes (end)
* Section: Manage Applications In Kubernetes
* diag-deployment (Cluster, Deployment, ReplicaSet, Pod, Container)
* Section: Manage Application Infrastructure
* diag-ingress-storage (Cluster, Pod, Service, Ingress, External LB, Persistent Volume)
* Section: Manage VMs
* diag-vm (Cluster, VM, Deployment, ReplicaSet, Ingress, External LB)
* Section: Manage External Resources
* diag-external-resources (Cluster, VM, API, DB, k8s)
* Section: What Is Kubernetes?
* Text: A container orchestrator in charge of operating a fleet of containerized applications?
* Text: Depends on controllers.
* Text: A Kubernetes cluster might manage only containers.
* Text: Kubernetes might manage container and infrastructure
* Text: Kubernetes might manage only infrastructure
* Text: Kubernetes might be used to run virtual machines
* Text: Kubernetes might manage something completely different
* Text: It's not about containers
* Text: Kubernetes is about controllers, and API, and control loops
* Text: Kubernetes is a control plane for whichever resources we might need to manage
* Member shoutouts: Thanks a ton to the new members for supporting the channel: Daniel Ruiz, José Augusto Guzmán Valdéz, Leia Renée
* Outro roll
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


## We need CRDs and operators that represent "real" resources


![](../img/products/crossplane.png)


![](../img/products/upbound.png)
