<!-- .slide: data-background="../img/background/why.jpg" -->
# Creating Pods

---


<!-- .slide: data-background="img/bricks.jpg" -->
> Pods are equivalent to bricks we use to build houses. Both are uneventful and not much by themselves. Yet, they are fundamental building blocks without which we could not construct the solution we are set to build.

Note:
If you used Docker or Docker Swarm, you're probably used to thinking that a container is the smallest unit and that more complex patterns are built on top of it. With Kubernetes, the smallest unit is a Pod. A Pod is a way to represent a running process in a cluster. From Kubernetes' perspective, there's nothing smaller than a Pod. A Pod encapsulates one or more containers. It provides a unique network IP, it attaches storage resources, and it decides how containers should run. Everything in a Pod is tightly coupled. We should clarify that containers in a Pod are not necessarily made by Docker. Other container runtimes are supported as well. Still, at the time of this writing, Docker is the most commonly used container runtime, and all our examples will use it.