# Managing And Maintaining DevOps Assembly Line

Let's start with setting the record straight. There is no such thing as **DevOps Assembly Line**. I invented it by replacing **Software** with **DevOps**. Why did I do that? Because everything needs to put the word "DevOps" to be popular. Saying software assembly lines is boring. It sounds like something you already know, or at least you heard or it.

Nevertheless, everything changes and software assembly lines are not an exception. So, in the spirit of self-marketing, the title contains **DevOps** as a way to attract your attention. Still, from now on, I'll call it what it is. It'll be the **software assembly line**.

## What Is (Software) Assembly Line?

To understand software assembly line, we need to understand manufacturing assembly line first. After all, we (software industry) based a lot of our practices on manufacturing industry. That is terribly wrong, but that's where most of us are, so let's see what does it mean in manufacturing.

Manufacturing assembly line can be described with the sentence that follows.

> In the manufacturing process, parts are added in sequence until the final assembly is produced.

That sounds straightforward. Actually, it's so easy to understand that many thought that should be the way to assemble software. Add the parts in sequence from gathering requirements, all the way until it's deployed to production. Yippee! We got a process.

The problem is that the manufacturing process differs from software development in one key aspect.

> The goal of the manufacturing assembly line is to mass-produce a product with the same specifications and quality.

The goal of an assembly line in the manufacturing industry is to create many identical copies of something. The car industry, for example, uses assembly lines to produce thousands of cars that are exactly the same. Even when there are variations, they are limited in number and are never custom. We cannot order a wheel in a different place, nor we can choose any fabric for the interior. At best, we can choose from a few pre-defined options. The software industry is entirely different

> The goal of a software company is to produce a single product with a repeatable process.

We do not have goals to mass-produce anything. We are trying to produce a **single** product with a **repeatable process**. We do not make many copies of the same product (excluding those still delivering CDs and floppy disks to their desktop customers). At least, not in a physical form.

Every release is a different product. If that's not your case, and if you do make the same release over and over again, you are probably confused and chose the wrong industry.

> Every commit is a different product.

All that is not to say that there is nothing to be learned from manufacturing assembly line. It features a repeatable process. Our processes should be repeatable as well. However, almost every manufacturing assembly line involves automation and manual labor. Ours shouldn't because we do not deal with the physical world (everything is bytes). We can have a fully automated process after the creative tasks end. And that leads me to yet another significant difference.

In manufacturing, considerable investment in time, people, and money goes into manufacturing while the design is usually much cheaper. We do, for example, need to design a car, but that is only a fraction of the cost. Producing it is where the real expense lies. If the design is wrong, the cost of repeating the production and re-delivering the product to the customer is so big that it can ruin a company. In software, the design represents almost the entire cost of a release. Now, I need to clarify that by design, I want to say creative and not repeatable work that involves not only brainstorming of a solution but also coding. Every feature we deliver is a result of a massive effort in creative tasks, and almost no effort to move it (after a commit) through the assembly which, in this context, means building, testing, deploying, and other repetitive tasks. At least, that's how it should be, even though in many cases it's not. If we make a mistake in design, all we have to do is to correct it. Delivering the change to customers is almost instant, and there is no significant cost in recreating the product with the fix or redesign. The only significant note is that our costs increase with the time it took us to discover an issue.

> In manufacturing, the design is only a fraction of the cost but, if it does wrong, it cannot be fixed after it is delivered to customers.

> In software, the design is the most of the cost, and if it goes wrong, we can fix it quickly only if we detect it early after it's delivered to customers.

We tend to employ an army of people dedicated to working manually on repetitive tasks (e.g., manual testing, deployments, etc.). That is, kind of silly given that we are in the business of writing software that does things and helps others in their daily lives. And yet, we are somehow better at creating software for others, than software that will help us.

But, I might have moved too fast. Let's go back through history and find out how we got where we are, and where should we go next.

## Waterfall Assembly Line

A long time ago in a galaxy far, far away, someone came up with a brilliant idea. "Why don't we do the same thing as manufacturing. We'll design a linear process that will be bullet-proof and will result in high-quality software being delivered to our customers fast." Now, for the sake of clarity, the idea came from Winston W. Royce as a description of a flawed, non-working model. But, be it as it may, we adopted it nevertheless, and we started calling it the Waterfall process. So, how does it work?

The process, in spite of some variations, is linear. Analysts figure out what users need. They write specifications and give them to developers. They write code that makes those requirements a working software. Developers, in turn, are not to be trusted, so they pass it on to testers that validate the software against the requirements. Once testers are finished, they deliver it to operators, who install that software in production. Just to be on the safe side, the last stage is maintenance. Just as cars sometimes malfunction, our software often contains some undesirable effects which are fixed after its delivered to its users. The whole process would take only a couple of years or, if we're very good at our jobs and very lucky, sometimes just months.

The major problem with the Waterfall process and its assembly line is that **it never worked**. And yet, we were repeating it over and over again. We do a project, and it fails either by not having sufficient quality, or by being more expensive, or by missing deadline (by months or years), or (the most common outcome) by not delivering things that users want. The first project would fail, and we'd to the second using the same process. When the second failed, we did the third. And so on and so forth, until we retire. Every once in a while, we would be successful. But, those were either exceptions or we'd "fake" the plan to make sure that it works. By fake, I mean double the estimates and rewrite the requirements so that we can say "look, we delivered on time, and it's what you want." **What users wanted was in most cases not what users needed.**

We were not learning from our mistakes. The process was flawed and even when a project was considered a success, that was usually because we did not follow the process. When I look back at those times, I can only conclude that we were all insane. At least, according to Einstein.

> "Insanity Is Doing the Same Thing Over and Over Again and Expecting Different Results" -- Albert Einstein

There were quite a few problems with the whole process. First of all, the duration. We cannot expect to work on something for months or even years before we deliver that something. Remember, we are not manufacturing identical copies.

> We are not producing cars where an error in design results in thousands of faulty cars being delivered and never to be fixed.

> We are delivering bytes that can change whenever we want, and that can be re-delivered to all users in no time.

> The second reason for the failure of the waterfall process is that it was impossible to make it linear.

We cannot expect analysists to know in advance all the features users want. We couldn't expect developers to work for months without producing bugs or, more importantly, not to make mistakes from the start and, at the end of their work, to expect them not to go back to the beginning due to those mistakes. Testers were supposed to confirm that our software works flawlessly, and not to return with hundreds or thousands of bug reports and misinterpreted requirements. If that was not our expectation, why were testers involved only after developers produce months or years of faulty software? It gets worse. After the testing stage, we'd give it to operators, only to discover that, after the software is deployed, it does not work correctly and it needs to go back to developers and, consequently, to testers. Finally, if the system worked well, why did we have months of maintenance? We do not return cars because there is no wheel in them, but because there is a problem caused by driving thousands of kilometers.

Even though the Waterfall process tried to create an equivalent of the manufacturing assembly line, it went into the opposite direction. If anything, the Waterfall is closer to slave labor. **You have tight control over everything and everyone, the process is mostly manual, and everyone dislikes you.** The waterfall is equivalent to pre-industrial revolution. Or, to find an even better parallel, to the way Egyptians built pyramids.

> The process to build pyramids: a lot of managers overview the workforce working on implementing a multi-year plan that is likely going to be delayed, to require more slaves, or to crumble.

There was no incentive for automation, and therefore, for an assembly line. Everything could be fixed by finding more people to work.

This brings me to the main problem.

## The Tools Used In Software Development

We tend to use a lot of tools, and they differ from one role to another. Analysts might use Microsoft Word, Google Docs, or Markdown. Developers spend most of their time writing code in Visual Studio Code, IntelliJ, or Eclipse (only to name a few). Testers tend to look at stats in SonarQube, and they might write some automated tests with, let's say, Selenium. Operators love VMWare, Docker, Kubernetes, OpenStack, and other tools that help them do their work. And those in charge of maintenance also have their favorites.

Using tools is not a problem by itself. The real issue is that we are mixing the tools and using them in inappropriate places. We can split them into those that require creative work (e.g., coding, writing stories, and so on) and those that do the repetitive steps. The former should be used while designing the solution, while the latter should be part of the assembly line. It is essential to understand that the **assembly line is all about automation, and not the creative work**. We expect to have an assembly line in which we can say "stop the process, I need to write a test" or "pause everything, I need to get an understanding of that weird result in SonarQube".

## Agile And DevOps Processes

After a lot of misery and suffering introduced through Waterfall, we got Agile and, later on, DevOps. The idea is simple, even though the two implemented it differently. Form a small and self-sufficient team capable of delivering a new set of features in each short iteration. The time of delivery changed from months, or even years, to weeks, and sometimes even days or hours.

> The significant difference between Agile and DevOps is that the former forgot to invite experts from the second half of the software development lifecycle.

Even though that was never officially prescribed, Agile teams forgot that they do need operational, infrastructure, and maintenance knowledge if they are to deliver features "for real". They would often say, "we're finished, and we are moving into the next sprint", even though there was a lot of work left to be done by others. DevOps remedies that by trying to form genuinely self-sufficient teams that are in charge of everything, from requirements to deploying to production and maintaining software. Nevertheless, I'll assume that both types of teams are the same for the rest of this narrative.

> The only way to say that something is done is to run it in production successfully. Everything else is faking the status.

Those self-sufficient teams decided that iterations should be short (e.g., weeks, or even days), so they had to move fast. Analysists (product owners?) would come up with the requirements for the upcoming sprint and pass it to developers. Developers would write their code and give it to testers. Testers would move it to operators. Operators would deploy to production and leave it to maintainers. Each of those handovers could fail, and when that happens, the process must start over.

The problem with that process is that it is not fundamentally different from the Waterfall, except that an iteration shrank from months or years to weeks or days. 

> The problem of coupling creative design work with repetitive tasks of an assembly line often exists no matter whether you're using Waterfall or Agile processes.

There is no place for creativity in an assembly line. Ask any factory worker, and you'll get the same response. Assembly line is supposed to be fast and reliable, and we accomplish that through repetition. If a worker in a factory would stop to think whether he liked the color of the new car or if it should be better with a slightly lighter shade, the whole process would break. That does not mean that a worker cannot stop the assembly line. It can (at least those in Toyota), but only if there is an issue that prevents repeatability and quality of the outcome of production, not design.

The result of applying some of the assembly line processes is continuous delivery or continuous deployment.

## Continuous Delivery Or Deployment

The goal of a continuous delivery (CD) or a continuous deployment (CDP) pipeline is simple to explain, but difficult to implement.

> Every commit to a specific branch (e.g., master) is moved through a **fully automated process** that results in a new release being ready for deployment to production (continuous delivery) or being installed in production (continuous deployment).

The key words in that sentence are "**fully automated process**".

> There is no place for humans after a commit to the master branch.

Whatever manual work has to be done, it needs to be done before the pipeline starts. There should be some tests, so write them in advance. There should be some modifications to the deployment script, write it in advance. And so on and so forth. Because the moment a developer pushes new code, all manual work related to it must be finished. If you do not feel you can do your job in that fashion and that you cannot be proactive, then maybe you should step down and let others take over. Or admit your deficiencies and learn how to operate in this new world.

The only way to be effectively proactive during this "creative" stage is to define everything as code. Tests must be expressed as code, infrastructure needs to be defined as code, deployments need to be written as code, and so on and so forth.

> Be proactive with "**everything as code**" is the new mantra.

Enough time passed for us to realize that there is no place for non-coders in the software industry. If you work with software, you code. It does not matter whether you are the "Jack of all trades" or you are specialized. Whatever you do, be it testing, developing, deploying, monitoring, or any other type of tasks, you have to write code. That's the reality of today's market, and if you do not think that you can do that, you can still change your calling.

> There's still time to change your profession and become a doctor, a lawyer, or a truck driver.

During this creative pre-commit phase, we use tools that are entirely different than the tools used during the pipeline. I do not care whether that's IntelliJ, VS Code, Vi, Eclipse, MS Project, or any other tool through which you use the creative side of your brain. As long as you do the job in advance, you're being proactive. If you can express your work through the code, you're doing fine.

I almost forgot one crucial piece of the story. You need to finish whatever you have to do before a new commit is pushed to the master branch.

All those of you that were involved in manual processes during the latter phases of the software lifecycle need to move to the left or move out. You need to learn how to be proactive and do the work in advance. We do not have time to wait for you. Lean time is not acceptable anymore, nor it is allowed just to throw things over the wall to others. Those days are gone, and now we are expected to deliver fast (often multiple times a day). Such speed cannot be accomplished if there are **human blockers** in the process.

Once the pipeline starts, machines take over. A pipeline executed through one of the CD platforms (e.g., Jenkins) will use a completely different set of tools than those you used during the creative phase. Those can be SonarQube, Selenium, Kubernetes, Docker, VMWare, Git, and many others. What they all have in common is that they do not require humans (in this phase) and that they have to do something. That "something" can be many things, and the only important factor is their exit code. Each step is either successful, and the pipeline moves to the next one, or it fails, and the execution of the pipeline stops. There is no gray area. There is no space for "we use SonarQube, but we do not fail builds when certain thresholds are reached." The result of an execution of a pipeline is black or white.

> Continuous delivery builds are like **Schrodinger's cats**.

While the builds are running (the cat is in the box), the result can be considered both success or failure (the cat can be dead or alive). Only when we open the lid (receive notifications) can we know the outcome. Or, to be more precise, we hear just about dead cats. No notifications are telling us about those who survived, only about those that failed.

## Where Are We Today?

We accomplish removal of human tasks from the assembly pipeline through some kind of an executor. Jenkins is one of those. It is most commonly used CD tool in the market, and the community, as well as enterprise offerings around it, recognized the need for constant improvements. Once we employ an executor or, to be more precise, tasks orchestrator, it takes over the execution of all the tasks that involve the tools and logic that comprises the assembly pipeline.

> There is no place for humans in the software assembly line.

Still, assuming that we do choose Jenkins, we might need to rewire our brains to the new processes and get rid of the legacy line of thinking. For one, there should be only one assembly pipeline per repository. We were thought for too long that the assembly should reflect our internal organization within the company. So, we ended up with many Freestyle jobs, one for each group involved in the lifecycle of the application. Instead of having a single pipeline for each repository (app), we were creating many smaller ones. One would be dedicated to developers working on a project. The other would be owned by testers. The third would be in the hands of operators. And so on, and so forth. The problem with that approach is that it reflected our, often ineffective and misunderstood internal human organization. Such divided pipeline does not make sense if we are to automate the whole process.

> An application resides inside a single repository, and it contains a single pipeline that moves it through all the assembly steps. From the logical perspective, that is the only process that makes sense. Everything else was designed only to fuel our internal silos.

Freestyle jobs, when they were created over ten years ago, have too many problems. I can't say that they were poorly designed at the time, but that the industry moved to new processes.

> Freestyle jobs deserve to die, once and for all.

Freestyle jobs are not (easily) stored in version control, and they do not represent a simple logic applied to the full lifecycle of an application. Moreover, they do not provide the full view of the assembly line nor do they scale. Most importantly, Freestyle jobs do not adhere to everything as code logic. Simply put, they are legacy, and yet many still cling onto them. One of the reasons for that is the inability to write code. Too many people are used to the click-click-click way of working thinking that a complex pipeline can be defined and maintained by filling in an endless number of fields and selecting values from drop-down lists. If that's your view of where the industry is today, you do not deserve to work in it.

Instead of Freestyle jobs, now we have Jenkins Pipelines. They are defined as code as stored in Jenkinsfile residing in the same repository as the code of the application that is being moved through the assembly. On top of other benefits, given that a single Jenkins Pipeline represents the whole flow of an application, we are finally able to render it visually in a simple and easy to understand way through the Blue Ocean plugin.

Given that Jenkins Pipeline is code like any other, we should follow the best practices that we usually apply to code. Among others, Jenkinsfile should be simple and allow us to navigate through the flow easily. Jenkinsfile is not supposed to be hundreds of lines of code, just as the main function of your application hopefully isn't big. It should be too simple either since it does need to allow us to navigate through the steps, or groups of steps, without the need to open other files. That means that a single line like `runPipeline()` is not a good idea either. We need to balance simplicity, readability, and navigation through the flow of a pipeline. For that reason, we got Shared Libraries.

Jenkins Pipeline Shared Libraries follow the same principle as shared libraries in any other application. Just as your application probably consists of a combination of public and private libraries, Jenkinsfile follows the same logic. Publicly available steps are equivalent of public libraries you use (e.g., JUnit). On the other hand, just as you have common private code used across multiple applications, Jenkins has Shared Libraries. They reside in a separate code repository and can be invoked whenever a job needs them.

The introduction of Jenkins Pipelines, BlueOcean, Shared Libraries, and many other tools is only part of the story. It would be foolish to think that it's enough to concentrate on a single tool for all your CD and CDP processes. Jenkins is an orchestrator of the steps that comprise a pipeline. We need to make the right choices about the tools that will be used in those steps as well as how we're going to run Jenkins and its agents.

Specifically, we have to solve the problem of scale. Sooner or later, we'll need more Jenkins servers, and we'll need to manage all our agents which over time usually increase in quantity and variety.

> It is just silly not to use containers.

They are easy to manage, and they provide too many benefits for us to ignore them. Everyone adopted or is adopting containers. They are not just another passing phase. They are here to stay.

A few years ago, you could have said: "I want to wait and see whether containers are hype or they're here to stay." There is no excuse anymore. Everything designed in the 21st century should be packaged as container images and run as containers.

> If your applications are not a good fit to be inside containers, it was probably designed in the previous century, and you gave up on refactoring and modernizing it.

What do we do with things we've given up on? We let them rot. Everything else goes to containers.

CI/CD processes are the perfect example of the usefulness of containers. We need a lot of different tools, so we spin up containers. We need them only for a short period, so we kill containers once we're done. Containers allow us to create environments we need faster than any alternative, and they can be killed before they start wasting resources. Create, do, destroy, is the motto.

Now, using containers alone would be a great idea if this would be 2013. If you think that's the year you're in, I must congratulate you on inventing time-machine. For everyone else, this is 2018, and we do not use containers directly. That's the old story that we left behind. Today, we use schedulers to manage our containers. Even though I used the plural, there is only one scheduler worthwhile considering. That's Kubernetes. 

Now, I know what some of you might be thinking. Is Kubernetes hype? Is it here to stay? Does it provide tangible benefits? Well, Kubernetes is not hype, and it is here to stay. Almost every software vendor has a vested interest in Kubernetes. We're all building next generation of our software based on Kubernetes. On top of that, Kubernetes is the biggest project ever seen, and it has the biggest and the most vibrant community software in the software industry. Too many people and companies depend on Kubernetes.

> It would be impossible to imagine any foreseeable future in which Kubernetes does not rule the scene.

As for the question of whether Kubernetes "provides tangible benefits"... The answer is a huge YES unless you do not live in the 21st century. If your applications are still based on the design from 1999, then there is no hope for you, and you can just as well give up, not only on Kubernetes but on life itself. Or move somewhere else. For everyone else, Kubernetes is the platform where everything runs. It's the new operating system, it's the scheduler, it's the integrator of most of the advancements we got in the last few years. So, let's close this discussion on whether to use Kubernetes or not. If you don't, and you're not planning to, you are gravely mistaken, and you will be awarded a medal before you are killed by competition.

Not only that we (CloudBees and community behind Jenkins) recognize Kubernetes and schedulers as the future, but we are on the forefront of what's going on and are defining how CD should look like in Kubernetes. You can see that through the tight integration between CloudBees Jenkins Core and Kubernetes. You need a new Jenkins? Just click a button. You need to run a build with twenty-seven tools involved in the process? Just define your Pod Template, and Jenkins will take care of the rest. You want to get the glimpse into the future? Get acquainted with Jenkins X.

> Jenkins is putting all its stakes into Kuberneters, and the results are amazing.