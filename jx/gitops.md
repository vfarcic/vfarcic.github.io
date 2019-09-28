<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/products/git.png) center / cover" -->
<!-- .slide: class="center" -->

# Code Repository

Note:
Git is the de-facto code repository standard. Hardly anyone argues against that statement today. 


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/why.jpg) center / cover" -->
<!-- .slide: class="center" -->

# The Only Source Of Truth?

Note:
Where we might disagree is whether Git is the only source of truth, or even what we consider by that.

When I speak with teams and ask them whether Git is their only source of truth, almost everyone always answers *yes*. However, when I start digging, it usually turns out that's not true. Can you recreate everything using only the code in Git? By everything, I mean the whole cluster and everything running in it. Is your entire production system described in a single repository? If the answer to that question is *yes*, you are doing a great job, but we're not yet done with questioning. Can any change to your system be applied by making a pull request, without pressing any buttons in Jenkins or any other tool? If your answer is still *yes*, you are most likely already applying GitOps principles.

GitOps is a way to do Continuous Delivery. It assumes that Git is a single source of truth and that both infrastructure and applications are defined using the declarative syntax (e.g., YAML). Changes to infrastructure or applications are made by pushing changes to Git, not by clicking buttons in Jenkins.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/why.jpg) center / cover" -->
<!-- .slide: class="center" -->

# Where Is Code, Tests, Build Scripts, Pipelines, etc?

Note:
Developers understood the need for having a single source of truth for their applications a while back. Nobody argues anymore whether everything an application needs must be stored in the repository of that application. That's where the code is, that's where the tests are, that's where build scripts are located, and that's where the pipeline of that application is defined.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/why.jpg) center / cover" -->
<!-- .slide: class="center" -->

# How About Infrastructure, Environments, And Releases?

Note:
The part that is not yet that common is to apply the same principles to infrastructure. We can think of an environment (e.g., production) as an application. As such, everything we need related to an environment must be stored in a single Git repository. We should be able to recreate the whole environment, from nothing to everything, by executing a single process based only on information in that repository. We can also leverage the development principles we apply to applications. A rollback is done by reverting the code to one of the Git revisions. Accepting a change to an environment is a process that starts with a pull request. And so on, and so forth.

The major challenge in applying GitOps principles is to unify the steps specific to an application with those related to the creation and maintenance of whole environments. At some moment, pipeline dedicated to our application needs to push a change to the repository that contains that environment. In turn, since every process is initiated through a Git webhook fired when there is a change, pushing something to an environment repo should launch another build of a pipeline.

Where many diverge from "Git as the only source of truth" is in the deploy phase. Teams often build a Docker image and use it to run containers inside a cluster without storing the information about the specific release to Git. Stating that the information about the release is stored in Jenkins breaks the principle of having a single source of truth. It prevents us from being able to recreate the whole production system through information from a single Git repository. Similarly, saying that the data about the release is stored as a Git tag breaks the principle of having everything stored in a declarative format that allows us to recreate the whole system from a single repository.

Many things might need to change for us to make the ideas behind GitOps a reality. For the changes to be successful, we need to define a few rules that we'll use as must-follow commandments. Given that the easiest way to understand something is through vivid examples, I will argue that **the processes employed in Continuous Delivery and DevOps are similar to how Buckingham Palace operates and are very different from Hogwarts School of Witchcraft and Wizardry**. If that did not spark your imagination, nothing will. But, since humans like to justify their actions with rules and commandments, we'll define a few of those as well.


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Project

```bash
jx create quickstart --filter golang-http --project-name jx-go \
    --batch-mode

cd jx-go
```


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/god.jpg) center / cover" -->
<!-- .slide: class="center" -->


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/products/git.png) center / cover" -->
<!-- .slide: class="center" -->
# 1.

# Git Is The Only Source Of Truth

Note:
The rule to rule them all is that **Git is the only source of truth**. It is the first and the most important commandment. All application-specific code in its raw format must be stored in Git. By code, I mean not only the code of your application, but also its tests, configuration, and everything else that is specific to that app or the system in general. I intentionally said that it should be in **raw format** because there is no benefit of storing binaries in Git. That's not what it's designed for. The real question is why do we want those things? For one, good development practices should be followed. Even though we might disagree which practices are good, and which aren't, they are all levitating around Git. If you're doing code reviews, you're doing it through Git. If you need to see change history of a file, you'll see it through Git. If you find a developer that is doubting whether the code should be in Git (or some other code repository), please make sure that he's isolated from the rest of the world because you just found a specimen of endangered species. There are only a few left, and they are bound to be extinct.

While there is no doubt among developers where to store the files they create, that's not necessarily true for other types of experts. I see testers, operators, and people in other roles that are still not convinced that's the way to go and whether absolutely everything should be documented and stored in Git. As an example, I still meet operators who run ad-hoc commands in their servers. As we all know, ad-hoc commands executed inside servers are not reliably reproducible, they are often not documented, and the result of their execution is often not idempotent.


<!-- .slide: data-background="img/gitops-apps.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Git Is The Only Source Of Truth

```bash
cat main.go | sed -e "s@golang http@GitOps@g" | tee main.go

git add .

git commit -m "This is GitOps"

git push

jx get activities -f jx-go -w
```


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/products/git.png) center / cover" -->
<!-- .slide: class="center" -->
# 2.

# Everything must be tracked, every action must be reproducible, and everything must be idempotent

Note:
So, let's create a second rule. **Everything must be tracked, every action must be reproducible, and everything must be idempotent**. If you just run a command instead of creating a script, your activities are not documented. If you did not store it in Git, others will not be able to reproduce your actions. Finally, that script must be able to produce the same result no matter how many times we execute it. Today, the easiest way to accomplish that is through declarative syntax. More often than note, that would be YAML or JSON files that describe the desired outcome, instead of imperative scripts. Let's take installation as an example. If it's imperative (install something), it will fail if that something is already installed. It won't be idempotent.

Every change must be recorded (tracked). The most reliable and the easiest way to accomplish that is by allowing people only to push changes to Git. Just that and nothing else is the acceptable human action! What that means is that if we want our application to have a new feature, we need to write code and push it to Git. If we want it to be tested, we write tests and push them to Git, preferably at the same time as the code of the application. If we need to change a configuration, we update a file and push it to Git. If we need to install or upgrade OS, we make changes to files of whichever tool we're using to manage our infrastructure, and we push them to Git. Rules like those are apparent, and I can go on for a long time stating what we should do. It all boils down to sentences that end with *push it to Git*. What is more interesting is what we should NOT do.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(img/confused.jpg) center / cover" -->
<!-- .slide: class="center" -->

Note:
You are not allowed to add a feature of an application by changing the code directly inside production servers. It does not matter how big or small the change is, it cannot be done by you, because you cannot provide a guarantee that the change will be documented, reproducible, and tracked. Machines are much more reliable than you when performing actions inside your production systems. You are their overlord, you're not one of them. Your job is to express the desired state, not to change the system to comply with it.

The real challenge is to decide how will that communication be performed. How do we express our desires in a way that machines can execute actions that will result in convergence of the actual state into the desired one? We can think of us as aristocracy and the machines as servants.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(img/king.jpg) center / cover" -->
<!-- .slide: class="center" -->

Note:
The good thing about aristocracy is that there is no need to do much work. As a matter of fact, not doing any work is the main benefit of being a king, a queen, or an heir to the throne. Who would want to be a king if that means working as a car mechanic? No girl dreams of becoming a princess if that would mean working in a supermarket. Therefore, if being an aristocrat means not doing much work, we still need someone else to do it for us. Otherwise, how will our desires become a reality? That's why aristocracy needs servants. Their job is to do their biddings.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(img/slave.jpg) center / cover" -->
<!-- .slide: class="center" -->

Note:
Given that human servitude is forbidden in most of the world, we need to look for servants outside the human race. Today, servants are bytes that are converted into processes running inside machines. We (humans) are the overlords and machines are our slaves.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/servers.jpg) center / cover" -->
<!-- .slide: class="center" -->

Note:
However, since it is not legal to have slaves, nor it is politically correct to call them that, we will refer to them as agents. So, we (humans) are overlords of agents (machines).


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/communication.jpeg) center / cover" -->
<!-- .slide: class="center" -->

Note:
If we are true overlords that trust the machines to do our biddings, there is no need for that communication to be synchronous. When we trust someone always to do our bidding, we do not need to wait until our desires are fulfilled.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(img/restaurant.jpg) center / cover" -->
<!-- .slide: class="center" -->

Note:
Let's imagine that you are in a restaurant and you tell a waiter "I'd like a burger with cheese and fries." What do you do next? Do you get up, go outside the restaurant, purchase some land, and build a farm? Are you going to grow animals and potatoes? Will you wait until they are mature enough and take them back to the restaurant. Will you start frying potatoes and meat? To be clear, it's completely OK if you like owning land and if you are a farmer. There's nothing wrong in liking to cook. But, if you went to a restaurant, you did that precisely because you did not want to do those things. The idea behind an expression like "I'd like a burger with cheese and fries" is that we want to do something else, like chatting with friends and eating food. We know that a cook will prepare the meal and that our job is not to grow crops, to feed animals, or to cook. We want to be able to do other things before eating. We are like aristocracy and, in that context, farmers, cooks, and everyone else involved in the burger industry are our agents (remember that slavery is bad). So, when we request something, all we need is an acknowledgment. If the response to "I'd like a burger with cheese and fries" is "consider it done", we got the *ack* we need, and we can do other things while the process of creating the burger is executing. Farming, cooking, and eating can be parallel processes. For them to operate concurrently, the communication must be asynchronous. We request something, we receive an acknowledgment, and we move back to whatever we were doing. 


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/communication.jpeg) center / cover" -->
<!-- .slide: class="center" -->
# 3.

# Communication between processes must be asynchronous

Note:
So, the third rule is that **communication between processes must be asynchronous** if operations are to be executed in parallel. If we already agreed that the only source of truth is Git (that's where all the information is), then the logical choice for asynchronous communication is webhooks. Whenever we push a change to any of the repositories, a webhook can be triggered to the system. As a result, the new desire expressed through code (or config files), can be propagated to the system which, in turn, should delegate tasks to different processes.


<!-- .slide: data-background="img/gitops-webhooks.png" data-background-size="contain" -->

Note:
We are yet to design such a system. For now, think of it a one or more entities inside our cluster. If we apply the principle of having everything defined as code and stored in Git, there is no reason why those webhooks wouldn't be the only operational entry point to the system. There is no excuse to allow SSH access to anyone (any human). If you define everything in Git, what additional value can you add if you're inside one of the nodes of the cluster?

Depending on the desired state, the actor that should converge the system can be Kubernetes, Helm, Istio, a cloud or an on-prem provider, or one of many other tools. More often than not, multiple processes need to perform some actions in parallel. That would pose a problem if we'd rely only on webhooks. By their nature, they are not good at deciding who should do what. If we draw another parallel between aristocracy and servants (agents), we would quickly spot how it might be inconvenient for royalty to interact directly with their staff. Having one servant is not the same as having tens or hundreds. For that, royalty came to the idea to employ a butler. He is the chief manservant of a house (or a court). His job is to organize servants so that our desires are always fulfilled. He knows when you like to have lunch, when you'd want to have a cup of tea or a glass of Gin&Tonic, and he's always there when you need something he could not predict.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(img/butler.jpg) center / cover" -->
<!-- .slide: class="center" -->

Note:
Given that our webhooks (requests for change) are dumb and incapable of transmitting our desires to each individual component of the system, we need something equivalent to a butler. We need someone (or something) to make decisions and make sure that each desire is converted into a set of actions and assigned to different actors (processes). That butler is a component in the Jenkins X bundle. Which one it is, depends on our needs or, to be more precise, whether the butler should be static or serverless. Jenkins X supports both and makes those technical details transparent.

Every change to Git triggers a webhook request to a component in the Jenkins X bundle. It, in turn, responds only with an acknowledgment (ACK) letting Git know that it received a request. Think of *ack* as a subtle nod followed with the butler exiting the room and starting the process right away. He might call a cook, a person in charge of cleaning, or even an external service if your desire cannot be fulfilled with the internal staff. In our case, the staff (servants, slaves) are different tools and processes running inside the cluster. Just as a court has servants with different skillsets, our cluster has them as well. The question is how to organize that staff so that they are as efficient as possible. After all, even aristocracy cannot have unlimited manpower at their disposal.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(img/buckingham-palace.jpg) center / cover" -->
<!-- .slide: class="center" -->

Note:
Let's go big and declare ourselves royalty of a wealthy country like the United Kingdom (UK). We'd live in Buckingham Palace. It's an impressive place with 775 rooms. Of those, 188 are stuff rooms. We might draw the conclusion that the staff counts 188 as well, but the real number is much bigger. Some people live and work there, while others come only to perform their services. The number of servants (staff, employees) varies. You can say that it is elastic. Whether people sleep in Buckingham Palace or somewhere else depends on what they do. Cleaning, for example, is happening all the time.

Given that royalty might be a bit spoiled, they need people to be available almost instantly. "Look at that. I just broke a glass, and a minute later a new one materialized next to me, and the pieces of the broken glass disappeared."


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(img/hogwarts.jpg) center / cover" -->
<!-- .slide: class="center" -->

Note:
Since that is Buckingham Palace and not Hogwarts School of Witchcraft and Wizardry, the new glass did not materialize by magic, but by a butler that called a servant specialized in fixing the mess princesses and princes keep doing over and over again. Sometimes a single person can fix the mess (broken glass), and at other times a whole team is required (a royal ball turned into alcohol-induced shenanigans).


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(img/staff.jpg) center / cover" -->
<!-- .slide: class="center" -->

Note:
Given that the needs can vary greatly, servants are often idle. That's why they have their own rooms. Most are called when needed, so only a fraction is doing something at any given moment. They need to be available at any time, but they also need to rest when their services are not required. They are like Schrodinger's cats that are both alive and dead. Except that being dead would be a problem due to technological backwardness that prevents us from reviving the dead. Therefore, when there is no work, a servant is idle (but still alive). In our case, making something dead or alive on a moments notice is not an issue since our agents are not humans, but bytes converted into processes. That's what containers give us, and that's what serverless is aiming for.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/servers.jpg) center / cover" -->
<!-- .slide: class="center" -->
# 4.

# Processes should run for as long as needed, but not longer

Note:
By being able to create as many processes as needed, and by not having processes that we do not use, we can make our systems scalable, fault tolerant, and efficient. So, the next rule we'll define is that **processes should run for as long as needed, but not longer**. That can be containers that scale down from something to zero, and back again. You can call it serverless. The names do not matter that much. What does matter is that everything idle must be killed, and all those alive should have all the resources they need. That way, our butler (Jenkins, prow, something else) can organize tasks as efficiently as possible. He has an unlimited number of servants (agents, Pods) at his disposal, and they are doing something only until the task is done.


<!-- .slide: data-background="img/gitops-agents.png" data-background-size="contain" -->

Note:
Today, containers (in the form of Pods) allow us just that. We can start any process we want, it will run only while it's doing something useful (while it's alive), and we can have as many of them as we need if our infrastructure is scalable. A typical set of tasks our butler might assign can be building an application through Go (or whichever language we prefer), packaging it as a container image and as a Helm chart, running a set of tests, and (maybe) deploying the application to the staging environment.


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Processes should run for as long as needed, but not longer

```bash
kubectl get pods
```


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/servers.jpg) center / cover" -->
<!-- .slide: class="center" -->
# 5.

# All binaries must be stored in registries

Note:
In most cases, our pipelines will generate some binaries. Those can be libraries, container images, Helm packages, and many others. Some of those might be temporary and needed only for the duration of a build. A good example could be a binary of an application. We need it to generate a container image. Afterward, we can just as well remove it since that image is all we need to deploy the application. Since we're running the steps inside a container, there is no need to remove anything, because the Pods and the containers they contain are removed once builds are finished. However, not all binaries are temporary. We do need to store container images somewhere. Otherwise, we won't be able to run them inside the cluster. The same is true for Helm charts, libraries (those used as dependencies), and many others. For that, we have different applications like Docker registry (container images), ChartMuseum (Helm charts), Nexus (libraries), and so on. What is important to understand, is that we store in those registries only binaries, and not code, configurations, and other raw-text files. Those must go to Git because that's where we track changes, that's where we do code reviews, and that's where we expect them to be. Now, in some cases, it makes sense to keep raw files in registries as well. They might be an easier way of distributing them to some groups. Nevertheless, Git is the single source of truth, and it must be treated as such. All that leads us to yet another rule that states that **all binaries must be stored in registries** and that raw files can be there only if that facilitates distribution while understanding that those are not the sources of truth.


<!-- .slide: data-background="img/gitops-registries.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Binaries in registries

```bash
CM_ADDR=$(kubectl get ing chartmuseum \
    -o jsonpath="{.spec.rules[0].host}")

curl "http://$CM_ADDR/index.yaml"
```


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/why.jpg) center / cover" -->
<!-- .slide: class="center" -->
# Where do we store environments definition?

Note:
We already established that all code and configurations (excluding secrets) must be stored in Git as well as that Git is the only entity that should trigger pipelines. We also argued that any change must be recorded. A typical example is a new release. It is way too common to deploy a new release, but not to store that information in Git. Tags do not count because we cannot recreate a whole environment from them. We'd need to go from tag to tag to do that. The same is true for release notes. While they are very useful and we should create them, we cannot diff them, nor we can use them to recreate an environment. What we need is a place that defines a full environment. It also needs to allow us to track changes, to review them, to approve them, and so on. In other words, what we need from an environment definition is not conceptually different from what we expect from an application. We need to store it in a Git repository. There is very little doubt about that. What is less clear is which repository should have the information about an environment.

We should be able to respond not only to a question "which release of an application is running in production?" but also "what is production?" and "what are the releases of all the applications running there?" If we would store information about a release in the repository of the application we just deployed, we would be able to answer only to the first question. We would know which release of our app is in an environment. What we could not answer easily answer is the same question but referred to the whole environment, not only to one application. Or, to be more precise, we could not do that easily. We'd need to go from one repository to another.

Another important thing we need to have in mind is the ability to recreate an environment (e.g., staging or production). That cannot be done easily if the information about the releases is spread across many repositories.

All those requirements lead us to only one solution. Our environments need to be in separate repositories or, at least, in different branches within the same repository. Given that we agreed that information is first pushed in Git which, in turn, triggers processes that do something with it, we cannot deploy a release to an environment directly from a build of an application. Such a build would need to push a change to the repository dedicated to an environment. In turn, such a push would trigger a webhook that would result in yet another build of a pipeline.

When we write new code, we tend not to push directly to the master branch, but to create pull requests. Even if we do not need approval from others (e.g., code review) and plan to push it to the master branch directly, having a pull request is still very useful. It provides an easy way to track changes and intentions behind them. Now, that does not mean that I am against pushing directly to master. Quite the contrary. But, such practice requires discipline and technical and process mastery that is still out of reach of many. So, I will suppose that you do work with pull requests.

If we are supposed to create pull requests of things we want to push to master branches of our applications, there is no reason why we shouldn't treat environments the same. What that means is not only that our application builds should push releases to environment-specific branches, but that they should do that by making pull requests.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/products/git.png) center / cover" -->
<!-- .slide: class="center" -->
# 6.

# Information about all the releases must be stored in environment-specific repositories or branches

Note:
Taking all that into account the next two rules should state that **information about all the releases must be stored in environment-specific repositories or branches**.


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Releases in env-specific repos

---

```bash
open "https://github.com/vfarcic/environment-jx-rocks-staging/blob/master/env/requirements.yaml"
```


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/best-practices.jpg) center / cover" -->
<!-- .slide: class="center" -->
# 7.

# Everything must follow the same coding practices

Note:
**everything must follow the same coding practices** (environments included).


<!-- .slide: data-background="img/gitops-env.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## The same coding practices

---

```bash
open "https://github.com/vfarcic/environment-jx-rocks-staging/pulls"
```

Note:
The correct way to execute the flow while adhering to the rules we mentioned so far would be to have as many pipelines as there are applications, plus a pipeline for deployment to each of the environments. A push to the application repository should initiate a pipeline that builds, tests, and packages the application. It should end by pushing a change to the repository that defines a whole environment (e.g., staging, production, etc.). In turn, that should initiate a different pipeline that (re)deploys the entire environment. That way, we always have a single source of truth. Nothing is done without pushing code to a code repository.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/deployment.png) center / cover" -->
<!-- .slide: class="center" -->
# 8.

# All deployments must be idempotent

Note:
Always deploying the whole environment would not work without idempotency. Fortunately, Kubernetes, as well as Helm, already provide that. Even though we always deploy all the applications and the releases that constitute an environment, only the pieces that changed will be updated. That brings us to a new rule. **All deployments must be idempotent**.

Having everything defined in code and stored in Git is not enough. We need those definitions and that code to be used reliably. Reproducibility is one of the key features we're looking for. Unfortunately, we (humans) are not good at performing reproducible actions. We make mistakes, and we are incapable of doing exactly the same thing twice. We are not reliable. Machines are. If conditions do not change, a script will do exactly the same thing every time we run it. While scripts provide repetition, declarative approach gives us idempotency.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(img/desire.jpg) center / cover" -->
<!-- .slide: class="center" -->

Note:
But why do we want to use declarative syntax to describe our systems? The main reason is in idempotency provided through our expression of a desire, instead of imperative statements. If we have a script that, for example, creates ten servers, we might end up with fifteen if there are already five nodes running. On the other hand, if we declaratively express that there should be ten servers, we can have a system that will check how many do we already have, and increase or decrease the number to comply with our desire. We need to let machines not only do the manual labour but also to comply with our desires. We are the masters, and they are slaves, at least until their uprising and AI takeover of the world.

Where we do excel is creativity. We are good at writing scripts and configurations, but not at running them. Ideally, every single action performed anywhere inside our systems should be executed by a machine, not by us. We accomplish that by storing the code in a repository and letting all the actions execute as a result of a webhook firing an event on every push of a change.


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Idempotent deployments

```bash
cd ..

git clone https://github.com/vfarcic/environment-jx-rocks-staging.git

cd environment-jx-rocks-staging/env

CM_ADDR=$(kubectl get ing chartmuseum \
    -o jsonpath="{.spec.rules[0].host}")

cat requirements.yaml | sed -e \
    "s@http://jenkins-x-chartmuseum:8080@http://$CM_ADDR@g" \
    | tee requirements.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Idempotent deployments

```bash
jx step helm apply --namespace jx-staging

kubectl -n jx-staging get pods
```


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/products/git.png) center / cover" -->
<!-- .slide: class="center" -->
# 9.

# Git webhooks are the only ones allowed to initiate a change that will be applied to the system

Note:
Given that we already agreed that Git is the only source of truth and that we need to push a change to see it reflected in the system, we can define the rule that **Git webhooks are the only ones allowed to initiate a change that will be applied to the system**. That might result in many changes in the way we operate. It means that no one is allowed to execute a script from a laptop that will, for example, increase the number of nodes. There is no need to have SSH access to the servers if we are not allowed to do anything without pushing something to Git first.

Similarly, there should be no need even to have admin permissions to access Kubernetes API through `kubectl`. All those privileges should be delegated to machines, and our (human) job should be to create or update code, configurations, and definitions, to push the changes to Git, and to let the machines do the rest. That is hard to do, and we might require considerable investment to accomplish that. But, even if we cannot get there in a short period, we should still strive for such a process and delegation of tasks. Our designs and our processes should be created with that goal in mind, no matter whether we can accomplish them today, tomorrow, or next year.

Finally, there is one more thing we're missing. Automation relies on APIs and CLIs (they are extensions of APIs), not on UIs and editors. While I do not think that the usage of APIs is mandatory for humans, they certainly are for automation. The tools must be designed to be API first, UI (and everything else) second. Without APIs, there is no reliable automation, and without us knowing how to write scripts, we cannot provide the things the machines need.


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Git webhooks initiate a change

```bash
open "https://github.com/vfarcic/jx-go/settings/hooks"
```


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/communication.jpeg) center / cover" -->
<!-- .slide: class="center" -->
# 10.

# All the tools must be able to speak with each other through APIs

Note:
That leads us to the last rule. **All the tools must be able to speak with each other through APIs**.


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Tools communicate through APIs

```bash
jx get applications -e staging

VERSION=[...]

jx promote jx-go --version $VERSION --env production --batch-mode

cd ..
```


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/god.jpg) center / cover" -->
<!-- .slide: class="center" -->

Note:
The rules are not like those we can choose to follow or to ignore. They are all important. Without any of them, everything will fall apart. They are the commandments that must be obeyed both in our processes as well as in the architecture of our applications. They shape our culture, and they define our processes. We will not change those rules, they will change us, at least until we come up with a better way to deliver software.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/god.jpg) center / cover" -->
<!-- .slide: class="center" -->
# 1.

# Git Is The Only Source Of Truth


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/god.jpg) center / cover" -->
<!-- .slide: class="center" -->
# 2.

# Everything must be tracked, every action must be reproducible, and everything must be idempotent


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/god.jpg) center / cover" -->
<!-- .slide: class="center" -->
# 3.

# Communication between processes must be asynchronous


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/god.jpg) center / cover" -->
<!-- .slide: class="center" -->
# 4.

# Processes should run for as long as needed, but not longer


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/god.jpg) center / cover" -->
<!-- .slide: class="center" -->
# 5.

# All binaries must be stored in registries


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/god.jpg) center / cover" -->
<!-- .slide: class="center" -->
# 6.

# Information about all the releases must be stored in environment-specific repositories or branches


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/god.jpg) center / cover" -->
<!-- .slide: class="center" -->
# 7.

# Everything must follow the same coding practices


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/god.jpg) center / cover" -->
<!-- .slide: class="center" -->
# 8.

# All deployments must be idempotent


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/god.jpg) center / cover" -->
<!-- .slide: class="center" -->
# 9.

# Git webhooks are the only ones allowed to initiate a change that will be applied to the system


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/god.jpg) center / cover" -->
<!-- .slide: class="center" -->
# 10.

# All the tools must be able to speak with each other through APIs


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/hell.jpg) center / cover" -->
<!-- .slide: class="center" -->
# Or...
