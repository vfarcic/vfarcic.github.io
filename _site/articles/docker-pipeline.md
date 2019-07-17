# Using Docker And Jenkins Pipeline

These days, the first association many people have with DevOps are containers (Docker) and Continuous Delivery or Deployment (Jenkins). It comes as no surprise that those two are often combined. What follows are some of my personal best practices.

Before you proceed, I must warn you. What follows is not a politically correct post. The chances are that you will get offended. If you do, consider it a wake-up call. If you don't, even better. No matter the outcome, remember that you were warned.

## Define Jenkins Processes As Code

Incoming message to veteran Jenkins users... Stop finding excuses for using FreeStyle jobs. They are old and not designed to work as a CD pipeline. Jenkins Pipeline is. A CD pipeline is a single entity. It's a flow of steps that starts with a commit to a repository and ends with deployment to production (with an optional "Deploy Now" button). FreeStyle jobs were never meant to do that. They are task executors that cannot be easily joined into a pipeline. That is not to say that is their main weakness. It isn't. Some of the main problems are that they are hard to maintain, they discourage teams from taking control of their projects, they are not versioned, and so on and so forth. The list of the issues behind FreeStyle jobs is pretty big so, I'll concentrate on only a few that caused me quite a lot of pain.

FreeStyle jobs are not defined as code. It took us (the industry) years to understand that using UIs to write code is not a good idea. Today we live in the world that is clearly behind the "everything as code" principle.

I understand why people like UIs as a replacement for a text editor and the answer is not in its ease of use. The real reason lies in their inability to write code. That's why Jenkins has over 1200 plugins. They allow people to do things they do not understand. They allow people without engineering skills to act as they are experts. Do you need to execute Ansible? No problem. Just install a plugin, fill in thirty different fields, and there you go. Later on, you'll complain that the plugin doesn't work as expected, that it is buggy, or that it doesn't fulfill your needs. Guess what. The problem is not in the plugin. The problem is that you want to execute Ansible commands without understanding how it works. If you bothered to learn it, you'd realize that it is much easier to write `ansible-playbook make-me-a-coffee.yml` that to bother with a plugin. That is not to say that plugins are useless. Far from it. Quite a few are great, and I use them all the time. The problem is that many are not only unnecessary but put an additional burden on maintenance without a clear benefit. Please learn how to code or change profession. The worst you can do is pretend to be an engineer.

All I can say is: "FreeStyle, you served us well, now rest in peace." We can either move onto Jenkins Pipeline or face the same fate as [pharaohs servants](https://en.wikipedia.org/wiki/Ancient_Egyptian_retainer_sacrifices) after their master dies.

## Store A CD Pipeline Where It Belongs

Everything related to a project is in its repository. The code is there; automated tests are there; configuration is there. There is no good reason why a CD pipeline shouldn't be in that repository. What? Do I hear you say that a separate team maintains the pipeline? If that's your reason to keep the pipeline inside Jenkins, you're on the wrong path. If you are a member of continuous delivery or continuous deployment team, your task is not to maintain Jenkins jobs. You should dedicate your time to enable teams to write their own pipelines. Teach them how to do it, write commonly used functions and put them into Jenkins Global Library, and do anything else that might help them reach their goals. Whatever you do, do not give them fish. Teach them how to fish. Once you do, they will want to keep the pipeline close to the rest of their code. They will store it in *Jenkinsfile* inside their repositories.

## Run Everything Inside Containers

Containers are popular for a reason. They solve a lot of problems and should be adopted. CD is a perfect use case for Docker. Run Jenkins inside a container, run Jenkins agents inside containers, define pipeline steps as containers, run all services inside containers. If you are not adopting containers, you are either ignorant, or you're looking for excuses. Sure, Docker has its problems, but they are outnumbered by the benefits it provides. Whatever your reasons are for not using it, please do not say that it is a security risk. The real risk is that you don't live in 2017. How you went back in time is beyond me, but please come back to present time. If you don't like Docker, create containers yourself. Learn how namespaces and cgroups work. You will probably fail but, at least, you'll start appreciating what Docker did.

## Learn Docker And Jenkins Pipeline

Do not use Jenkins Docker plugin as an excuse not to learn Docker. Once you're done, learn Docker Compose. When you master it, move onto Docker Swarm (or Kubernetes, or Mesos). They're easy and user-friendly and they will make your life much easier.

The same goes for Jenkins Pipeline. If you want an easy path, choose Declarative Pipeline. If you want freedom, choose Scripted Pipeline. In either case, learn Groovy. It's only a programming language. I will assume that you do know how to code. If you don't, change the profession. If you do, learning a new language should be easy. If it isn't, then you lied about knowing how to code.

What you should not do is use one of those tools as an excuse to avoid learning the other. Ignore Jenkins Docker plugin, and just do `sh "docker-compose run tests"`.

## Do Not Use Jenkins As An Automation Engine

Jenkins is not a substitute for your code editor. It is not a tool that you use to write code. Your Pipelines should not be abominations that are hundreds or thousands lines of code. It should be a "glue" that ties your automation together. It should be an automation orchestrator. Run this, then run those in parallel, send an email if that fails, and so on. Each Pipeline task should be a single line that executes something written outside Jenkins. That can be a shell command, a bash script, or execution of anything else that is written and resides on your servers. Think of a Pipeline as a place where you assemble puzzle pieces. They are not produced in that Pipeline, only assembled. Jenkins Pipeline is where you define the "big picture".

Once you adopt containers, you will not even run bash scripts from a Pipeline. You'll store them inside containers together with all the dependencies they need. You'll execute a container which, in turn, will do the job. A well-defined pipeline is a place where you define on which agents steps will run, checkout the code using `scm checkout`, run `sh` steps that run containers, maybe publish some reports (even though I think there's not place for them in CD), and send some notifications when things fail. With a few exceptions, that's all there is to it. If you see you're doing more than that or if you see that the number of lines is measured in hundreds, you are probably doing it wrong.

## Run (Most Of) The Pipeline Locally

Jenkins is the final verification before a commit is deployed to (or ready for) production. The process does not start with Jenkins. It starts on developer laptops. He (or she) should not make a random commit to the repository and wait for Jenkins to detect whether it compiles. That is, at best, a sign of disrespect for the colleagues. Instead, a developer should run most of the Pipeline locally. He should build it, he should run unit tests (preferably through TDD process), he should run functional tests (or, at least, part of them), and so on and so forth. Long story short, we should do our best to commit something that most likely works. Why? Because we don't want to others to fork a faulty commit. Because we should not rely on others to act as our safety net. Because Docker makes all that easier than before.

The problem, you might say, is that the process takes a long time and you don't want developers to waste hours running things locally. That's why I stated that "we should do our best to commit something that **most likely works**." Performance tests might take a long time to finish, do not run them locally. Testing on many browsers might take a long time, do not run all of them locally (only one). Part of the Pipeline should remain only in Jenkins. But, that part should not be much. If your unit tests take a long time, you don't know how to write testable code. Learn it. If your build takes a long time, break that monolith into smaller pieces. If you need a database for your unit tests, learn how to write mocks. If you need a database for integration tests, run it in a container. If your integration tests last for more than a few minutes, learn what integration really is.

All that is not to say that parts of the Pipeline should run ONLY locally. Quite the contrary. Jenkins Pipeline should be the complete process. However, that does not give you an excuse to commit ___ (I was told not to swear in public, so I can't say the word behind ___, except that it starts with *sh* and ends with *it*).

All that means that everything should be inside a Jenkins pipeline and that most of it should be runnable locally. Unless you like wasting your time in duplicated efforts, both the pipeline and a developer should execute the same things. The only way to accomplish that is if both use scripts or shell commands. If that's not the case, you do like doing things twice and you like have potentially different results for the same thing. That could be characterized as masochism.

## Adopt Docker Compose YAML files

Don't waste your time defining and executing Docker commands. There it is. You heard it from a Docker Captain.

You should not fill your Pipeline with an endless stream of Docker arguments. Docker Compose YAML files are the place where you should specify what Docker should do. The execution should be left to Docker Compose. The problem is that Docker Compose is on its way towards complete deprecation. That does not mean that it is not useful. It is, but not as much as it was before. Use it to run batch type of processes. If you need to build something, use Docker Compose. If you need to test something, use Docker Compose. If you need to run a service, do NOT use Docker Compose. Use Docker Stack instead. Soon, Docker Swarm will be able to run attached services. When that happens, there will be no use for Docker Compose and everything will become Docker Stack.

Before you start entering a state of depression because of Docker Compose's path towards oblivion, remember that Docker Stack uses (almost) the same syntax. Almost everything you did will stay the same, only the binary you use to execute services defined in YAML files will change.

## Do Not Use Uber Images

It's tempting to create a Docker image that has everything your Pipeline steps need. You can create Dockerfile that has Maven, Gradle, sbt, FireFox, Chrome, npm, and all the other tools you need. You can put the whole Internet into a single image. The fact that you can do something does not mean that you should. Such images are hard to maintain, prone to errors, slow to pull, and, long story short, not the way to go. Instead, create small images that do one thing only (maybe two).

When you create a pipeline that, for example, compiles with Gradle and than proceeds to run tests through Chrome, you don't have to have both in the same image. Use one to build and another to test. It is much easier to combine many small things than to make a big monster that does everything. That's why Linux is so successful. It consists of many small and well-defined programs with well-defined inputs and outputs. When we need to do a complex operation, we combine them through pipes. For the same reason, microservices are slowly replacing monolithic applications. Docker, unlike most other technologies, is designed from ground up to serve a single process. The fact that you can run many does not mean that you should.

## Do Not Use Input Steps (Unless To Deploy To Production)

Jenkins Pipeline has a very useful `input` step. In a nutshell, it pauses the process until a human confirms (by clicking a button) that the pipeline can proceed. It's so useful that many use it all over CD pipelines. We can put it after building so that someone from QA department can confirm that they are ready to test. We can put it after testing so that infrastructure can confirm that they are ready to deploy it to integration environment. You get the point. The `input` step is useful as a gate from one department to another. All that is fine (actually it's not but I'll pretend that it is). The problem is that it should be illegal to call the process behind such a pipeline continuous delivery or deployment. There's nothing continuous when you wait for a human. Call it what you want but do not use the word "continuous". If you need inspiration, you can call it I-think-that-having-Jenkins-means-I-have-automation delivery or, if that's not appropriate, call it "eventual deployment".

The only exception is to use the `input` step at the end of the continuous delivery (not deployment) pipeline. It should be used to delay deployment to production if all the steps are green. That is the only use case of the `input` step if one wants to call it continuous delivery. That the only difference between continuous delivery and deployment.

## Small Masters

Do not stuff your Jenkins master with countless jobs. Do not make it a monster. It will be slow, prone to failures, and hard to navigate. I know why you're doing that. Creating a new master was time-consuming. You probably never learned configuration management tools (e.g. Ansible, Chef, Puppet). Or maybe you're used to building big things and admire them from a distance. No matter the reasons, just don't do it. If it is hard to create many masters in the past, it is not anymore.

Use Jenkins as the base Docker image, add whatever else you need (e.g. Chuck Norris plugin), build it, push it, and deploy as many masters as you need. It's as easy as that. Give each team a separate master. Keep them small, keep them lean.
