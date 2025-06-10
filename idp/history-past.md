<!-- .slide: data-background="img/coder.png" data-background-size="cover" -->

Note:
The Beginning: Coders like anyone else

Viktor:

I started my career as a developer, a coder. I wrote my first application in Pascal. Since then I worked with languages most of you never heard of if you're younger than 50. I eventually landed on .Net and, later on, to Java. I had no idea how to do anything but write code.

Mauricio:

I started my career Java, building apps and doing consulting with banks and healthcare providers. That road took me to work with Application Servers where I quickly realized that I like helping developers to be more efficient when coding so I transitioned to build Java libraries (middleware as it was called long time ago), when I joined Red Hat / JBoss to work on that 24/7. 


<!-- .slide: data-background="img/help-others.png" data-background-size="cover" -->

Note:

Creating "stuff" that help us and others work less.

Viktor:

Eventually I realized that I'm lazy. I did not want to test my stuff manually. I did not want to work on issues detected by QA. I did not want to build binaries, and I did not want to spend my weekends deploying to production. The good news is that being lazy was easy since most of my time was spent waiting for someone to do something that might allow me to continue working on whatever I was working. That's when I started working on tools that will help me work less and for others to perform tasks that are outside their core competency.

Is that a developer platform? Can we call a set of tools that help developer be more productive a developer platform?


<!-- .slide: data-background="/img/products/hudson.png" data-background-size="contain" -->

Note:

UI: Jenkins is the first IDP.

Viktor:

I started with Shell scripts. Whatever I had to do more then once ended up as a script. It was painful to write them since some things could be done only visually so I started employing Selenium to fill in fields and press buttons. Others ended up as SSH commands on remote servers. We did not have HTTP APIs back then.

There were many conditionals that were checking the state of something and executing commands depending on the outcomes. Later on we got tools like CFEngine, predecessor to Chef, Puppet, Ansible, Terraform, Pulumi, and others. Configuration Management and, later on, IaC solved some of those problems.

I also started annoying QA people by writing my own tests which, eventually, led me to TDD and BDD.
Building, testing, deployments, and other operations eventually got automated.

Still, all those were disparate scripts that did not yet take a form of what might be considered services. Without services, there is no platform.

Then something amazing happened. We got a tool that provided everything we might consider a platform, even though, at that time, there was no Internal Developer Platform term nor platform engineer role existed.

That tool enabled us to create services that will perform the operations, Web UI, CLI, and APIs through which we could interact. All of a sudden, 10 years before we even started calling it platform engineering, we got everything we needed to create developer platforms.

Can anyone guess which tool that was?

It was Hudson, which was later forked into Jenkins.

What made Jenkins amazing was the ecosystem. It was an open model that could be extended through plugins. Jenkins alone was never a thing. Plugins are what made it amazing. Sure, most of them were rubbish, yet, those that were not extended Jenkins into very interesting and unexpected ways. There was nothing that could not be done in Jenkins, and I became a platform builder who used Jenkins for EVERYTHING!

That extensibility that resulted in, at that time, unprecedented ecosystem that resulted in Jenkins being a base on top of which anyone could build a platform, even though we did not call it like that at the time. Even though Jenkins is not something I would recommend today, especially not as a do-it-all tool, I feel that those same qualities that made Jenkins great are what made some other tool even better. I'll get to that one later, even though I'm sure you all know which one it is.

So, the question is whether Jenkins is the platform or a model of a platform we should use?


<!-- .slide: data-background="/img/products/docker.png" data-background-size="contain" -->

Note:
Docker emerged as a force that unifies us all (in dev)

Viktor:

The first time I was introduced to Docker I immediately thought that it is going to change the world. We got a universal packaging model, container images, and a universal way to run those packages anywhere (except Windows servers but, by that time, no one cared about it any more). More importantly, I saw the emergence of an ecosystem. In no time, we were able to run anything as containers. You need a database, no problem. There are hundreds of images you can choose from. You need to run workflows, or queues, or anything else? Docker has you covered.

We could see the beginning of something amazing but, at that time, it was still a toy. Using containers in development and testing was great, but we needed more if we wanted to run it in production. More importantly, for this story, Docker did not enable us to build platforms. It changed the way we package and, sometimes, how we run stuff. Platforms are much more than that. Developer platforms are about creating services and exposing those services to users. If felt like Docker might help, but it was unclear how. We knew that we needed more.

So, the question was the same. Is Docker the platform or a model of a platform we should use?


<!-- .slide: data-background="/img/products/kubernetes.png" data-background-size="cover" -->

Note:
Viktor:

Then we got orchestrators. We got Mesos that was not only the only one, but proved itself at large scale. Docker Swarm, Nomad, Tupperware (does anyone remember that one), Kubernetes, and others emerged. It seemed that everyone was building an orchestrator.

Kubernetes became the "standard" orchestrator and surfaced the issue with Docker design. Docker was not extensible. It was adopted by users, but not by vendors. Kubernetes, on the other hand, was extensible from the start, but only if we contributed directly to its codebase. Kubernetes truly became the base platform with the introduction of CRDs (extensible API). It showed us the importance of HTTP APIs and the high level architecture of platforms started to emerge.

Mauricio:

For me it was a bit different, I really went deep into Docker and containers because of Kubernetes. I wasn't too deep in the DevOps space, hence the use of containers wasn't a must for my role when building libraries. 

After working with Java, containers and Kubernetes for about a year inside Red Hat (with their Openshift based on Kubernetes offering) I left Red Hat, as I wanted to fully work with containers & Kubernetes 24/7. This was quite strange for a developer at that time. 

The Java community, with frameworks like Spring Cloud and Java EE provided mechanisms for service discovery and resilience aiming to solve distributed application challenges, but these aligned quite well with Kubernetes. So I thought, there is an opportunity here to help developers and organizations to jump on the Kubernetes / Containers train. 

It was clear to me than more and more topics related to scalability, resilience and even more the application architectures that we were creating were about to change. As a developer I could understand how to interact with Kubernetes and even how to extend it


<!-- .slide: data-background="/img/products/kubernetes.png" data-background-size="cover" data-background-opacity="0.2" -->
## We've been building platforms for a long time, but now we all finally agree what the base of a platform is
