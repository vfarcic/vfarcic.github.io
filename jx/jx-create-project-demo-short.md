<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Creating A Quickstart Project

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Project

```bash
jx create quickstart --filter golang-http --project-name jx-go --name jx-go

export GH_USER=[...] # Replace with your GitHub user

open "https://github.com/$GH_USER/jx-go"

ls -l jx-go

cat jx-go/Dockerfile

cat jx-go/jenkins-x.yml
```

Note:
That was already more talk than I'm comfortable with, so let's switch gears and do a demo.

The best place to start a story is the begining. What do we do if we want to start working on a new project? In the Jenkins X world, we create a quickstart.

I prefer using Go, so I will create a new project based on it, and I will call it `jx-go`. Next, I am asked a few simple questions. What is my Git username? Who is the owner of the repository? Would I like to initialize Git? What is the commit message? Anyone can answer those questions. They are not important by themselves. The importance is in the outcome of those answers. They provided just enough information to Jenkins X to assemble everything we will need for a full lifecycle of our newly created application.

Our code and all the application-specific configurations should be stored in Git. So, Jenkins X created a new repository for us. We can confirm that by opening the newly created GitHub repo.

As you can see, a lot of files were created only a minute ago. I'll skip explaining what those files are from this view, and get back to the terminal.

What did we get?

We need to build container images, so there is Dockerfile. But that does not mean that we are building images with Docker. That would be a very bad idea since that would expose the whole cluster and could prevent Kubernetes from operating properly. Instead, we are building images with Kaniko. But you do not have to know that. For you, as a user, the important thing to understand is that container images will be built according to best practices of the industry. Digging deeper is optional, not mandatory.

We also need a pipeline that defines all the steps of the lifecycle of that application. So, let's take a look at it.

That is probably the shortest pipeline you every saw. Yet, that single line defines everything our Go application needs. It build binaries, it runs tests, it packages the application, it makes releases, it deploys to temporary or permanent environments, and so on and so forth. That single line is a reference to a common pipeline used by others who are working with Go. You can extend it as much as you need, while stil leveraging the common steps defined somewhere else.


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Project

```bash
cat jx-go/Makefile

cat jx-go/skaffold.yaml

ls -l jx-go/charts

ls -l jx-go/charts/jx-go

ls -l jx-go/charts/preview

open "https://github.com/$GH_USER/jx-go/settings/hooks"
```

Note:
Since we mentioned that the pipeline performs many different steps, we need to define targets that it can execute. We need to do that in a way that they can be run not only from a pipeline inside the cluster, but also locally from a laptop while developing. So, we need a configuration file with all the targets written in whichever tool is native to a specific programming language. Since we choose Go, that tool is Makefile. If, for example, we choose Java, that could be Maven or Gradle.

We also might need different profiles given that the way we will build and deploy the application locally might differ from the way we are deploying it in a developement environment which might still be different from staging and production. There is a tool for that as well, and it's called Skaffold, and Jenkins X already created a config file for it as well.

Further on, we need to have some form of templates that will be converted into Kubernetes-friendly packages. We can use Helm for that, and Jenkins X already created charts. Seployments to permanent environments might be different from temporary environments like those spin up as a result of creating pull requests. So, we go two charts. One for permanent environments, and the other for temporary ones.

What matters is that none of those tools are proprietary of created by the Jenkins X community. The only exception is the pipeline. Everything else is a collection of best of breed tools that serve a single process focused towards GitOps. We can call it codification of good practices, given that I think that the phrase "best practice" is missleading. Those practices can and will change over time. As they change, Jenkins X will be changing as well, and you can rest assured that your project is following them, unless you opt out.

Now, since I mentioned GitOps, at least once, you might expect me to define it. But I will not do that. I will assume that you already know what it is. I will just say that it is a process that assumes that Git is the only source of truth and that any change of the actual state of the cluster needs to be preceeded by a change of the desired state in a Git repository. Your job is to make changes to the code and push them to Git, and it the job of the machines to converge the actual into the desired state. Everything is code. Code is stored in Git. You push code, and you let machines do the rest. You get traceability of everything you do and, at the same time, you are free from wasting your time on repetitive tasks.

The key ingredient in all that are Git webhooks. It needs to notify the cluster that you changed something in some Git repository. So, Jenkins X created that as well.

Everything we need for any steps in the lifecycle of our newly created application is there, waiting for us to start development.

Now, the real question is how much time it would take you to do all that? How much time you would need to figure out which tool to use to build container image? How about the tools for building, testing, deploying, and so on and so forth? There are thousands to choose from, and the first one you stumble upon, or the one you're already used to might not be a good choice. Maybe it was before, but it might not be today. Once you figure out all the tools you need, you would still need to learn their syntaxes, write a bunch of configuration files and code, and do a few other random things. That can take anything from days to years. And once you're done with all that, you would still need to create a service that everyone can consume, unless you expect everyone else in your company to go through the selection process and a potentially steep learning curve.

In my case, it took a couple of years to get to this spot, together with a combined effort of a large community. And now that is available to everyone. All you have to is execute `jx create quickstart`, and wait for a few seconds. That's it. You can benefit almost instantly from years of effort of a large community aimed towards defining the process that works and picking the right tools to support it.

But there's more to it then creating of a bunch of files that define how a myriad of tools should behave.


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Browsing The Project

```bash
kubectl get pods

jx get activities --filter jx-go --watch # Cancel with ctrl+c

jx get build logs --filter jx-go
```

Note:
Let's take a look at what's running inside the cluster.

We can see that some Pods are being created, some are running, while others, those that are not in use any more, are completed. I won't go into details of all of those. Think of it as "magic" for now. What matters is that one of them contains `jx-go` in the name. That's the Pod that is running the pipeline of our newly created application. When we created the files and pushed them to Git, it notified the cluster which, in turn, started running a pipeline that is building, testing, releasing, deploying, and performing all other needed tasks. Right now, we can see the activities of the pipeline and watch it's progress.

Similarly, if something goes wrong, we can observe the logs and get more insight into what's going on.

What matters, is that we only said that we would like to work on a new project. Everything else is being done by machines in the background.


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Browsing The Project

```bash
jx get pipelines

jx get env

jx get applications -e staging

open "https://github.com/$GH_USER/jx-go/releases"
```

Note:
We can get more insight into which pipelines we already have in the cluster by retrieving all.

We can see that there are four pipelines. There is one for each environment; development, production, and staging. We'll take a closer look at those later. For now, I'll just say that we are following GitOps principles and that means that any change to any of the environments starts with a change in Git which, in turn, sends a webhook that triggers one of those pipelines. Their primary goal is to converge the actual state into the desired state defined in dedicated Git repositories. The forth pipeline is handling the application itself. It was auto-generated when we created the new project.

What matters is that there is a Git repository associated with each of the pipelines, no matter whether they are specific to an application, an environment, or anything else.

Speaking of environments, we can retrieve them as well.

Currently there are three environments, matching those we saw in the pipelines. The interesting part is that the `PROMOTE` column of the staging environment is set to `Auto`. That means that applications are promoted to staging every time we push a change to the master branch of any of the applications. On the other hand, the production environment is set to `Manual`. Nothing will be promoted there automatically. Instead, we need to make a choice when a release of an application is ready for production.

As you can probably guess, any aspect of an environment can be changed. We can have more. Thery can all the automated or they can all be manual. There can be anything in between.

I already stated that applications are promoted to staging automatically, and that we already have some code in the master branch of the repository of the newly created application. That means that, by now, the first release of the application should be running in staging. Let's confirm that.

We can see that there is only one application in staging and that it is running the release `0.0.1`. Moreover, the system auto-generated an address of the application unique to staging. We'll get back to that address later. For now, let's check what's in the releases of that repo.

Even the release process is now automated, without me lifting a finger. Every time we push a change to the master branch, release notes are assembled and stored in Git. Right now, there's not much info but that's mostly because I did not yet write any significant commit messages.


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Browsing The Project

```bash
jx get applications

STAGING_ADDR=[...]

curl "$STAGING_ADDR"
```

Note:
Let's get back to the applications running in the staging environment, and copy the `URL`. I'll store it in an environment variable since I'm too old to remember it.

Now comes the moment of truth. Is our application truly deployed and accessible? Let's send a request and check it out.

We go the reponse. The application is up and running, and I still didn't do anything beyond expressing the desire to start working on a new project.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/developer.jpeg) center / cover" -->
<!-- .slide: class="center" -->
## You Do NOT Need To Do Any Of That

# Focus On What You Should Do

Note:
For most people all that does not matter. What is important is for everyone to be productive and the best way to accomplish that is by letting everyone write code and use the tools everyone is familiar with. The only tool that we probably agree is the common denominator is Git. So, all I want everyone to do is write code, and push changes to Git. Everything else should be transparent and run in background.
