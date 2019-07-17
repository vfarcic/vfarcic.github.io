<!-- .slide: data-background="../img/background/why.jpg" -->
# Deploying Releases With Zero-Downtime

---


<!-- .slide: data-background="img/hurdles.jpeg" -->
> If we are to survive in the face of competition, we have to release features to production as soon as they are developed and tested. The need for frequent releases fortifies the need for zero-downtime deployments.

Note:
We learned how to deploy our applications packaged as Pods, how to scale them through ReplicaSets, and how to enable communication through Services. However, all that is useless if we cannot update those applications with new releases. That is where Kubernetes Deployments come in handy.

The desired state of our applications is changing all the time. The most common reasons for new states are new releases. The process is relatively simple. We make a change and commit it to a code repository. We build it, and we test it. Once we're confident that it works as expected, we deploy it to a cluster. It does not matter whether that deployment is to a development, test, staging, or production environment. We need to deploy a new release to a cluster, even when that is a single-node Kubernetes running on a laptop. No matter how many environments we have, the process should always be the same or, at least, as similar as possible.

The deployment must produce no downtime. It does not matter whether it is performed on a testing or a production cluster. Interrupting consumers is disruptive, and that leads to loss of money and confidence in a product. Gone are the days when users did not care if an application sometimes did not work. There are so many competitors out there that a single bad experience might lead users to another solution. With today's scale, 0.1% of failed requests is considered disastrous. While we might never be able to reach 100% availability, we should certainly not cause downtime ourselves and must minimise other factors that could cause downtime.

Failures caused by circumstances outside of our control are things which, by definition, we can do nothing about. However, failures caused by obsolete practices or negligence are failures which should not happen. Kubernetes Deployments provide us with the tools we need to avoid such failures by allowing us to update our applications without downtime.