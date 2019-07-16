<!-- .slide: data-background="../img/background/servers.jpg" -->
# Defining And Running Serverless Deployments

---


<!-- .slide: data-background="../img/products/jenkins-x.png" -->
> Jenkins X itself is serverless. That helps with many things, with better resource utilization and scalability being only a few of the benefits.


<!-- .slide: data-background="../img/background/why.jpg" -->
> Can we do something similar with our applications? Can we scale them to zero when no one is using them? Can we scale them up when the number of concurrent requests increases? Can we make our applications serverless?


<!-- .slide: data-background="../img/background/why.jpg" -->
## What is Serverless Computing?

---


<!-- .slide: data-background="../img/background/why.jpg" -->
### A long time ago,
### most of us were
### deploying our apps
### directly to servers.

---


<!-- .slide: data-background="../img/background/cloud.jpg" -->
### Then we got cloud computing

---


<!-- .slide: data-background="../img/products/kubernetes.png" -->
### And Now We Have Containers And Schedulers

---


<!-- .slide: data-background="../img/background/why.jpg" -->
### And We Got Serverless Functions

---


<!-- .slide: data-background="../img/background/why.jpg" -->
### But...

---

* Serverless with cloud providers is a lock-in mechanism<!-- .element: class="fragment" -->
* Serverless on-prem requires too much maintenance<!-- .element: class="fragment" -->
* Serverless functions might be limiting<!-- .element: class="fragment" -->


<!-- .slide: data-background="../img/products/kubernetes.png" -->
### Why Not Use Kubernetes?

---


<!-- .slide: data-background="../img/products/kubernetes.png" -->
## Serverless Deployments In Kubernetes

---

* Everyone is (or will be) using it<!-- .element: class="fragment" -->
* It is the de-facto standard<!-- .element: class="fragment" -->
* No vendor lock-in<!-- .element: class="fragment" -->


<!-- .slide: data-background="../img/products/knative.png" -->
### Knative

---


<!-- .slide: data-background="../img/products/knative.png" -->
## Which Types Of Applications Should Run As Serverless?

---

* If it can run in a container, it can be serverless<!-- .element: class="fragment" -->
* Faster is better<!-- .element: class="fragment" -->
* Stateless works great<!-- .element: class="fragment" -->
* Preview environments are a no brainer<!-- .element: class="fragment" -->


<!-- .slide: data-background="../img/products/jenkins-x.png" -->
## Why Do We Need Jenkins X To Be Serverless?

---

* Jenkins (without X) does not scale<!-- .element: class="fragment" -->
* Jenkins (without X) is not fault tollerant<!-- .element: class="fragment" -->
* Jenkins (without X) resource usage is heavy<!-- .element: class="fragment" -->
* Jenkins (without X) is slow<!-- .element: class="fragment" -->
* Jenkins (without X) is NOT API-driven<!-- .element: class="fragment" -->


<!-- .slide: data-background="../img/products/jenkins.png" -->
### Jenkins had to go away for Jenkins X to take its place.

---


<!-- .slide: data-background="../img/products/jenkins-x.png" -->
### Jenkins X Is Truly Serverless

---


<!-- .slide: data-background="../img/products/tekton.png" -->
## What Is Tekton And How Does It Fit Jenkins X?

---
