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
Viktor: I started with Shell scripts. Whatever I had to do more then once ended up as a script. It was painful to write them since some things could be done only visually so I started employing Selenium to fill in fields and press buttons. Others ended up as SSH commands on remote servers. We did not have HTTP APIs back then.
There were many conditionals that were checking the state of something and executing commands depending on the outcomes. Later on we got tools like CFEngine, predecessor to Chef, Puppet, Ansible, Terraform, Pulumi, and others. Configuration Management and, later on, IaC solved some of those problems.
I also started annoying QA people by writing my own tests which, eventually, led me to TDD and BDD.
Building, testing, deployments, and other operations eventually got automated.
Still, all those were disparate scripts that did not yet take a form of what might be considered services. Without services, there is no platform.
Then something amazing happened. We got a tool that provided everything we might consider a platform, even though, at that time, there was no Internal Developer Platform term nor platform engineer role existed.
That tool provided us to create services that will perform the operations, Web UI and APIs through which we could interact. All of a sudden, 10 years before we even started calling it platform engineering, we got everything we needed to create developer platforms.
Can anyone guess which tool that was?
It was Hudson, which was later forked into Jenkins.
I became a platform builder who used Jenkins for EVERYTHING!


# The Past

### Mauricio & Viktor

[background image: Docker]

Note:
Docker emerged as a force that unifies all in dev


# The Past

### Mauricio & Viktor

[background image: Mesos, Swarm, Tupperware]

Note:
Orchestrators emerged


# The Past

### Mauricio & Viktor

[background image: Kubernetes]

Note:
Kubernetes became the "standard" orchestrator


# The Past

### Mauricio & Viktor

[background image: base platform]

Note:
Kubernetes became the base platform (extensible API with controllers)
