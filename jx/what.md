<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.9), rgba(87,185,72,0.9)), url(../img/background/why.jpg) center / cover" -->
<!-- .slide: class="center" -->
# What?

## CI vs CD vs CDP?

### Continuous integration?<!-- .element: class="fragment" -->
### Continuous delivery?<!-- .element: class="fragment" -->
### Continuous deployment?<!-- .element: class="fragment" -->

Note:
Let's start with basics. What is the difference between continuous integration, continuous delivery, and continuous deployment?

We are doing continuous integration if we run automated processes every time we push a change to, at least, the master branch, and only if we are merging to the master often. The goal is to have a high level of confidence that our work integrates with the work of others. If we wait too long before merging, than it is not continuous. In that case, we could call it delayed integration or, simply, automation.

We know that continuous integration involves frequent integration of the code and automation. We know when each iteration starts; whenever we push something to the code repository. However, we do not know when it ends. As long as we run a few tests, we can call the process continuous integration. Some do more. Nevertheless, the important thing to note is that manual actions follow the automation. We still might need to deploy manually. Or, maybe, we need to run performance tests manually. If doesn't matter what those manual actions are, the point is that continuous integration encompases only a fraction of the repetitive tasks we need to perform after making change to the code. That's where continuous delivery comes in.

We are doing continuous delivery when all the steps in the lifecycle of an application are automated, except deployment to production. Every time we push a change to the code, we build, we test, we make a release, we deploy to some environments, and so on and so forth. But, we are still reserving the right for humans to decide when is the time to promote a release to production. We have a big button that says "promote this release".

The decision to promote a release to production is related to business. It is not technical. If a pipeline triggered through a change in code is green, if none of the steps failed, a release is ready for production. We are delaying the decision to promote it purely on business reasons. Maybe we want to start a marketing campaign first. Or maybe we want to wait for a certain day in the month due to user's expectations. No matter the reason, the decision is not technical because we trust our automation to uncover problems. If that's not the case, we are doing continuous integration, not delivery.

Finally, continuous deployment is almost the same as continuous delivery. The only difference is that there is no button to promote a release to production. Every change to the master branch gets automatically deployed to production, as long as all automated validations passed. That usually means that we are using feature toggles, that we have automated rollbacks, that we might be using canary deployments, and so on and so forth. Practicing continuous deployment usually means that we are so confident in our work and in automation that we do not need a business person to press a button to promote a release to production. It's full automation of everything except writing, pushing, and reviewing code. And, in this context, code is everything written by humans in a format that is readable by machines.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.9), rgba(87,185,72,0.9)), url(../img/background/why.jpg) center / cover" -->
<!-- .slide: class="center" -->
# What?

## What Do We Expect From Continuous Delivery?


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.9), rgba(87,185,72,0.9)), url(../img/background/why.jpg) center / cover" -->
<!-- .slide: class="light" -->
## What?

* It needs to be cloud-native <!-- .element: class="fragment" -->
* It needs to be cloud-agnostic <!-- .element: class="fragment" -->
* It needs to scale from zero to infinity and back <!-- .element: class="fragment" -->
* It needs to follow the everything-as-code principle <!-- .element: class="fragment" -->
* It needs to be fast <!-- .element: class="fragment" -->
* It needs to be (very) easy <!-- .element: class="fragment" -->

Note:
Now that we established what continuous integration, delivery, and deployment are, let's see how they should look like. What are the properties we expect of the tools and the processes we would employ today?

Whichever tool we pick, it needs to be cloud-native. I will not go into details of what cloud-native means. You know all that. The only note I'll add is that being cloud-native does not mean that it is running in AWS, but, rather, that it has certain properties that caracterize today's applications and their ability to be elastic, to be fault tollerant, to be automatable, and so on and so forth.

But that's not enough. It also needs to be cloud-agnostic. It is becoming more and more evident that a dependency on a single provider is not a good idea. You might want to be able switch to a different one instead of being locked in. You might want to spread your workload across multiple cloud providers. Or, you might want to combine on-prem and public cloud. No matter what you need today or what you might need tomorrow, it is clear that you don't want to be locked into a single provider, so the solution needs to be cloud-agnostic.

Costs are an important part of decision making. You don't want to spend more money than needed, especially when there is no good reason for extra costs. The worst thing you can do is pay someone for something you don't need, and the thing you probably need the least are idle resources. Every minute spent with unused machines is a waste, for no apparent reason. If we are using public cloud providers, we are paying for resources, no matter whether we are using them or they are idle. If we are running on-prem, we need excess capacity if we are not capable of shutting down unused nodes and thus freeding resources for those who need them. For us to shut down nodes with idle processes, we need to shut down those processes first. That leads us to yet another requirement. Our solution needs to be capable of scaling from zero to infinity, and back. If noone is using it, it should not run. If few are using it, it should run with low resource usage. And, if many need it at one moment, it should scale up to accomodate that.

Another obvious requirement is that it needs to follow the everything-as-code principle. Everything related to the solution should be defined in machine readable format that can be stored and tracked in Git. That's an easy one and there's probably no need to tell you why source control should be the only source of truth of everything.

Further on, it needs to be fast. No one wants to waste time waiting for something to happen. Everything should be almost instant, no matter whether that's building, testing, deployment, or anything else. If you have to stare at your screen, let it be Netflix, and not a run of a pipeline.

Finally, it needs to be extremely easy. What we do today is complex and we cannot expect everyone to spend eternity learning everything. The main differentiator between good and bad solutions is in their ease of use, not in features listed in some Excel sheet vendors give you in an attempt for you to sign a fat check.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.9), rgba(87,185,72,0.9)), url(../img/background/how.jpg) center / cover" -->
<!-- .slide: class="center" -->
# How?

## How Do We Accomplish That?


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.9), rgba(87,185,72,0.9)), url(../img/background/how.jpg) center / cover" -->
<!-- .slide: class="light" -->
## How?

* Adopt Kubernetes as the major cross-platform cloud-agnostic container scheduler <!-- .element: class="fragment" -->
* Adopt tekton as serverless solution for pipelines in Kubernetes <!-- .element: class="fragment" -->
* Adopt GitOps as a founding principle of the solution <!-- .element: class="fragment" -->
* Create a ChatOps gateway in between <!-- .element: class="fragment" -->
* Adopt Helm as the standard Kubernetes packaging solution <!-- .element: class="fragment" -->
* Facilitate quickstarts <!-- .element: class="fragment" -->

Note:
How can we accomplish those requirements?

There is only one reasonable and acceptable solution for being cloud-agnostic. That is, as you already know, Kubernetes. It is the most widely used solution backed by almost every vendor. It provides a single API that allows us to do whatever we need to do no matter whether we are running on-prem, in AWS, in Google Cloud, in Azure, or anywhere else.

If we want to avoid wasting resources on idle processes, the natural solution is to go towards serverless workloads. Given that we already established that Kubernetes is the preferable platform, such a solution should run on top of it. For CI/CD processes, the most likely standard is Tekton. So we adopted it as the engine to run pipelines.

Further on, we adopted GitOps as the founding principle of the solution. We created ChatOps gateway in between. We adopted Helm as the packaging machenism, Kaniko for building container images, Skaffold for defining different profiles, and so on and so forth.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.9), rgba(87,185,72,0.9)), url(../img/background/how.jpg) center / cover" -->
<!-- .slide: class="light" -->
## How?

* Join the tools and the processes into a single easy-to-use bundle <!-- .element: class="fragment" -->
* Create an CLI-first experience <!-- .element: class="fragment" -->
* Define an opinionated process <!-- .element: class="fragment" -->

Note:
What matters is that we did not try to reinvent the wheel. We joined the exting tools and processes into a single easy-to-use bundle. We created an opinionated way to perform every step in the lifecycle of an application by combining the collective knowledge of the industry as a whole.


<!-- .slide: data-background="../img/products/cd-foundation.jpg" -->


<!-- .slide: data-background="img/jenkins-x-wide.png" -->
