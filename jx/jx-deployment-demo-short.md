<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Choosing The Right Deployment Strategy

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## What Do We Expect From Deployments?

* fault-tolerant <!-- .element: class="fragment" -->
* highly available <!-- .element: class="fragment" -->
* responsive <!-- .element: class="fragment" -->
* rolling out progressively <!-- .element: class="fragment" -->
* rolling back in case of a failure <!-- .element: class="fragment" -->
* cost-effective <!-- .element: class="fragment" -->

Note:
Before we dive into some of the deployment strategies, we might want to set some expectations that will guide us through our choices. But, before we do that, let's try to define what a deployment is.

Traditionally, a deployment is a process through which we would install new applications into our servers or update those that are already running with new releases. That was, more or less, what we were doing from the beginning of the history of our industry, and that is in its essence what we're doing today. But, as we evolved, our requirements were changing as well. Today, say that all we expect is for our releases to run is an understatement. Today we want so much more, and we have technology that can help us fulfill those desires. So, what does "much more" mean today?

Depending on who you speak with, you will get a different list of "desires". So, mine might not be all-encompassing and include every single thing than anyone might need. What follows is what I believe is essential, and what I observed that the companies I worked typically put emphasis. Without further ado, the requirements, excluding the obvious that applications should be running inside the cluster, are as follows.

Applications should be **fault-tolerant.** If an instance of the application dies, it should be brought back up. If a node where an application is running dies, the application should be moved to a healthy node. Even if a whole data center goes down, the system should be able to move the applications that were running there into a healthy one. An alternative would be to recreate the failed nodes or even whole data centers with precisely the same apps that were running there before the outage. However, that is too slow and, frankly speaking, we moved away from that concept the moment we adopted schedulers. That does not mean that failed nodes and failed data centers should not recuperate, but rather that we should not wait for infrastructure to get back to normal. Instead, we should run failed applications (no matter the cause) on healthy nodes as long as there is enough available capacity.

Fault tolerance might be the most crucial requirement of all. If our application is not running, our users cannot use it. That results in dissatisfaction, loss of profit, churn, and quite a few other adverse outcomes. Still, we will not use fault tolerance as a criterion because Kubernetes makes (almost) everything fault-tolerant. As long as it has enough available capacity, our applications will run. So, even that is an essential requirement, it is off the table because we are fulfilling it no matter the deployment strategy we choose. That is not to say that there is no chance for an application not to recuperate from a failure but instead that Kubernetes provides a reasonable guarantee of fault tolerance. If things do go terribly wrong, we are likely going to have to do some manual actions no matter which deployment strategy we choose.

Long story short, fault-tolerance is a given with Kubernetes, and there's no need to think about it in terms of deployment strategies.

The next in line is **high availability**, and that a trickier one.

Being fault-tolerant means that the system will recuperate from failure, not that there will be no downtime. If our application goes down, a few moments later, it will be up-and-running again. Still, those few moments can result in downtime. Depending on many factors, "few moments" can be translated to milliseconds, seconds, minutes, hours, or even days. It is certainly not the same whether our application is unavailable during milliseconds as opposed to hours. Still, for the sake of brevity, we'll assume that any downtime is bad and look at things as black and white. Either there is, or there isn't downtime. Or, to be more precise, either there is a considerable downtime, or there isn't. What changed over time is what "considerable" means. In the past, having 99% availability was a worthy goal for many. Today, that figure is unacceptable. Today we are talking about how many nines there are after the decimal. For some, 99.99% uptime is acceptable. For others, that could be 99.99999%.

Now, you might say: "my business is important; therefore, I want 100% uptime." If anyone says that to you, feel free to respond with: "you have no idea what you're talking about." Hundred percent uptime is impossible, assuming that by that we mean "real" uptime, and not "my application runs all the time."

Making sure that our application is always running is not that hard. Making sure that not a single request is ever lost or, in other words, that our users perceive our application as being always available, is impossible. By the nature of HTTP, some requests will fail. Even if that never happens (as it will), network might go down, storage might fail, or some other thing might happen. Any of those is bound to produce at least one request without a response or with a 4xx or 5xx message.

All in all, high-availability means that our applications are responding to our users most of the time. By "most", we mean at least 99.99%. Even that is a very pessimistic number that would result in one failure for each ten thousand requests.

What are the common causes of unavailability? We already discussed those that tend to be the first associations (hardware and software failures). However, those are often not the primary causes of unavailability. You might have missed something in your tests, and that might cause a malfunction. More often than not, those are not failures caused by "obvious" bugs but rather by those that manifest themselves a while after a new release is deployed. I will not tell you that you should make sure that there are no bugs because that is impossible). Instead, I'll tell you that you should focus on detecting those that sneak into production. It's as important to try to avoid bugs as to minimize their effect to as few users as possible. So, our next requirement will be that our deployments should reduce the number of users affected by bugs. We'll call it **progressive rollout**. Don't worry if you never heard that term. We'll explain it in more depth later.

Progressive rollout, as you'll see later, does allow us to abort upgrades or, to be more precise, not to proceed with them, if something goes wrong. But that might not be enough. We might need not only to abort deployment of a new release but also to roll back what the one we had before. So, we'll add **rollback** as yet another requirement.

We'll probably find more requirements directly or indirectly related to high-availability or, to inverse it, to unavailability. For now, we'll leave those aside, and move to yet another vital aspect. We should strive to make our applications **responsive**, and there are many ways to accomplish that. We can design our apps in a certain way, we can avoid congestions and memory leaks, and we can do many other things. However, right now, that's not the focus. We're interested in things that are directly or indirectly related to deployments. With such a limited scope, scalability is the key to responsiveness. If we need more replicas of our application, it should scale up. Similarly, if we do not need as many, it should scale down and free the resources for some other processes if cost savings are not a good enough reason.

Finally, we'll add one more requirement. It would be nice if our applications do not use more resources than it is necessary. We can say that scalability provides that (it can scale up and down) but we might want to take it a step further and say that our applications should not use (almost) any resources when they are not in use. We can call that "nothing when idle" or, use a more commonly used term, serverless. 

I'll use this as yet another opportunity to express my disgust with that term given that it implies that there are no servers involved. But, since it is a commonly used one, we'll stick with it. After all, it's still better than calling it function-as-a-service since that is just as misleading as serverless, and it occupies more characters (it is a longer word). However, serverless is not the real goal. What matters is that our solution is **cost-effective**, so that will be our last requirement.

Are those all the requirements we care for. They certainly aren't. But, this text cannot contain an infinite number of words, and we need to focus on something. Those, in my experience, are the most important ones, so we'll stick with them, at least for now.

Another thing we might need to note is that those requirements or, to be more precise, that those features are all interconnected. More often than not, one cannot be accomplished without the other or, in some other cases, one facilitates the other and makes it easier to accomplish.

Another thing worth noting is that we'll focus only on automation. For example, I know perfectly well that anything can be rolled back through human intervention. I know that we can extend our pipelines with post-deployment tests followed with a rollback step in case they fail. As a matter of fact, anything can be done with enough time and manpower. But that's not what matters in this discussion. We'll ignore humans and focus only on the things that can be automated and be an integral part of deployment processes. I don't want you to scale your applications. I want the system to do it for you. I don't want you to roll back in case of a failure. I want the system to do that for you. I don't want you to waste your brain capacity on such trivial tasks. I wish you to spend your time on things that matter and leave the rest to machines.

We'll remove *fault tolerance* from the future discussions since Kubernetes provides that out-of-the-box. As for the rest, we are yet to see whether we can accomplish them all and, if we can, whether a single deployment strategy will give us all those benefits.

There is a strong chance that there is no solution that will provide all those features. Even if we do find such a solution, the chances are that it might not be appropriate for your applications and their architecture. We'll worry about that later. For now, we'll explore some of the commonly used deployment strategies and see which of those requirements they fulfill.

We'll explore the subject in more depth through practical examples. But, before we do that, please note that we will be using Jenkins X. I already used it to create applications with different definition, one for each deployment strategy. I already deployed the first release of each, by pushing changes to Git, and letting Jenkins X reconcile the desired into the actual state.


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Serverless Strategy

```bash
kubectl --namespace jx-staging get pods | grep knative
```

Note:
Instead of discussing the pros and cons first, we'll start each strategy with an example. We'll observe the results, and, based on that, comment on their advantages and disadvantages as well as the scenarios when they might be a good fit. In that spirit, let's start with serverless deployments first and see what we'll get. And for that we will use KNative.

KNative is, what I believe, the most likely standard for running serverless deployments in Kubernetes. Nevertheless, the properties of serverless deployments we are going to explore apply equally to almost any other framework, so think of this as a demonstration of universal properties.

Let's see how many replicas of the application are currently running.

```bash
kubectl --namespace jx-staging get pods | grep knative
```

The output states that `no resources` were `found` in the Namespace. The application is gone. It seems like the application is wiped out completely. That is true in terms that nothing application-specific is running. All that's left are a few Knative definitions and the common resources used for all applications.


<!-- .slide: data-background="img/knative-scale-to-zero.png" data-background-size="contain" -->

Note:
Using telemetry collected from all the Pods deployed as Knative applications, KNative detected that no requests were sent to the application for a while and decided that the time has come to scale it down. It sent a notification to Knative that executed a series of actions which resulted in the application being scaled to zero replicas.


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Serverless Strategy

```bash
export KNATIVE_ADDR=$(kubectl --namespace jx-staging \
    get ksvc jx-knative --output jsonpath="{.status.url}")

kubectl run siege --image yokogawa/siege --generator "run-pod/v1" \
    -it --rm -- --concurrent 300 --time 30S "$KNATIVE_ADDR" \
    && kubectl --namespace jx-staging get pods | grep knative
```

Note:
If you never used serverless deployments and if you never worked with Knative, you might think that your users would not be able to access it anymore since the application is not running. Or you might think that it will be scaled up once requests start coming in, but you might be scared that you will lose those sent before the new replica starts running.

Let us put that to the test by sending three hundred concurrent requests for thirty seconds.

```bash
kubectl run siege --image yokogawa/siege --generator "run-pod/v1" \
    -it --rm -- --concurrent 300 --time 30S "$KNATIVE_ADDR" \
    && kubectl --namespace jx-staging get pods | grep knative
```

We won't go into details about Siege. What matters is that it is sending a certain number of concurrent requests over a specific period.

The application is up-and-running again. A few moments ago, the application was not running, and now it is. Not only that, but it was scaled to mmultiple replicas to accommodate the high number of concurrent requests.


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Serverless Strategy

|Requirement        |Fullfilled|
|-------------------|----------|
|High-availability  |Fully     |
|Responsiveness     |Partly    |
|Progressive rollout|Partly    |
|Rollback           |Not       |
|Cost-effectiveness |Fully     |

Note:
What did we learn from serverless deployments in the context of our quest to find one that fits our needs the best?

High availability is easy in Kubernetes, as long as our applications are designed with that in mind. What that means is that our apps should be scalable and should not contain state. If they cannot be scaled, they cannot be highly available. When a replica fails (note that I did not say *if* but *when*), no matter how fast Kubernetes will reschedule it somewhere else, there will be downtime, unless other replicas take over its load. If there are no other replicas, we are bound to have downtime both due to failures but also whenever we deploy a new release. So, scalability (running more than one replica) is the prerequisite for high availability. At least, that's what logic might make us think.

In the case of serverless deployments with Knative, not having replicas that can respond to user requests is not an issue, at least not from the high availability point of view. While in a "normal" situation, the requests would fail to receive a response, in our case, they were queued in the gateway and forwarded after the application is up-and-running. So, even if the application is scaled to zero replicas (if nothing is running), we are still highly available. The major downside is in potential delays between receiving the first requests and until the first replica of the application is responsive.

The problem we might have with serverless deployments, at least when used in Kubernetes, is responsiveness. If we keep the default settings, our application will scale to zero if there are no incoming requests. As a result, when someone does send a request to our app, it might take longer than usual until the response is received. That could be a couple of milliseconds, a few seconds, or much longer. It all depends on the size of the container image, whether it is already cached on the node where the Pod is scheduled, the amount of time the application needs to initialize, and quite a few other criteria. If we do things right, that delay can be short. Still, any delay reduces the responsiveness of our application, no matter how short or long it is. What we need to do is compare the pros and cons. The results will differ from one app to another.

Let's take the static Jenkins as an example. In many organizations, it is under heavy usage throughout working hours, and with low or no usage at nights. We can say that half of the day it is not used. What that means is that we are paying double to our hosting vendor. We could have shut it down overnight and potentially remove a node from the cluster due to decreased resource usage. Even if the price is not an issue, surely those resources reserved by inactive Jenkins could be better used by some other processes. Shutting down the application would be an improvement, but it would also produce potentially very adverse effects.

What if someone is working overnight and pushes a change to Git. A webhook would fire trying to notify Jenkins that it should run a build. But, such webhook would fail if there is no Jenkins to handle the request. A build would never be executed. Unless we set up a policy that says "you are never allowed to work after 6 pm, even if the whole system crashed", having a non-responsive system is unacceptable.

Another issue would be to figure out when is our system not in use. If we continue using the "traditional" Jenkins as an example, we could say that it should shut-down at 9 pm. If our official working hours end at 6 pm, that will provide three hours margin for those who do stay in the office longer. But, that would still be a suboptimal solution. During much of those three hours, Jenkins would not be used, and it would continue wasting resources. On the other hand, there is still no guarantee that no one will ever push a change after 9 pm.

Knative solves those and quite a few other problems. Instead of shutting down our applications at predefined hours and hoping that no one is using them while they are unavailable, we can let Knative (together with Gloo or Istio) monitor requests. It would scale down if a certain period of inactivity passed. On the other hand, it would scale back up if a request is sent to it. Such requests would not be lost but queued until the application becomes available again.

All in all, I cannot say that Knative might result in non-responsiveness. What I can say is that it might produce slower responses in some cases (between having none and having some replicas). Such periodical slower responsiveness might produce less negative effect than the good it brings. Is it such a bad thing if static Jenkins takes an additional ten seconds to start building something after a whole night of inactivity? Even a minute or two of delay is not a big deal. On the other hand, in that particular case, the upside outweighs the downsides. Still, there are even better examples of the advantages of serverless deployments than Jenkins.

Preview environments might be the best example of wasted resources. Every time we create a pull request, a release is deployed into a temporary environment. That, by itself, is not a waste. The benefits of being able to test and review an application before merging it to master outweigh the fact that most of the time we are not using those applications. Nevertheless, we can do better. Just as we explained in the previous chapter, we can use Knative to deploy to preview environments, no matter whether we use it for permanent environments like staging and production. After all, preview environments are not meant to provide a place to test something before promoting it to production (staging does that). Instead, they provide us with relative certainty that what we'll merge to the master branch is likely code that works well.

If the response delay caused by scaling up from zero replicas is unacceptable in certain situations, we can still configure Knative to have one or more replicas as a minimum. In such a case, we'd still benefit from Knative capabilities. For example, the metrics it uses to decide when to scale might be easier or better than those provided by HorizontalPodAutoscaler (HPA). Nevertheless, the result of having Knative deployment with a minimum number of replicas above zero is similar to the one we'd have with using HPA. So, we'll ignore such situations since our applications would not be serverless. That is not to say that Knative is not useful if it doesn't scale to zero. What it means is that we'll treat those situations separately and stick to serverless features in this section.

What's next in our list of deployment requirements?

Even though we did not demonstrate it through examples, serverless deployments with Knative do not produce downtime when deploying new releases. During the process, all new requests are handled by the new release. At the same time, the old ones are still available to process all those requests that were initiated before the new deployment started rolling out. Similarly, if we have health checks, it will stop the rollout if they fail. In that aspect, we can say that rollout is progressive.

On the other hand, it is not "true" progressive rollout but similar to those we get with rolling updates. Knative, by itself, cannot choose whether to continue progressing with a deployment based on arbitrary metrics. Similarly, it cannot roll back automatically if predefined criteria are met. Just like rolling updates, it will stop the rollout if health checks fail, and not much more. If those health checks fail with the first replica, even though there is no rollback, all the requests will continue being served with the old release. Still, there are too many ifs in those statements. We can only say that serverless deployments with Knative (without additional tooling) partially fulfills the progressive rollout requirement and that they are incapable of automated rollbacks.

Finally, the last requirement is that our deployment strategy should be cost-effective. Serverless deployments, at least those implemented with Knative, are probably the most cost-effective deployments we can have. Unlike vendor-specific serverless implementations like AWS Lambda, Azure Functions, and Google Cloud's serverless platform, we are in (almost) full control. We can define how many requests are served by a single replica. We control the size of our applications given that anything that can run in a container can be serverless (but is not necessarily a good candidate). We control which metrics are used to make decisions and what are the thresholds. Truth be told, that is likely more complicated than using vendor-specific serverless implementations. It's up to us to decide whether additional complications with Knative outweigh the benefits it brings. I'll leave such a decision in your hands.

So, what did we conclude? Do serverless deployments with Knative fulfill all our requirements? The answer to that question is a resounding "no". No deployment strategy is perfect. Serverless deployments provide **huge benefits** with **high-availability** and **cost-effectiveness**. They are **relatively responsive and offer a certain level of progressive rollouts**. The major drawback is the **lack of automated rollbacks**.

|Requirement        |Fullfilled|
|-------------------|----------|
|High-availability  |Fully     |
|Responsiveness     |Partly    |
|Progressive rollout|Partly    |
|Rollback           |Not       |
|Cost-effectiveness |Fully     |


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Recreate Strategy

```bash
cd jx-recreate

kubectl --namespace jx-staging get pods --selector app=jx-jx-recreate

cat main.go | sed -e "s@example@recreate@g" | tee main.go

git add . && git commit -m "Recreate strategy" && git push

cd ..
```

Note:
*A long time ago in a galaxy far, far away,* most of the applications were deployed with what today we call the *recreate* strategy. We'll discuss it shortly. For now, we'll focus on implementing it and observing the outcome.

We'll make yet another simple change to the code. We will change the output message of the application. That will allow us to easily see how it behaves before and after the new release is deployed.

The Git repository will notify Jenkins X that we made a change. In turn, Jenkins X will run a pipeline that will soon deploy a new release of the application.


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Recreate Strategy

* Open a **second terminal**

```bash
export KUBECONFIG=$PWD/terraform-gke/kubeconfig

RECREATE_ADDR=$(kubectl --namespace jx-staging get ing jx-recreate \
    --output jsonpath="{.spec.rules[0].host}")

while true; do
    curl "$RECREATE_ADDR"
    sleep 0.5
done
```

* Go to the **first terminal**

Note:
We will start sending requests to our application before the new release is rolled out. If you're unsure why we need to do that, it will become evident in a few moments.

We created an infinite loop inside which we're sending requests to the application running in staging. To avoid burning your laptop, we also added a short delay of `0.5` seconds.

Initially, the output should consist of an endless list of `Hello from:  Jenkins X golang http example` messages. It means that the deployment of the new release did not yet start. In such a case, all we have to do is wait.

A few moments later, `Hello from:  Jenkins X golang http example` messages will turn into 5xx responses. Our application is down. If this were a "real world" situation, our users would experience an outage. Some of them might even be so disappointed that they would choose not to stick around to see whether we'll recuperate and instead switch to a competing product. I know that I, at least, have a very low tolerance threshold. If something does not work and I do not have a strong dependency on it, I move somewhere else almost instantly. If I'm committed to a service or an application, my tolerance might be a bit more forgiving, but it is not indefinite. I might forgive you one outage. I might even forgive two. But, the third time I cannot consume something, I will start considering an alternative. Then again, that's me, and your users might be more forgiving. Still, even if you do have loyal customers, downtime is not a good thing, and we should avoid it.

The message probably changed again. Now it should be an endless loop of `Hello from:  Jenkins X golang http recreate`. Our application recuperated and is now operational again. It's showing us the output from the new release. If we could erase from our memory the 5xx messages, that would be awesome.


<!-- .slide: data-background="img/recreate.png" data-background-size="contain" -->

Note:
What happened was neither pretty nor desirable. Even if you are not familiar with the `RollingUpdate` strategy (the default one for Kubernetes Deployments), you already experienced it countless times before. You probably did not see those 5xx messages in the previous exercises, and that might make you wonder why did we switch to `Recreate`. Why would anyone want it? The answer to that question is that no one desires such outcomes, but many are having them anyway. I'll explain soon why we want to use the `Recreate` strategy even though it produces downtime. To answer why would anyone want something like that, we'll first explore why was the outage created in the first place.

When we deployed the second release using the `Recreate` strategy, Kubernetes first shut down all the instances of the old release. Only when they all ceased to work, it deployed the new release in its place. The downtime we experienced existed between the time the old release was shut down, and the time the new one became fully operational. The downtime lasted only for a couple of seconds, but that's because our application (*go-demo-6*) boots up very fast. Some other apps might be much slower, and the downtime would be much longer. It's not uncommon for the downtime in such cases to take minutes and sometimes even hours.

We can think of the `Recreate` strategy as a "big bang". There is no transition period, there are no rolling updates, nor there are any other"modern" deployment practices. The old release is shut down, and the new one is put in its place. It's simple and straightforward, but it results in inevitable downtime.

Still, the initial question stands. Who would ever want to use the `Recreate` strategy? The answer is not that much who wants it, but rather who must use it.

Let's take another look at static Jenkins. It is a stateful application that cannot scale. So, replacing one replica at a time as a way to avoid downtime is out of the question. When applications cannot scale, there is no way we could ever accomplish deployments without downtime. Two replicas are a minimum. Otherwise, if only one replica is allowed to run at any given moment, we have to shut it down to make room for the other replica (the one from the new release). So, when there is no scaling, there is no high availability. Downtime, at least related to new releases, is unavoidable.

Why can static Jenkins not scale? There can be many answers to that question, but the main culprit is its state. It is a stateful application unable to share that state across multiple instances. Even if you deploy various Jenkins instances, they will operate independently from each other. Each would have a different state and manage different pipelines. That, dear reader, is not scaling. Having multiple independent instances of an application is not replication. For an application to be scalable, each replica needs to work together with others and share the load. As a rule of thumb, for an application to be scalable, it needs to be stateless (e.g., *go-demo-6*) or to be able to replicate state across all replicas (e.g., MongoDB). Jenkins does not fulfill either of the two criteria and, therefore, it cannot scale. Each instance has its separate file storage where it keeps the state unique to that instance. The best we can do with static Jenkins is to give an instance to each team. That solves quite a few Jenkins-specific problems, but it does not make it scalable. As a result, it is impossible to upgrade Jenkins without downtime.

Upgrades are not the only source of downtime with unscalable applications. If we have only one replica, Kubernetes will recreate it when it fails. But that will also result in downtime. As a matter of fact, failure and upgrades of single-replica applications are more or less the same processes. In both cases, the only replica is shut down, and a new one is put in its place. There is downtime between those two actions.

All that might leads you to conclude that only single-replica applications should use the `Recreate` strategy. That's not true. There are many other reasons while the "big bang" deployment strategy should be applied. We won't have time to discuss all. Instead, I'll mention only one more example.

The only way to avoid downtime when upgrading applications is to run multiple replicas and start replacing them one by one or in batches. It does not matter much how many replicas we shut down and replace with those of the new release. We should be able to avoid downtime as long as there is at least one replica running. So, we are likely going to run new releases in parallel with the old ones, at least for a while. We'll go through that scenario soon. For now, trust me when I say that running multiple releases of an application in parallel is unavoidable if we are to perform deployments without downtime. That means that our releases must be backward compatible, that our applications need to version APIs, and that clients need to take that versioning into account when working with our apps. Backward compatibility is usually the main stumbling block that prevents teams from applying zero-downtime deployments. It extends everywhere. Database schemas, APIs, clients, and many other components need to be backward compatible.

All in all, inability to scale, statefulness, lack of backward compatibility, and quite a few other things might prevent us from running two releases in parallel. As a result, we are forced to use the `Recreate` strategy or something similar.

So, the real question is not whether anyone wants to use the `Recreate` strategy, but rather who is forced to apply it due to the problems usually related to the architecture of an application. If you have a stateful application, the chances are that you have to use that strategy. Similarly, if your application cannot scale, you are probably forced to use it as well.

Given that deployment with the `Recreate` strategy inevitably produces downtime, most teams tend to have less frequent releases. The impact of, let's say, one minute of downtime is not that big if we produce it only a couple of times a year. But, if we would increase the release frequency, that negative impact would increase as well. Having downtime a couple of times a year is much better than once a month, which is still better than if we'd have it once a day. High-velocity iterations are out of the question. We cannot deploy releases frequently if we experience downtime each time we do that. In other words, zero-downtime deployments are a prerequisite for high-frequency releases to production. Given that the `Recreate` strategy does produce downtime, it stands to reason that it fosters less frequent releases to production as a way to reduce the impact of downtime.

Before we proceed, it might be important to note that there was no particular reason to use the `Recreate` deployment strategy. The *jx-progressive* application is scalable, stateless, and it is designed to be backward compatible. Any other strategy would be better suited given that zero-downtime deployment is probably the most important requirement we can have. We used the `Recreate` strategy only to demonstrate how that deployment type works and to be consistent with other examples in this chapter.


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Recreate Strategy

|Requirement        |Fulfilled|
|-------------------|----------|
|High-availability  |Not       |
|Responsiveness     |Not       |
|Progressive rollout|Not       |
|Rollback           |Not       |
|Cost-effectiveness |Not       |

Note:
Now that we saw how the `Recreate` strategy works, let's see which requirements it fulfills, and which it fails to address. As you can probably guess, what follows is not going to be a pretty picture.

When there is downtime, there is no high-availability. One excludes the other, so we failed with that one.

Is our application responsive? If we used an application that is more appropriate for that type of deployment, we would probably discover that it would not be responsive or that it would be using more resources than it needs. Likely we'd experience both side effects.

If we go back to static Jenkins as an excellent example for the `Recreate` deployment strategy, we would quickly discover that it is expensive to run it. Now, I do not mean expensive in terms of licensing costs but rather in resource usage. We'd need to set it up to always use memory and CPU required for its peak load. We'd probably take a look at metrics and try to figure out how much memory and CPU it uses when the most concurrent builds are running. Then, we'd increase those values to be on the safe side and set them as requested resources. That would mean that we'd use more CPU and memory than what is required for the peak load, even if most of the time we need much less. In the case of some other applications, we'd let them scale up and down and, in that way, balance the load while using only the resources they need. But, if that would be possible with Jenkins, we would not use the `Recreate` strategy. Instead, we'd have to waste resources to be on the safe side, knowing that it can handle any load. That's very costly. The alternative would be to be cheaper and give it fewer resources than the peak load. However, in that case, it would not be responsive given that the builds at the peak load would need to be queued. Or, even worse, it would just bleed out and fail under a lot of pressure. In any case, a typical application used with the `Recreate` deployment strategy is often unresponsive, or it is expensive. More often than not, it is both.

The only thing left is to see whether the `Recreate` strategy allows progressive rollout and automated rollbacks. In both cases, the answer is a resounding no. Given that most of the time only one replica is allowed to run, progressive rollout is impossible. On the other hand, there is no mechanism to roll back in case of a failure. That is not to say that it is not possible to do that, but that it is not incorporated into the deployment process itself. We'd need to modify our pipelines to accomplish that. Given that we're focused only on deployments, we can say that rollbacks are not available.

What's the score? Does the `Recreate` strategy fulfill all our requirements? The answer to that question is a huge "no". Did we manage to get at least one of the requirements? The answer is still no. "Big bang" deployments do **not provide high-availability**. They are **not cost-effective**. They are **rarely responsive**. There is **no possibility to perform progressive rollouts**, and they come with **no automated rollbacks**.

As you can see, that was a very depressing outcome. Still, the architecture of our applications often forces us to apply it. We need to learn to live with it, at least until the day we are allowed to redesign those applications or throw them to thrash and start over.

I hope that you never worked with such applications. If you didn't, you are either very young, or you always worked in awesome companies. I, for example, spent most of my career with applications that had to be put down for hours every time we deploy a new release. I had to come to the office during weekends because that's then the least number of people were using our applications. I had to spend hours or even days doing deployments. I spent too many nights sleeping in the office over weekends. Luckily, we had only a few releases a year. Those days now feel like a nightmare that I never want to experience again. That might be the reason why I got interested in automation and architecture. I wanted to make sure that I replace myself with scripts.

From here on, the situation can only be more positive. Brace yourself for an increased level of happiness.


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Rolling Update Strategy

```bash
cd jx-rolling

cat main.go | sed -e "s@example@rolling update@g" | tee main.go

git add . && git commit -m "Rolling update" && git push

cd ..
```

Note:
We explored one of the only two strategies we can use with Kubernetes Deployment resource. As we saw, the non-default `Recreate` is meant to serve legacy applications that are typically stateful and often do not scale. Next, we'll see what the Kubernetes community thinks is the default way we should deploy our software.

I will change the application's return message so that we can track the change easily from one release to the other.

```bash
cat main.go | sed -e \
    "s@recreate@rolling update@g" \
    | tee main.go

git add .

git commit -m "Recreate strategy"

git push
```

We made the changes and pushed them to the GitHub repository. Jenkins X will make sure that the new release is deployed. 


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Rolling Update Strategy

* Go to the **second terminal**

```bash
ROLLING_ADDR=$(kubectl --namespace jx-staging get ing jx-rolling \
    --output jsonpath="{.spec.rules[0].host}")

while true; do
    curl "$ROLLING_ADDR"
    sleep 0.5
done
```

* Go to the **first terminal**

Note:
Now, all that's left is to execute another loop. We'll keep sending requests to the application and display the output.

The output should be a long list of `Hello from:  Jenkins X golang http recreate` messages. After a while, when the new release is deployed, it will suddenly switch to `Hello from:  Jenkins X golang http rolling update!`.

As you can see, this time, there was no downtime. The application switched from one release to another, or so it seems. But, if that's what happened, we would have seen some downtime, unless that switch happened exactly in those 0.5 seconds between the two requests.


<!-- .slide: data-background="img/rolling-update.png" data-background-size="contain" -->

Note:
With the `RollingUpdate` strategy, the system was gradually increasing replicas of one ReplicaSet and decreasing the other. As a result, instead of having "big bang" deployment, the system was gradually replacing the old release with the new one, one replica at the time. That means that there was not a single moment without one or the other release available and, during a brief period, both were running in parallel.

You saw from the output of the loop that the messages switched from the old to the new release. In "real world" scenarios, you are likely going to have mixed outputs from both releases. For that reason, it is paramount that releases are backward compatible.

Let's take a database as an example. If we updated schema before initiating the deployment of the application, we could assume that for some time both releases would use the new schema. If the change is not backward compatible, we could end up in a situation where some requests fail because the old release running in parallel with the new is incapable of operating with the new schema. If that were to happen, the result would be similar as if we used the `Recreate` strategy. Some requests would fail. Or, even worse, everything might seem to be working correctly from the end-user point of view, but we would end up with inconsistent data. That could be even worse than downtime.

There are quite a few other things that could go wrong with `RollingUpdates`, but most of them can be resolved by answering positively to two crucial questions. Is our application scalable? Are our releases backward compatible? Without scaling (multiple replicas), `RollingUpdate` is impossible, and without backward compatibility, we can expect errors caused by serving requests through multiple versions of our software.


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## RollingUpdate Strategy

|Requirement        |Fulfilled|
|-------------------|----------|
|High-availability  |Fully     |
|Responsiveness     |Fully     |
|Progressive rollout|Partly    |
|Rollback           |Not       |
|Cost-effectiveness |Partly    |

Note:
So, what did we learn so far? Which requirements did we fulfill with the `RollingUpdate` strategy?

Our application was highly available at all times. By running multiple replicas, we are safe from downtime that could be caused by one or more of them failing. Similarly, by gradually rolling out new releases, we are avoiding downtime that we experienced with the `Recreate` strategy.

Even though we did not use HorizontalPodAutoscaler (HPA) in our example, we should add it our solution. With it, we can make our application scale up and down to meet the changes in traffic. The effect would be similar as if we'd use serverless deployments (e.g., with Knative). Still, since HPA does not scale to zero replicas, it would be even more responsive given that there would be no response delay while the system is going from nothing to something (from zero replicas to whatever is needed). On the other hand, this approach comes at a higher cost. We'd have to run at least one replica even if our application is receiving no traffic. Also, some might argue that setting up HPA might be more complicated given that Knative comes with some sensible scaling defaults. That might or might not be an issue, depending on the knowledge one has with deployments and Kubernetes in general. While with Knative HPA and quite a few other resources are implied, with Deployments and the `RollingUpdate` strategy, we do need to define it ourselves. We can say that Knative is more developer-friendly given its simpler syntax and that there is less need to change the defaults.

The only two requirements left to explore are progressive rollout and rollback.

Just as with serverless deployments, `RollingUpdate` kind of works. As you already saw, it does roll out replicas of the new release progressively, one or more at the time. However, the best we can do is make it stop the progress based on very limiting health checks. We can do much better on this front and later we'll see how.

Rollback feature does not exist with the `RollingUpdate` strategy. It can, however, stop rolling forward and that, in some cases, we might end up with only one non-functional replica of the new release. From the user's perspective, that might seem like only the old release is running. But there is no guarantee for such behavior given that in many occasions a problem might be detected after the second, third, or some other replica is rolled out. Automated rollbacks are the only requirement that wasn't fulfilled by any of the deployment strategies we employed so far. Bear in mind that, just as before, by automated rollback, I'm referring to what deployments offer us. I'm excluding situations in which you would do them inside your Jenkins X pipelines. Anything can be rolled back with a few tests and scripts executed if they fail, but that's not our current goal.

So, what did we conclude? Do rolling updates fulfill all our requirements? Just as with other deployment strategies, the answer is still "no". Still, `RollingUpdate` is much better than what we experienced with the `Recreate` strategy. Rolling updates provide **high-availability** and **responsiveness**. They are getting us **half-way towards progressive rollouts**, and they are **more or less cost-effective**. The major drawback is the **lack of automated rollbacks**.

The next in line is blue-green deployment.


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Blue-Green Strategy


<!-- .slide: data-background="img/blue-green.png" data-background-size="contain" -->

Note:
Blue-green deployment is probably the most commonly mentioned "modern" deployment strategy. It was made known by Martin Fowler.

The idea behind blue-green deployments is to run two production releases in parallel. If, for example, the current release is called "blue", the new one would be called "green", and vice versa. Assuming that the load balancer (LB) is currently pointing to the blue release, all we'd need to do to start redirecting users to the new one would be to change the LB to point to green.

We can describe the process through three different stages.

1. Let's say that, right now, all the requests are forwarded to the current release. Let's that that's the blue release with the version v2. We'll also imagine that the release before it is running as green and that the version is v1. The green release lays dormant, mostly wasting resources.
2. When we decide to deploy a new release, we do it by replacing the inactive (dormant) instances. In our case, that would be green instances which are currently running v1 and will be replaced with v3.
3. When all the green instances are running the new release, all that's left is to reconfigure the LB to forward all the requests to green instead of the blue instances. Now the blue release is dormant (unused) and will be the target of the next deployment.

![Figure 17-6: Blue-green deployment strategy](images/ch17/blue-green.png)

If we'd like to revert the release, all we'd have to do is change the LB to point from the active to the inactive set of instances. Or, to use different terminology, we switch it one color to another.

Blue-green deployments made a lot of sense before. If each of the replicas of our application were running in a separate VM, rolling updates would be much harder to accomplish. On top of that, rolling back (manual or automated) is indeed relatively easy with blue-green given that both releases are running in parallel. All we'd have to do is to reconfigure the LB to point to the old release.

However, we do not live in the past. We are not deploying binaries to VMs but containers to Kubernetes which schedules them inside virtual machines that constitute the cluster. Running any release is easy and fast. Rolling back containers is as easy as reconfiguring the LB.

When compared to the serverless deployments and the `RollingUpdate` strategy, blue-green does not bring anything new to the table. In all the cases, multiple replicas are running in parallel, even though that might not be that obvious with blue-green deployments.

People tend to think that switching from blue to green deployment is instant, but that is far from the truth. The moment we change the load balancer to point to the new release, both are being accessed by users, at least for a while. The requests initiated before the switch will continue being processed by the old release, and the new ones will be handled by the new. In that aspect, blue-green deployments are no different from the `RollingUpdate` strategy. The significant difference is in the cost.

Let's imagine that we have five replicas of our application. If we're using rolling updates, during the deployment process, we will have six, unless we configure it differently. A replica of the new release is created so we have six replicas. After that, a replica of the old release is destroyed, so we're back to five. And so on, the process keeps alternating between five and six replicas, until the whole new release is rolled out and the old one is destroyed. With blue-green deployments, the number of replicas is duplicated. If we keep with five replicas as the example, during the deployment process, we'd have ten (five of the old and five of the new). As you can imagine, the increase in resource consumption is much lower if we increase the number of replicas by one than if we double them. Now, you can say that the increase is not that big given that it lasts only for the duration of the deployment process, but that would not necessarily be true.

One of the cornerstones of blue-green strategy is the ability to roll back by reconfiguring the load balancer to point to the old release. For that, we need the old release to be always up-and-running, and thus have the whole infrastructure requirements doubled permanently. Now, I do not believe that's the reason good enough today. Replacing a container based on one image with a container based on another is almost instant. Instead of running two releases in parallel, we can just as easily and rapidly roll forward to the old release. Today, running two releases in parallel forever and ever is just a waste of resources for no good reason.

Such a waste of resources (for no good reason) is even more evident if we're dealing with a large scale. Imagine that your application requires hundreds of CPU and hundreds of gigabytes of memory. Do you want to double that knowing that rolling updates give you all the same benefits without such a high cost associated with it?

Frankly, I think that blue-green was a short blink in the history of deployments. They were instrumental, and they provided the base from which others like rolling updates and canaries were born. Both are much better implementations of the same objectives. 


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Canary Strategy

```bash
cd jx-canary

cat main.go | sed -e "s@example@canary@g" | tee main.go

git add . && git commit -m "Canary"

git push --set-upstream origin master

cd ..
```

Note:
Before we start exploring `Canary` deployments, let's take a quick look at what we have so far to confirm that the first release using the new definition worked.

To see `Canary` deployments in action, we'll create a trivial change in the demo application by replacing `example` in `main.go` to `canary!`. Then, we will commit and merge it to master to get a new version in the staging environment.


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Canary Strategy

* Go to the **second terminal**

```bash
CANARY_IP=$(kubectl --namespace istio-system \
    get service istio-ingressgateway \
    --output jsonpath='{.status.loadBalancer.ingress[0].ip}')

CANARY_ADDR=staging.jx-canary.$CANARY_IP.nip.io

while true; do
    curl "$CANARY_ADDR"
    sleep 0.5
done
```

* Go to the **first terminal**

Note:
As with the other deployment types, we initiated a loop that continuously sends requests to the application. That will allow us to see whether there is deployment-caused downtime. It will also provide us with the first insight into how canary deployments work.

Until the pipeline starts the deployment, all we're seeing is the `hello, rolling update!` message coming from the previous release. Once the first iteration of the rollout is finished, we should see both `hello, rolling update!` and `hello, progressive!` messages alternating. Since we specified that `stepWeight` is `20`, approximately twenty percent of the requests should go the new release while the rest will continue receiving the requests from the old. Thirty seconds later (the `interval` value), the balance should change. We should have reached the second iteration, with forty percent of requests coming from the new release and the rest from the old.

Based on what we can deduce so far, `Canary` deployments are behaving in a very similar way as `RollingUpdate`. The significant difference is that our rolling update examples did not specify any delay, so the process looked almost as if it was instant. If we did specify a delay in rolling updates and if we had five replicas, the output would be nearly the same.

As you might have guessed, we would not go into the trouble of setting up `Canary` deployments if their behavior is the same as with the `RollingUpdate` strategy. There's much more going on.


<!-- .slide: data-background="img/canary-rollout.png" data-background-size="contain" -->

Note:
When the deployment was initiated, Flagger detected that there is a new `revision` (a new release). As a result, it started scaling the application. A while later, it initiated the analysis that consists of evaluations of the metrics (`request-success-rate` and `request-duration`) against the thresholds we defined earlier. Further on, we can see that it was increasing the weight every thirty seconds until it reached `80` percent. That number is vital given that it is the first iteration with the `weight` equal to or above the `maxWeight` which we set to `70` percent. After that, it did not wait for another thirty seconds. Instead, it replaced the definition of the `primary` template to the one used for `canary`. From that moment on, the `primary` was updated to the new release and all the traffic is being routed to it. Finally, the last event was the message that the `promotion` was `completed` and that the `canary` (`jx-progressive.jx-staging`) was scaled down to zero replicas. The last two events happened at the same time, so in your case, their order might be reverted.

We finally found a big difference between `Canary` and `RollingUpdate` deployments. That difference was in the evaluation of the metrics as a way to decide whether to proceed or not with the rollout. Given that everything worked correctly. We are yet to see what would happen if one of the metrics reached the threshold.


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## To Canary Or Not To Canary?

|Requirement        |Fullfilled|
|-------------------|----------|
|High-availability  |Fully     |
|Responsiveness     |Fully     |
|Progressive rollout|Fully     |
|Rollback           |Fully     |
|Cost-effectiveness |Not       |

Note:
Canary deployments are, in a way, an extension of rolling updates. As such, all of the requirements fulfilled by one are fulfilled by the other.

The deployments we did using the canary strategy were highly available. The process itself could be qualified as rolling updates on steroids. New releases are initially being rolled out to a fraction of users and, over time, we were increasing the reach of the new release until all requests were going there. From that perspective, there was no substantial difference between rolling updates and canary releases. However, the process behind the scenes was different.

While rolling updates are increasing the number of Pods of the new release and decreasing those from the old, canaries are leaving the old release untouched. Instead, a new Pod (or a set of Pods) is spin up, and service mesh (e.g., Istio) is making sure to redirect some requests to the new and others to the old release. While rolling updates are becoming available to users by changing how many Pods of the new release are available, canaries are accomplishing the same result through networking. As such, canaries allow us to have much greater control over the process.

Given that with canary deployments we are in control over who sees what, we can fine-tune it to meet our needs better. We are less relying on chance and more on instructions we're giving to Flagger. That allows us to create more complicated calculations. For example, we could let only people from one country see the new release, check their reactions, and decide whether to proceed with the rollout to everyone else.

All in all, with canary deployments, we have as much high-availability as with rolling updates. Given that our applications are running in multiple replicas and that we can just as easily use HorizontalPodAutoscaler or any other Kubernetes resource type, canary deployments also make our applications as responsive as rolling updates.

Where canary deployments genuinely shine and make a huge difference is in the progressive rollout. While, as we already mentioned, rolling updates give us that feature as well, the additional control of the process makes canary deployments true progressive rollout.

On top of all that, canary deployments were the only ones that had a built-in mechanism to roll back. While we could extend our pipelines to run tests during and after the deployment and roll back if they fail, the synergy provided by canary deployments is genuinely stunning. The process itself decides whether to roll forward, to temporarily halt the process, or to roll back. Such tight integration provides benefits which would require considerable effort to implement with the other deployment strategies. I cannot say that only canary deployments allow us to roll back automatically. But, it is the only deployment strategy that we explored that has rollbacks integrated into the process. And that should come as no surprise given that canary deployments rely on using a defined set of rules to decide when to progress with rollouts. It would be strange if the opposite is true. If a machine can decide when to move forward, it can just as well decide when to move back.

Judging by our requirements, the only area where the `Canary` deployment strategy is not as good or better than any other is cost-effectiveness. If we want to save on resources, serverless deployments are in most cases the best option. Even rolling updates are cheaper than canaries. With rolling updates, we replace one Pod at the time (unless we specify differently). However, with `Canary` deployments, we keep running the full old release throughout the whole process, and add the new one in parallel. In that aspect, canaries are similar to blue-green deployments, except that we do not need to duplicate everything. Running a fraction (e.g., one) of the Pods with the new release should be enough.

All in all, canaries are expensive or, at least, more expensive than other strategies, excluding blue-green that we already discarded.

All in all, canary deployments, at least the version we used, provide **high-availability**. They are **responsive**, and they give us **progressive rollout** and **automatic rollbacks**. The major downside is that they are **not** as **cost-effective** as some other deployment strategies.


## Which Should We Choose?

Note:
We saw some of the deployment strategies.

Can we conclude that canary deployments are the best and that everyone should use them for all their applications? Certainly not. To begin with, if an application is not eligible for rolling updates (e.g., a single replica app), it is almost certainly not suitable for canary deployments. If we think of canaries as extensions of rolling updates, if an app is not a good candidate for the latter, it will also not be fit for the former. In other words, there is a good use case for using the `Recreate` strategy in some cases, specifically for those applications that cannot (or shouldn't) use one of the other strategies.

So, if both `Canary` and `Recreate` strategies have their use cases, can we discard rolling updates and serverless?

Rolling updates should, in most cases, we replaced with canary deployments. The applications eligible for one deployment strategy qualify for the other, and canaries provide so much more. If nothing else, they give us a bigger safety net. The exceptions would be tiny clusters serving small teams. In those cases, the resource overhead added by a service mesh (e.g., Istio) and metrics collector and database (e.g., Prometheus) might be too much. Another advantage of rolling updates is simplicity. There are no additional components to install and manage, and there are no additional YAML files. Long story short, canary deployments could easily replace all your rolling updates, as long as the cost (on resources and operations) is not too high for your use case.

That leaves us with serverless (e.g., Knative). It would be hard for me to find a situation in which there is no use for serverless deployments. It has fantastic scaling capabilities on its own that can be combined with HorizontalPodAutoscaler. It saves us money by shutting (almost) everything down when our applications are not in use.

Knative ticks all the boxes, and the only downside is the deployment process itself, which is more elaborated with canaries. The more important potential drawback is that scaling from nothing to something can introduce a delay from the user's perspective. Nevertheless, that is rarely a problem. If an application is unused for an extended period, users rarely complain when they need to wait for an additional few seconds for the app to wake up.

So, we are in a situation where one solution (`Canary`) provides better capabilities for the deployment process itself, while the other (serverless) might be a better choice as a model for running applications. Ultimately, you'll need to make a choice. What matters more? Is it operational cost (use serverless) or deployment safety net (use canary)? You might be able to combine the two but, at the time of this writing (August 2019), that is not that easy since the integration is not available in Flagger or other similar tools.

What is essential, though, is that it is not the winner-takes-all type of a decision. We can use `Recreate` with some applications, `RollingUpdate` with others, and so on. But it goes beyond choosing a single deployment strategy for a single application. Deployment types can differ from one environment to the other. Canaries, for example, are not a good choice for preview environments. All we'd get is increased time required to terminate the deployment process and potential failures due to the lack of metrics.

Let's make a quick set of rules when to use one deployment strategy over the other. Bear in mind that what follows is not a comprehensive list but rather elevator pitch for each deployment type.


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Which Should We Choose?

### Recreate

When working with legacy applications that often do not scale, that are stateful without replication, and are lacking other features that make them not cloud-native.

Note:
Use the **recreate** strategy when working with legacy applications that often do not scale, that are stateful without replication, and are lacking other features that make them not cloud-native.


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Which Should We Choose?

### Rolling update

With cloud-native applications which, for one reason or another, cannot use canary deployments.

Note:
Use the **rolling update** strategy with cloud-native applications which, for one reason or another, cannot use canary deployments.


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Which Should We Choose?

### Canary

Instead of **rolling update** when you need the additional control when to roll forward and when to roll back.

Note:
Use the **canary** strategy instead of **rolling update** when you need the additional control when to roll forward and when to roll back.


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Which Should We Choose?

### Serverless

In permanent environments when you need excellent scaling capabilities or when an application is not in constant use.

For all the deployments to preview environments, no matter which strategy you're using in staging and production.

Note:
Use **serverless** deployments in permanent environments when you need excellent scaling capabilities or when an application is not in constant use.

Finally, use **serverless** for all the deployments to preview environments, no matter which strategy you're using in staging and production.
