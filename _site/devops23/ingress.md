<!-- .slide: data-background="../img/background/why.jpg" -->
# Using Ingress To Forward Traffic

---


<!-- .slide: data-background="img/door.jpeg" -->
> Applications that are not accessible to users are useless. Kubernetes Services provide accessibility with a usability cost. Each application can be reached through a different port. We cannot expect users to know the port of each service in our cluster.

Note:
Ingress objects manage external access to the applications running inside a Kubernetes cluster. While, at first glance, it might seem that we already accomplished that through Kubernetes Services, they do not make the applications truly accessible. We still need forwarding rules based on paths and domains, SSL termination and a number of other features. In a more traditional setup, we'd probably use an external proxy and a load balancer. Ingress provides an API that allows us to accomplish these things, in addition to a few other features we expect from a dynamic cluster.