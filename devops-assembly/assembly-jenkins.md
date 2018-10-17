<!-- .slide: data-background="../img/background/why.jpg" -->
# Where Are We Today?

---


<!-- .slide: data-background="img/assembly-jenkins-01.png" data-background-size="contain" -->

Note:
We accomplish removal of human tasks from the assembly pipeline through some kind of an executor. Jenkins is one of those. It is most commonly used CD tool in the market, and the community, as well as enterprise offerings around it, recognized the need for constant improvements. Once we employ an executor or, to be more precise, tasks orchestrator, it takes over the execution of all the tasks that involve the tools and logic that comprises the assembly pipeline.


<!-- .slide: data-background="../img/background/continuous-deployment.png" -->
> There is no place for humans in the software assembly line.

Note:
> There is no place for humans in the software assembly line.

Still, assuming that we do choose Jenkins, we might need to rewire our brains to the new processes and get rid of the legacy line of thinking. For one, there should be only one assembly pipeline per repository. We were thought for too long that the assembly should reflect our internal organization within the company. So, we ended up with many Freestyle jobs, one for each group involved in the lifecycle of the application. Instead of having a single pipeline for each repository (app), we were creating many smaller ones. One would be dedicated to developers working on a project. The other would be owned by testers. The third would be in the hands of operators. And so on, and so forth. The problem with that approach is that it reflected our, often ineffective and misunderstood internal human organization. Such divided pipeline does not make sense if we are to automate the whole process.


<!-- .slide: data-background="img/assembly-jenkins-02.png" data-background-size="contain" -->


<!-- .slide: data-background="img/assembly-jenkins-03.png" data-background-size="contain" -->


<!-- .slide: data-background="img/assembly-jenkins-04.png" data-background-size="contain" -->


<!-- .slide: data-background="../img/background/continuous-deployment.png" -->
> An application resides inside a single repository, and it contains a single pipeline that moves it through all the assembly steps. From the logical perspective, that is the only process that makes sense. Everything else was designed only to fuel our internal silos.

Note:
> An application resides inside a single repository, and it contains a single pipeline that moves it through all the assembly steps. From the logical perspective, that is the only process that makes sense. Everything else was designed only to fuel our internal silos.

Freestyle jobs, when they were created over ten years ago, have too many problems. I can't say that they were poorly designed at the time, but that the industry moved to new processes.


<!-- .slide: data-background="img/jenkins-freestyle.png" data-background-size="contain" -->
> Freestyle jobs deserve to die, once and for all.

Note:
> Freestyle jobs deserve to die, once and for all.

Freestyle jobs are not (easily) stored in version control, and they do not represent a simple logic applied to the full lifecycle of an application. Moreover, they do not provide the full view of the assembly line nor do they scale. Most importantly, Freestyle jobs do not adhere to everything as code logic. Simply put, they are legacy, and yet many still cling onto them. One of the reasons for that is the inability to write code. Too many people are used to the click-click-click way of working thinking that a complex pipeline can be defined and maintained by filling in an endless number of fields and selecting values from drop-down lists. If that's your view of where the industry is today, you do not deserve to work in it.


<!-- .slide: data-background="../img/background/why.jpg" -->
# Problems

---

* Not in version control
* Only simple logic
* No unified view of the assembly
* Does not scale


<!-- .slide: data-background="img/jenkinsfile.png" data-background-size="contain" -->

Note:
Instead of Freestyle jobs, now we have Jenkins Pipelines. They are defined as code as stored in Jenkinsfile residing in the same repository as the code of the application that is being moved through the assembly. On top of other benefits, given that a single Jenkins Pipeline represents the whole flow of an application, we are finally able to render it visually in a simple and easy to understand way through the Blue Ocean plugin.

Given that Jenkins Pipeline is code like any other, we should follow the best practices that we usually apply to code. Among others, Jenkinsfile should be simple and allow us to navigate through the flow easily. Jenkinsfile is not supposed to be hundreds of lines of code, just as the main function of your application hopefully isn't big. It should be too simple either since it does need to allow us to navigate through the steps, or groups of steps, without the need to open other files. That means that a single line like `runPipeline()` is not a good idea either. We need to balance simplicity, readability, and navigation through the flow of a pipeline. For that reason, we got Shared Libraries.


<!-- .slide: data-background="img/assembly-jenkins-05.png" data-background-size="contain" -->


<!-- .slide: data-background="img/blue-ocean-repo.png" data-background-size="contain" -->


<!-- .slide: data-background="img/shared-libraries.png" data-background-size="contain" -->

Note:
The introduction of Jenkins Pipelines, BlueOcean, Shared Libraries, and many other tools is only part of the story. It would be foolish to think that it's enough to concentrate on a single tool for all your CD and CDP processes. Jenkins is an orchestrator of the steps that comprise a pipeline. We need to make the right choices about the tools that will be used in those steps as well as how we're going to run Jenkins and its agents.

Specifically, we have to solve the problem of scale. Sooner or later, we'll need more Jenkins servers, and we'll need to manage all our agents which over time usually increase in quantity and variety.


# There's Still The Problem At Scale

---


<!-- .slide: data-background="../img/products/docker.png" data-background-size="contain" -->
> It is just silly not to use containers.

Note:
> It is just silly not to use containers.

They are easy to manage, and they provide too many benefits for us to ignore them. Everyone adopted or is adopting containers. They are not just another passing phase. They are here to stay.

A few years ago, you could have said: "I want to wait and see whether containers are hype or they're here to stay." There is no excuse anymore. Everything designed in the 21st century should be packaged as container images and run as containers.


<!-- .slide: data-background="../img/products/docker.png" data-background-size="contain" -->
> If your applications are not a good fit to be inside containers, it was probably designed in the previous century and you gave up on refactoring and modernizing it.

Note:
> If your application is not a good fit to be inside containers, it was probably designed in the previous century, and you gave up on refactoring and modernizing it.

What do we do with things we've given up on? We let them rot. Everything else goes to containers.

CI/CD processes are the perfect example of the usefulness of containers. We need a lot of different tools, so we spin up containers. We need them only for a short period, so we kill containers once we're done. Containers allow us to create environments we need faster than any alternative, and they can be killed before they start wasting resources. Create, do, destroy, is the motto.

Now, using containers alone would be a great idea if this would be 2013. If you think that's the year you're in, I must congratulate you on inventing time-machine. For everyone else, this is 2018, and we do not use containers directly. That's the old story that we left behind. Today, we use schedulers to manage our containers. Even though I used the plural, there is only one scheduler worthwhile considering. That's Kubernetes. 

Now, I know what some of you might be thinking. Is Kubernetes hype? Is it here to stay? Does it provide tangible benefits? Well, Kubernetes is not hype, and it is here to stay. Almost every software vendor has a vested interest in Kubernetes. We're all building next generation of our software based on Kubernetes. On top of that, Kubernetes is the biggest project ever seen, and it has the biggest and the most vibrant community software in the software industry. Too many people and companies depend on Kubernetes.


<!-- .slide: data-background="../img/products/kubernetes.png" data-background-size="contain" -->
> It would be impossible to imagine any foreseable future in which Kubernetes does not rule the scene.

Note:
> It would be impossible to imagine any foreseeable future in which Kubernetes does not rule the scene.

As for the question of whether Kubernetes "provides tangible benefits"... The answer is a huge YES unless you do not live in the 21st century. If your applications are still based on the design from 1999, then there is no hope for you, and you can just as well give up, not only on Kubernetes but on life itself. Or move somewhere else. For everyone else, Kubernetes is the platform where everything runs. It's the new operating system, it's the scheduler, it's the integrator of most of the advancements we got in the last few years. So, let's close this discussion on whether to use Kubernetes or not. If you don't, and you're not planning to, you are gravely mistaken, and you will be awarded a medal before you are killed by competition.


<!-- .slide: data-background="img/blue-steel.png" data-background-size="contain" -->

Note:
Not only that we (CloudBees and community behind Jenkins) recognize Kubernetes and schedulers as the future, but we are on the forefront of what's going on and are defining how CD should look like in Kubernetes. You can see that through the tight integration between CloudBees Jenkins Core and Kubernetes. You need a new Jenkins? Just click a button.


<!-- .slide: data-background="img/cje.png" data-background-size="contain" -->

Note:
You need to run a build with twenty-seven tools involved in the process? Just define your Pod Template, and Jenkins will take care of the rest.


<!-- .slide: data-background="../img/products/jenkins-x.png" data-background-size="contain" -->
> You want to get the glimpse into the future? Get acquainted with Jenkins X.

Note:
You want to get the glimpse into the future? Get acquainted with Jenkins X.


<!-- .slide: data-background="../img/products/kubernetes.png" data-background-size="contain" -->
> Jenkins is putting all its stakes into Kuberneters, and the results are amazing.

Note:
> Jenkins is putting all its stakes into Kuberneters, and the results are amazing.
