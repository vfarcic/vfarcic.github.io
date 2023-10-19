<!-- .slide: data-background-image="img/wrong.jpg" data-background-size="cover" data-background-color="black" -->

Note:
Today I am going to offend many of you by saying that the way you run pipelines or, what many call, CI/CD is wrong.
There you go.
I said it.
You're doing it wrong, in big part because the tools you're using are wrong or, to be more precise, are not equipped to do what we need them to do today.


<!-- .slide: data-background-image="img/past.jpg" data-background-size="cover" data-background-color="black" -->

Note:
Pipelines are still locked in the past, in the days of monoliths and slow releases and were designed to be working well in relatively small systems or with a relatively small number of applications.
They're wrong.
You're doing it wrong.
Let's correct that.
...and...
To explain why I believe it's all wrong, we need to start from the begining and explore Software Development Life Cycle, or SDLC for short.


<!-- .slide: data-background-image="img/maze.jpg" data-background-size="cover" data-background-color="black" data-background-opacity="0.3" -->
## What Is
# Software Development
# Life Cycle?

Note:
Software Development Life Cycle is a process that performs all the actions required deliver a new release of an application from the beginning, the idea, to the end, to production.
The begining of a cycle starts with the code, and the end ... well, there is no end or, to be more precise, the end happens when a new release is deployed to production.
What does that mean?


<!-- .slide: data-background-image="img/sdlc-01-01.jpg" data-background-size="contain" data-background-color="black" -->

Note:
We write code and, once we're done, we push it to Git.
Quite a few other things are actually happening before we
  push a change to Git but, for the sake of simplicity,
  I will ignore those and focus on the push to the mainline.
I will also ignore the fact that many have intermediary
  changes to Git before the code is ready to become a candidate
  for a release.
Once we push a release candidate to Git, an event is created.
More often than not, that even results in a webhook being
  triggered towards your pipeline of choice.
That could be Jenkins, GitHub Actions, Argo Workflows, or
  whatever else you might be using.
Which pipeline you're using is not important since most of
  them are the same.
They are all designed as a way to execute a series of actions
  that will, ultimately, lead to a new release being deployed
  to production.
They are all based on principles from decades ago, which is
  probably why they are all, more or less, the same.
Anyways...
The pipeline will checkout the code, run unit tests, build
  binaries and container images, push those to a registry,
  and run security scanning.
At one moment, the pipeline will deploy the new release to
  one or more clusters and run functional, integration, or
  any other type of tests that require the application to
  be up-and-running.
Finally, once it's running in production, we will be observing
  it's behavior, both in isolation and as a part of the 
  system.
Now, I know that this is the moment when you start yelling at
  me saying that I am wrong.
Your pipelines are not like that.
You might be making a pull request before merging to mainline.
You might be deploying to staging before moving to production.
You might be performing steps in a different order.
You might have steps I did not mention.
I get it.
Your pipelines are different than what I drew.
That's OK.
That does not change the story since I am not trying to
  depict everything that needs to be done as part of an
  application lifecycle.
That would be foolish of me since the exact steps might
  vary greatly from one organization to another or even
  from one application to another.
The point I'm trying to make is that SDLC is a process that
  involves a number of steps.
A more important point I will try to make is that some steps
  are very different in nature than others.
Some are one-shot tasks, while others are continuous loops.


<!-- .slide: data-background-image="img/sdlc-01-02.jpg" data-background-size="contain" data-background-color="black" -->

Note:
One-shot actions are those that should be executed once and
  only once for any give commit.
We push a single commit only once to Git.
A pipeline build is executed only once for any given commit.
The exception would be flaky tests that return false positives
  and you mitigating your inability to write reliable tests
  by re-running pipeline builds.
If you ignore those cases which, frankly, should not exist,
  you'll come to the conclusion that a pipeline build coming
  from a single commit is executed only once.
We checkout the code once and we run unit tests only once.
What would be the point of running unit tests based on the same
  code more than once?
If you don't think that's the case, I'll have to quote Albert
  Einstain by saying that "the definition of insanity is doing
  the same thing over and over again, but expecting different
  results."
We also build binaries and container images only once.
We push them to a registry... only once.
We run functional and other types of tests only once.
That is what pipeline builds do well, more or less.
The allow us to specify which actions should be executed as
  a result of triggering a build, typically through a Git
  webhook.
Now, you'll notice that I skipped some of the steps while I
  was going through my "only once" rumbling.
That's because not all steps are executed only once.
Not all of them are one-shot actions.
Some of them should be continuous.


<!-- .slide: data-background-image="img/sdlc-01-03.jpg" data-background-size="contain" data-background-color="black" -->

Note:
Traditionally, we would scan artifacts before releasing them
  to production.
We would establish gates like, for example, "no high severity
  vulnerabilities are allowed in production."
If the scan results do not show any vulnerabilities that pass
  the threshold, we would consider it safe to release the
  application to production.
Now, that makes perfect sense, but only as the first iteration.
You see, the list of vulnerabilities is not static.
We discover new vulnerabilities every day and the fact that
  something is considered safe right now does not mean that it
  will be safe tomorrow.
What that means is that we need to be scanning releases
  continuously.
Now, since scanning past releases that are not used in
  production any more is a waste, we should be continuously
  scanning only those that are actually running in production.
That means that we need a process that will continuously or,
  to be more precise, periodically scan our applications in
  production.
Hence, even though we can scan stuff through pipeline builds,
  we cannot rely on that action to happen only once.
It needs to be continuous.
Further on, we have deployments.
We learned that deploying stuff by SSHing into servers or by
  executing `docker run` or `kubectl apply` commands is not
  enough nor, even, desirable.
Today we need a place where the desired state is stored, we
  might not want to allow direct access to the cluster even to
  pipelines, we might want to have a mechanism that will ensure
  that the actual and the desired state are always in sync, and
  so on and so forth.
The important part for this story is the part about continuous
  synchonization.
It's not enough to say "I want production to be like this right
  now," but "I want production to be like this forever and ever
  or until I change my mind."
That's what we call GitOps today.
It is a process that, among other things, continuously monitors
  the desired state stored in Git and ensures that the actual
  state is always in sync with it.
In other words, we cannot or, to be more precise, we shouldn't
  rely on one-shot actions to deploy stuff to production.
Finally, there is observability.
Even if you dissagree on deployments and security scanning
  being continuous, noone will dissagree that observability
  can be one-shot.
It's not enough to ensure that production works correctly only
  at the time we finish running pipeline builds, but all the
  time.
Morning, afternoon, or night.
Weekdays, or weekends.
It does not matter when.
What matters is that production should be working correctly
  all the time, and that means that observability must be
  continuous.
All that, and many other examples, lead to the conclusion that
  we cannot rely on one-shot actions to perform all the steps
  required to deliver a new release to production.
We need a combination of one-shot and continuous actions, and
  that is at odds with pipelines which are designed to perform
  one-shot actions only.
As a result, we started removing steps from pipelines.


<!-- .slide: data-background-image="img/sdlc-01-04.jpg" data-background-size="contain" data-background-color="black" -->

Note:
For some, the first step removed from a pipeline is Deployment.
That's the natural outcome of adopting GitOps.
Instead of deploying directly from pipeline builds, we would
  push chages to a repo that contains the desired state and
  let a process inside the cluster to pull the state from
  the Git repo and reconcile it with the actual state.
That process of pulling, looking for drifts, and reconciliation
  is continuous.
Tools like Argo CD or Flux do not care about pipeline builds
  nor anything else.
All they care is the desired state in a Git repo.
How we get to change that state is of no concern to GitOps
  tools.
That's the type of decoupling we normally see in microservices,
  when done right and not as distributed monoliths.
Just as one microservice does not care much of the details of
  another, GitOps part of the process does not care for the
  parts that might come before or after it.
Introduction of GitOps tools like Argo CD or Flux breaks
  pipelines.
Since it's asynchronous, the steps executed before it cannot
  wait for the steps executed after it and that means that,
  in our example, we cannot continue the pipeline from the
  scanning to the testing phase.
That means that we need to split pipeline into two and, even if
  we do that, we need something to trigger the second one, the
  one that starts with test.
We need an event other than the one made by pushing code to a
  Git repo.
That event must come from the cluster whether the app was
  applied.
It must be a process that monitors the state of the app,
  detects a new release, wait until it is fully operational,
  and trigger an event.
If that app is running in or managed by a Kubernetes, the event
  triggering is easy.
Kubernetes creates those events anyways, and all we need is a 
  tool that will subscribe to them, and initiate a pipeline
   build when certain conditions are met.
I tend to use Argo Workflows for that, but any other similar
  tool should do.
Now, you might say "okay, that means that we need two
  pipelines."
Right?
Well, we might end up with many more.
We might convert pipelines from monoliths into microservices.


<!-- .slide: data-background-image="img/sdlc-01-05.jpg" data-background-size="contain" data-background-color="black" -->

Note:
We'll get to that later.
For now, let's move to the second one-shot step that should be
  continuous.
As we already discussed, scanning should be continuous.
It should start before the deployment of the release, and
  continue for as long as it is running.
That means that an event should trigger scanning the moment
  the artifact is pushed to a registry, and, from there on,
  trigger periodically from the cluster where the app is
  running.
The first trigger should prevent the app from being released,
  while the others should notify us if a new threat is
  detected and affects the artifact running in production.
Observability is the last task, in our example, that moves
  from being one-shot to continuous.
As a matter of fact, that might have been the first one you
  already moved to be continuous.
In any case, the observability stores need to pull data from
  the cluster, or sometimes other tools might push the data.
In any case, that pulling (or pushing) is continous just as
  alreats and other actions based on observability data are
  being executed.
All in all, our pipeline is broken into two pipelines and a few
  tasks executed as a result of different events happening in
  the system.
My drawings excluded quite a few other tasks that we might or
  might not need to perform so the number of tasks can be quite
  larger (or smaller).
That means that we are moving from monolithic pipelines into
  microservice-like architecture for the SDLC.
What does that mean?


<!-- .slide: data-background-image="img/sdlc-02-01.jpg" data-background-size="contain" data-background-color="black" -->

Note:
Most of us, right now, define pipelines as a set of
  interconnected tasks.
Task one leads to task two which leads to task three which
  leads to...
You get the point.
That poses a lot of problems which are similar ones we were
  facing with monolithic applications.
They are too big, too fragile, do not scale well, and, perhaps
  most importantly, complicate collaboration.
I'll get to collaboration later.
So, how do we make pipelines more service-like architecture?


<!-- .slide: data-background-image="img/sdlc-02-02.jpg" data-background-size="contain" data-background-color="black" -->

Note:
Well, spit tasks into independently deployable entities.
Some might still be connected directly, but many do not.
They can live their own lives oblivious of the rest of the
  tasks.
Yet, we still need some kind of an orchestration.
For example, we cannot deploy artifacts before they are built.


<!-- .slide: data-background-image="img/sdlc-02-03.jpg" data-background-size="contain" data-background-color="black" -->

Note:
That's where events come in.
Tasks can be triggered by events like, for example, webhooks
  triggered by Git commits, or they can listen for events like,
  for example, those coming from Kubernetes when a Deployment
  is rolled out.
So, one task is executed as a reaction to an event and, when
  finished will produce a new event saying "I'm done. I don't
  know or care who needs this information, but I'm done."


<!-- .slide: data-background-image="img/sdlc-02-04.jpg" data-background-size="contain" data-background-color="black" -->

Note:
A different task or a group of tasks will be executed as a
  reaction to that new event, and they will produce events on
  their own.


<!-- .slide: data-background-image="img/sdlc-02-05.jpg" data-background-size="contain" data-background-color="black" -->

Note:
... and so on and so forth.
It's a distributed, decoupled, event-based architecture that
  works for almost any type of services, including pipelines.
Monolithic pipelines served us well, but now is time to switch
  to an architecture more in line with today's needs.
However, there is one big thing missing.


<!-- .slide: data-background-image="img/tracking.jpg" data-background-size="cover" data-background-color="black" data-background-opacity="0.3" -->
# Tracing?

Note:
The problem with event-based distributed services is tracking.
That problem is equally present no matter whether those
  services are applications or tasks of what we had previously
  as pipelines.
The system works as expected, but we do not know what is
  happening.
We can easily see the state of each individual service or, in
  our case, task, but we cannot easily connect the docs.
We cannot see the order in which tasks were executed.
We cannot see the graph.
That's easy to do in pipelines, but much harder with
  individually deployed and running tasks.


<!-- .slide: data-background-image="img/sdlc-03-01.jpg" data-background-size="contain" data-background-color="black" -->

Note:
Let's say that we have six tasks.
Then, as a result of an event, task 1 was executed.
From there, task five was executed as the result of the
  completion of task one, from there on task three was run,
  followed by tasks four and six.
In this example, the conditions were not right for the task
  two to be executed.
In some other situation, the list of tasks that were executed
  and the order in which they were executed might be different.


<!-- .slide: data-background-image="img/sdlc-03-02.jpg" data-background-size="contain" data-background-color="black" -->

Note:
How do we construct the image, the graph and connect the dots
  between those executions.
If those would be microservices, the answer would be simple.
We need tracing that would inject a unique ID at the start
  of the journey, and propagate that same ID through all the
  services involved in it.
Further on, we would visualize journeys of each request thorugh
  Jaeger or some other tracing tool.
We do not have, as far as I know, something similar for tasks
  that were previously part of pipelines.
We could, easily, create those tasks with, let's say, Argo
  Workflows and we could just as easily create events that
  trigger those tasks with Argo Events.
But, we'd still lack that unique ID that would allow us to
  connect the dots and visualize the journey of a all the tasks
  that belong to the same build.
We could, ofcourse, do a custom solution but that would be a
  waste of time and effort.
So, here's my request to the vendors behind pipeline solutions.
Drop your legacy monolithic pipelines and start building
  tracing-like solution.
We already have ways to run tasks, and to trigger execution of
  those tasks as a result of specific events.
What we're lacking is tracing and visualization of the journey
  of a single build.
Whomever builds a solution like that or let me know that it
  already exists, will get a big thank you from me.
I can live without it, as I already do so that's not a must but
  rather, a nice-to-have missing piece.


<!-- .slide: data-background-image="img/stop.jpg" data-background-size="cover" data-background-color="black" -->

Note:
Now, you might say "that's a no-go for me", but you would be
  wrong.
You're probably already using this model.
If you're using GitOps tools like Argo CD of Flux, they do
  not care what pushed changes to the repos they're monitoring
  nor they care what happens after the synchronization happens.
If you're scanning container images automatically when they
  are pushed to a container registry and that scanning is
  independent of the processes that lead to the image being
  pushed to the registry.
And so on and so forth.
The point I'm trying to make is that we are inevitably moving
  towards running tasks independently of each others and
  connecting them through events.
That's why I said that I or, to be more precise, we can live
  without tracing-like solution since we obviously already do.
Still, dear vendors, build one for us.
The last subject I want to explore is collaboration, as,
  potentially, the main reason behind the approach I'm
  advocating today.


<!-- .slide: data-background-image="img/teams.jpg" data-background-size="cover" data-background-color="black" -->

Note:
Once we adopt event-based flow of task executions, we can
  easily start working on specific tasks independently of
  the others, just as we can work on a microservice without
  worrying about microservices developed by others.


<!-- .slide: data-background-image="img/sdlc-04-01.jpg" data-background-size="contain" data-background-color="black" -->

Note:
For example, if you are a security expert...


<!-- .slide: data-background-image="img/sdlc-04-02.jpg" data-background-size="contain" data-background-color="black" -->

Note:
... you can configure
  your registry to scan every single image that comes into it,
  and you can choose which ones will be rejected based on the
  threshold you set.
You do not need to care who or what pushes images to the
  registry.
You do not need to ensure that pipelines are always executed
  with scanning nor that people are prevented from bypassing
  security scanning.
You do not need to care about any of that.
What you do care is that every image is scanned and the most
  logical place to ensure that is not in pipelines, peoples
  laptops, or anywhere else, but in the registry itself.
So, you can set up scanning to be a reaction to an event,
  and that event, among others, can be a push of a new image
  to the registry.


<!-- .slide: data-background-image="img/sdlc-04-03.jpg" data-background-size="contain" data-background-color="black" -->

Note:
If you are a Kubernetes expert, you job can be to setup a
  GitOps solution in the cluster and let it monitor a specific
  Git repository.
You don't have to care how the change comes to that repo.
It should not matter whether a pipeline made a commit,
  or if a member of an application team pushed a change
  directly, or any other of the myriad of ways a change to
  the repo might happen.
What you care is that a GitOps tool reacts to the event of
  a change being pushed to a Git repo.


<!-- .slide: data-background-image="img/sdlc-04-04.jpg" data-background-size="contain" data-background-color="black" -->

Note:
Or you might be an application developer that, one way or
  another builds a container image and pushes it to a registry.
You don't have to care what happens after the push.
You might not even be aware that there is a thing called
  security scanning, at least until you get notified that a
  vulnerability was detected in your image.
You don't have to care how that image will be propagated to
  the cluster.


<!-- .slide: data-background-image="img/sdlc-04-05.jpg" data-background-size="contain" data-background-color="black" -->

Note:
Yet, when we connect those three isolated sets of tasks, we
  get a flow.
An image was pushed to a registry, that triggered security
  scanning and, if it passed the thresholds, the image was
  applied to the cluster.
We have separate tasks performed independently of each other,
  yet the flow is there.
The SDLC is there.
