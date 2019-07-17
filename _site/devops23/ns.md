<!-- .slide: data-background="../img/background/why.jpg" -->
# Dividing A Cluster Into Namespaces

---


<!-- .slide: data-background="img/doors.jpeg" -->
> Applications and corresponding objects often need to be separated from each other to avoid conflicts and other undesired effects.

Note:
We might need to separate objects created by different teams. We can, for example, give each team a separate cluster so that they can "experiment" without affecting others. In other cases, we might want to create different clusters that will be used for various purposes. For example, we could have a production and a testing cluster. There are many other problems that we tend to solve by creating different clusters. Most of them are based on the fear that some objects will produce adverse effects on others. We might be afraid that a team will accidentally replace a production release of an application with an untested beta. Or, we might be concerned that performance tests will slow down the whole cluster. Fear is one of the main reasons why we tend to be defensive and conservative. In some cases, it is founded on past experiences. In others, it might be produced by insufficient knowledge of the tools we adopted. More often than not, it is a combination of the two.

The problem with having many Kubernetes clusters is that each has an operational and resource overhead. Managing one cluster is often far from trivial. Having a few is complicated. Having many can become a nightmare and require quite a significant investment in hours dedicated to operations and maintenance. If that overhead is not enough, we must also be aware that each cluster needs resources dedicated to Kubernetes. The more clusters we have, the more resources (CPU, memory, IO) are spent. While that can be said for big clusters as well, the fact remains that the resource overhead of having many smaller clusters is higher than having a single big one.

I am not trying to discourage you from having multiple Kubernetes clusters. In many cases, that is a welcome, if not a required, strategy. However, there is the possibility of using Kubernetes Namespaces instead. In this chapter, we'll explore ways to split a cluster into different segments as an alternative to having multiple clusters.