<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.9), rgba(87,185,72,0.9)), url(../img/background/why.jpg) center / cover" -->
<!-- .slide: class="center" -->
# Destruction?

### There are very few things as satisfying as destruction<!-- .element: class="fragment" -->
### ...especially when we're frustrated.<!-- .element: class="fragment" -->

Note:
How often did it happen that you have an issue that you cannot solve and that you just want to scream or destroy things? Did you ever have a problem in production that is negatively affecting a lot of users? Were you under a lot of pressure to solve it, but you could not "crack" it as fast as you should. It must have happened, at least once, that you wanted to take a hammer and destroy servers in your datacenter. If something like that never happened to you, then you were probably never in a position under a lot of pressure. In my case, there were countless times when I wanted to destroy things. But I didn't, for quite a few reasons. Destruction rarely solves problems, and it usually leads to negative consequences. I cannot just go and destroy a server and expect that I will not be punished. I cannot hope to be rewarded for such behavior.

What would you say if I tell you that we can be rewarded for destruction and that we can do a lot of good things by destroying stuff? If you don't believe me, you will soon. That's what chaos engineering is about. It is about destroying, obstructing, and delaying things in our servers and in our clusters. And we're doing all that, and many other things, for a very positive outcome.

Chaos engineering tries to find the limits of our system. It helps us deduce what are the consequences when bad things happen. We are trying to simulate the adverse effects in a controlled way. We are trying to do that as a way to improve our systems to make them more resilient and capable of recuperating and resisting harmful and unpredictable events.

That's our mission. We will try to find ways how we can improve our systems based on the knowledge that we will obtain through the chaos.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.9), rgba(87,185,72,0.9)), url(../img/background/why.jpg) center / cover" -->
<!-- .slide: class="center" -->
# Principles Of Chaos Engineering

### A discipline of experimenting on a system to build confidence in the system's capability to withstand turbulent conditions in production<!-- .element: class="fragment" -->
## Be prepared, bad things will happen!!!<!-- .element: class="fragment" -->

Note:
What is chaos engineering? What are the principles behind it?

**We can describe chaos engineering as a discipline of experimenting on a system to build confidence in the system's capability to withstand turbulent conditions in production.** Now, if that was too confusing and you prefer a more straightforward definition of what chaos engineering is, I can describe it by saying that you should **be prepared because bad things will happen**. It is inevitable. Bad things will happen, often when we don't expect them. Instead of being reactive and waiting for unexpected outages and delays, we employ chaos engineering and try to simulate adverse effects that might occur in our system. Through those simulations, we learn what the outcomes of those experiments are and how we can improve our system by building confidence by making it resilient and by trying to design it in a way that it is capable of withstanding unfavorable conditions happening in production.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.9), rgba(87,185,72,0.9)), url(../img/background/why.jpg) center / cover" -->
<!-- .slide: class="center" -->
# Are You Ready For Chaos?

Note:
Before we proceed, I must give you a warning. **You might not be ready for chaos engineering.** You might not benefit form it. You might not want to do it.

When can you consider yourself as being ready for chaos engineering? Chaos engineering requires teams to be very mature and advanced. Also, if you're going to practice chaos engineering, be prepared to do it in production. We don't want to see how, for example, a staging cluster behaves when unexpected things happen. Even if we do, that would be only a practice. "Real" chaos experiments are executed in production because we want to see how the real system used by real users is reacting when bad things happen.

Further on, you, as a company, must be prepared to have sufficient budget to invest in real reliability work. It will not come for free. There will be a cost for doing chaos engineering. You need to invest time in learning tools. You need to learn processes and practices. And you will need to pay for the damage that you will do to your system.

Now, you might say that you can get the budget and that you can do it in production, but there's more. There is an even bigger obstacle that you might face.

You must have enough observability in your system. You need to have a relatively advanced monitoring and alerting processes and tools so that you can detect harmful effects of chaos experiments. If your monitoring setup is non-existent or not reliable, then you will be doing damage to production without being able to identify the consequences. Without knowing what went wrong, you won't be able to (easily) restore the system to the desired state.

On the other hand, you might want to jump into chaos engineering as a way to justify investment in reliability work and in observability tools. If that's the case, you might want to employ the chaos engineering practices as a way to show your management that reliability investment is significant and that being capable of observing the system is a good thing.

So you can look at it from both directions. In any case, I'm warning you that this might not be for you. You might not be in the correct state. Your organization might not be mature enough to be able to practice chaos engineering.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.9), rgba(87,185,72,0.9)), url(../img/background/why.jpg) center / cover" -->
<!-- .slide: class="center" -->
# Examples Of Chaos Engineering

## Improper fallback settings<!-- .element: class="fragment" -->
## Service NOT available<!-- .element: class="fragment" -->
## Retrying indefinitely to reach a service<!-- .element: class="fragment" -->
## Too much traffic or inavailability<!-- .element: class="fragment" -->
## ...<!-- .element: class="fragment" -->

Note:
Right now, you might be saying, "okay, I understand that chaos engineering is about learning from the destruction, but what does it really mean?" Let me give you a couple of use-cases. I cannot go through all the permutations of everything we could do, but a couple of examples might be in order. 

We can validate what happens if you have **improper fallback settings** when a service is unavailable. What happens when a **service is not accessible**, one way or another. Or, for example, what happens if an app is **retrying indefinitely to reach a service** without having properly tuned timeouts? What is the result of **outages when an application or a downstream dependency receives too much traffic or when it is not available**? Would we experience cascading errors when a single point of failure crashes an app? What happens when our application goes down? What happens when there is something wrong with networking? What happens when a node is not available?

With the examples out of the way, we can talk about the principles of chaos engineering.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.9), rgba(87,185,72,0.9)), url(../img/background/why.jpg) center / cover" -->
<!-- .slide: class="center" -->
# The Principles

## Build a hypothesis around steady-state<!-- .element: class="fragment" -->
## Simulate real-world events<!-- .element: class="fragment" -->
## Run experiments in production<!-- .element: class="fragment" -->
## Automate experiments and run them continuously<!-- .element: class="fragment" -->
## Minimize blast radius<!-- .element: class="fragment" -->

Note:
What we usually want to do is build a hypothesis around the steady-state behavior. What that means is that we want to define how our system, or a part of it, looks like. Then, we want to perform some potentially damaging actions on the network, on the applications, on the nodes, or on any other component of the system. Those actions are, most of the time, very destructive. We want to create violent situations that will confirm that our state, the steady-state hypothesis, still holds. In other words, we want to validate that our system is in a specific state, perform some actions, and finish with the same validation to confirm that the state of our system did not change.

We want to try to do chaos engineering based on real-world events. It would be pointless to try to do things that are not likely to happen. Instead, we want to focus on replicating the events that are likely going to happen in our system. Our applications will go down, our networking will be disrupted, and our nodes will not be fully available all the time. Those are some of the things that do happen, and we want to check how our system behaves in those situations.

We want to run chaos experiments in production. As I mentioned before, we could do it in a non-production system. But that would be mostly for practice and for gaining confidence in chaos experiments. We want to do it in production because that's the "real" system. That's the system at its best, and our real users are interacting with it. If we'd just do it staging or in integration, we would not get a real picture of how the system in production behaves.

We want to automate our experiments to run continuously. It would be pointless to run an experiment only once. We could never be sure what the right moment is. When is the system in conditions under which it would produce some negative effect? We should run the experiments continuously. That can be every hour, every day, every week, every few hours, or every time some event is happening in our cluster. Maybe we want to run experiments every time we deploy a new release or every time we upgrade the cluster. In other words, experiments are either scheduled to run periodically, or they are executed as part of continuous delivery pipelines.

Finally, we want to reduce the blast radius. In the beginning, we want to start small and to have a relatively small blast radius of the things that might explode. And then, over time, as we are increasing confidence in our work, we might be expanding that radius. Eventually, we might reach the level when we're doing experiments across the whole system, but that comes later. In the beginning, we want to start small. We want to be tiny.

The summary of the principles we discussed is as follows.

* **Build a hypothesis around steady-state**
* **Simulate real-world events**
* **Run experiments in production**
* **Automate experiments and run them continuously**
* **Minimize blast radius**

Now that it is a bit clearer what chaos engineering is and what are the principles behind it, we can turn our attention towards the process. It is repetitive.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.9), rgba(87,185,72,0.9)), url(../img/background/why.jpg) center / cover" -->
<!-- .slide: class="center" -->
# The Process

## 1. Define the steady-state hypothesis<!-- .element: class="fragment" -->
## 2. Confirm the steady-state<!-- .element: class="fragment" -->
## 3. Produce or simulate "real world" events<!-- .element: class="fragment" -->
## 4. Confirm the steady-state<!-- .element: class="fragment" -->
## 5. Use metrics, dashboards, and alerts to confirm that the system as a whole is behaving correctly<!-- .element: class="fragment" -->

Note:
To begin with, we want to define a steady-state hypothesis. We want to know how does the system look like before and after some actions. We want to confirm the steady-state, and then we want to simulate some real-world events. And after those events, we want to confirm the steady-state again. We also want to collect metrics, to observe dashboards, and to have alerts that will notify us when our system misbehaves. In other words, we're trying very hard to disrupt the steady-state. The less damage we're able to do, the more confidence we will have in our system.

The summary of the process we discussed is as follows.

1. **Define the steady-state hypothesis**
2. **Confirm the steady-state**
3. **Produce or simulate "real world" events**
4. **Confirm the steady-state**
5. **Use metrics, dashboards, and alerts to confirm that the system as a whole is behaving correctly.**
