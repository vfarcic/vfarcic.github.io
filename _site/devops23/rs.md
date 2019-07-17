<!-- .slide: data-background="../img/background/why.jpg" -->
# Scaling Pods With ReplicaSets

---


<!-- .slide: data-background="img/paragliding.jpg" -->
> Most applications should be scalable and all must be fault tolerant. Pods do not provide those features, ReplicaSets do.

Note:
We learned that Pods are the smallest unit in Kubernetes. We also learned that Pods are not fault tolerant. If a Pod is destroyed, Kubernetes will do nothing to remedy the problem. That is, if Pods are created without Controllers.

The first Controller we'll explore is called *ReplicaSet*. Its primary, and pretty much only function, is to ensure that a specified number of replicas of a Pod matches the actual state (almost) all the time. That means that ReplicaSets make Pods scalable.

We can think of ReplicaSets as a self-healing mechanism. As long as elementary conditions are met (e.g., enough memory and CPU), Pods associated with a ReplicaSet are guaranteed to run. They provide fault-tolerance and high availability.

It is worth mentioning ReplicaSet is the next-generation ReplicationController. The only significant difference is that ReplicaSet has extended support for selectors. Everything else is the same. ReplicationController is considered deprecated, so we'll focus only on ReplicaSet.