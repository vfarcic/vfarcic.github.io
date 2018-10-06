<!-- .slide: data-background="../img/background/why.jpg" -->
# Auto-Scaling Nodes

---


<!-- .slide: data-background="../img/background/scaling.jpeg" -->
> When Kubernetes cannot schedule new Pods because there's not enough available memory or CPU, new Pods will be unschedulable and in the *pending* status. If we do no increase the capacity of our cluster, *pending* Pods might stay in that state indefinitely.