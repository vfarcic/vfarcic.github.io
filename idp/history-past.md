# The Beginning

### Mauricio & Viktor

[background image: coding]

Note:
Coders like anyone else
Mauricio: TODO:
Viktor: I started my career as a developer, a coder. I wrote my first application in Pascal. Since then I worked with languages most of you never heard of if you're younger than 50. I eventually landed on .Net and, later on, to Java. I had no idea how to do anything but write code.


# The Beginning

### Mauricio & Viktor

[background image: lazy]

Note:
Creating "stuff" that help us and others work less.
Mauricio: TODO:
Viktor: Eventually I realized that I'm lazy. I did not want to test my stuff manually. I did not want to work on issues detected by QA. I did not want to build binaries, and I did not want to spend my weekends deploying to production. The good news is that being lazy was easy since most of my time was spent waiting for someone to do something that might allow me to continue working on whatever I was working. That's when I started working on tools that will help me work less and for others to perform tasks that are outside their core competency.
That's where Mauricio and I diverged!


# The Beginning

### Mauricio

[background image: Java libraries]

Note:
Java libraries
Mauricio: TODO:


# The Beginning

### Viktor

[background image: Hudson]

Note:
Jenkins is the first IDP.
Viktor: I started with Shell scripts. Whatever I had to do more then once ended up as a script. It was painful to write them since some things could be done only visually so I started employing Selenium to fill in fields and press buttons. Others ended up as SSH commands on remote servers. We did not have HTTP APIs back then.
There were many conditionals that were checking the state of something and executing commands depending on the outcomes. Later on we got tools like CFEngine, predecessor to Chef, Puppet, Ansible, Terraform, Pulumi, and others. Configuration Management and, later on, IaC solved some of those problems.
I also started annoying QA people by writing my own tests which, eventually, led me to TDD and BDD.
Building, testing, deployments, and other operations eventually got automated.
Still, all those were disparate scripts that did not yet take a form of what might be considered services. Without services, there is no platform.
Then something amazing happened. We got a tool that provided everything we might consider a platform, even though, at that time, there was no Internal Developer Platform term nor platform engineer role existed.
That tool provided us to create services that will perform the operations, Web UI and APIs through which we could interact. All of a sudden, 10 years before we even started calling it platform engineering, we got everything we needed to create developer platforms.
Can anyone guess which tool that was?
It was Hudson, which was later forked into Jenkins.
What made Jenkins amazing was the ecosystem. It was an open model that could be extended through plugins. Jenkins alone was never a thing. Plugins are what made it amazing. Sure, most of them were rubbish, yet, those that were not extended Jenkins into very interesting and unexpected ways. There was nothing that could not be done in Jenkins, and I became a platform builder who used Jenkins for EVERYTHING!
That extensibility that resulted in, at that time, unprecedented ecosystem that resulted in Jenkins build a base on top of which anyone could build a platform, even though we did not call it like that at the time. Even though Jenkins is not something I would recommend today, especially not as a do-it-all tool, I feel that those same qualities that made Jenkins great are what made some other tool even better. I'll get to that one later, even though I'm sure you all know which one it is.


# The Past

### Mauricio & Viktor

[background image: Docker]

Note:
Docker emerged as a force that unifies us all (in dev)
Mauricio: TODO:
Viktor: The first time I was introduced to Docker I immediately thought that it is going to change the world. We got a universal packaging model, container images, and a universal way to run those packages anywhere (except Windows servers but, by that time, no one cared about it any more). More importantly, I saw the emergence of an ecosystem. In no time, we were able to run anything as containers. You need a database, no problem. There are hundreds of images you can choose from. Do you need to run workflows, or queues, or anything else? Docker has you covered. We could see the beginning of something amazing but, at that time, it was still a toy. Using containers in development and testing is great, but we needed more if we would want to run it in production. More importantly, for this story, Docker did not enable us to build platforms. It changed the way we package and, sometimes, how we run stuff. Platforms are much more than that. Developer platforms are about creating services and exposing those services to users. If felt like Docker might help, but it was unclear how. We knew that we needed more.


# The Past

### Mauricio & Viktor

[background image: Mesos, Swarm, Tupperware]

Note:
Orchestrators emerged


# The Past

### Mauricio & Viktor

[background image: Kubernetes]

Note:
Kubernetes became the "standard" orchestrator and surfaced the issue with Docker design (not extensible). Kubernetes was extensible from the start, but only if you contribute directly to its codebase.


# The Past

### Mauricio & Viktor

[background image: base platform]

Note:
Kubernetes became the base platform with the introduction of CRDs (extensible API). Kubernetes showed us the importance of HTTP APIs. The basic high level architecture of platforms started to emerge.
