<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/servers.jpg) center / cover" -->
<!-- .slide: class="center" -->
<div class="eyebrow">Section 12</div>

# Defining And Running Serverless Deployments


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(img/jenkins-x-wide.png) center / cover" -->
<!-- .slide: class="light" -->
<div class="eyebrow">Section 12</div>

# Defining And Running Serverless Deployments

> <b>Jenkins X itself is serverless.</b>

> That helps with many things, with better resource utilization and scalability being only a few of the benefits.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/why.jpg) center / cover" -->
<!-- .slide: class="light" -->
<div class="eyebrow">Section 12</div>

# Defining And Running Serverless Deployments

> Can we do something similar with our applications? Can we scale them to zero when no one is using them? Can we scale them up when the number of concurrent requests increases?

> <b>Can we make our applications serverless?</b>


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/why.jpg) center / cover" -->
<!-- .slide: class="light" -->
<div class="eyebrow">Section 12</div>

## What Is Serverless Computing?

A long time ago, most of us were deploying our apps directly to servers

* Then we got cloud computing<!-- .element: class="fragment" -->
* And now we have containers and schedulers<!-- .element: class="fragment" -->
* And we got serverless functions<!-- .element: class="fragment" -->


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/why.jpg) center / cover" -->
<!-- .slide: class="light" -->
<div class="eyebrow">Section 12</div>

## What Is Serverless Computing?

But...

* Serverless with cloud providers is a lock-in mechanism<!-- .element: class="fragment" -->
* Serverless on-prem requires too much maintenance<!-- .element: class="fragment" -->
* Serverless functions might be limiting<!-- .element: class="fragment" -->


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(img/kubernetes-wide.png) center / cover" -->
<!-- .slide: class="light" -->
<div class="eyebrow">Section 12</div>

## Why Not Use Kubernetes?

Serverless Deployments In Kubernetes

* Everyone is (or will be) using it<!-- .element: class="fragment" -->
* It is the de-facto standard<!-- .element: class="fragment" -->
* No vendor lock-in<!-- .element: class="fragment" -->


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(img/knative-wide.png) center / cover" -->
<!-- .slide: class="light" -->
<div class="eyebrow">Section 12</div>

## Knative

Which Types Of Applications Should Run As Serverless?

* If it can run in a container, it can be serverless<!-- .element: class="fragment" -->
* Faster is better<!-- .element: class="fragment" -->
* Stateless works great<!-- .element: class="fragment" -->
* Preview environments are a no brainer<!-- .element: class="fragment" -->


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(img/jenkins-x-wide.png) center / cover" -->
<!-- .slide: class="light" -->
<div class="eyebrow">Section 12</div>

## Why Do We Need Jenkins X To Be Serverless?

* Jenkins (without X) does not scale<!-- .element: class="fragment" -->
* Jenkins (without X) is not fault tolerant<!-- .element: class="fragment" -->
* Jenkins (without X) resource usage is heavy<!-- .element: class="fragment" -->
* Jenkins (without X) is slow<!-- .element: class="fragment" -->
* Jenkins (without X) is NOT API-driven<!-- .element: class="fragment" -->


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(img/jenkins-x-wide.png) center / cover" -->
<!-- .slide: class="light" -->
<div class="eyebrow">Section 12</div>

## Jenkins Had To Go Away For Jenkins X To Take Its Place

### Jenkins X Is Truly Serverless<!-- .element: class="fragment" -->


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(img/tekton-wide.png) center / cover" -->
<!-- .slide: class="light" -->
<div class="eyebrow">Section 12</div>

## What Is Tekton? How Does It Fit Jenkins X?


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/servers.jpg) center / cover" --><!-- .slide: class="light" -->
<div class="eyebrow">Section 12</div>

# What You'll Learn

> Installing Gloo and Knative

> New Serverless Application

> Existing Projects To Serverless

> Knative Support

> Adding The Final Touches

> Serverless With PRs
