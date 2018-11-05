<!-- .slide: data-background="../img/background/continuous-deployment.png" -->
# Continuous Delivery Or Deployment

---

Note:
The goal of a continuous delivery (CD) or a continuous deployment (CDP) pipeline is simple to explain, but difficult to implement.


<!-- .slide: data-background="../img/background/continuous-deployment.png" -->
> Every commit to a specific branch (e.g., master) is moved through a **fully automated process** that results in a new release being **ready for deployment to production** (continuous delivery) or being **installed in production** (continuous deployment).

Note:
> Every commit to a specific branch (e.g., master) is moved through a **fully automated process** that results in a new release being ready for deployment to production (continuous delivery) or being installed in production (continuous deployment).

The key words in that sentence are "**fully automated process**".


<!-- .slide: data-background="../img/background/continuous-deployment.png" -->
> There is no place for humans after a commit to the master branch

Note:
> There is no place for humans after a commit to the master branch.


<!-- .slide: data-background="img/assembly-cd-01.png" data-background-size="contain" -->

Note:
Whatever manual work has to be done, it needs to be done before the pipeline starts. There should be some tests, so write them in advance. There should be some modifications to the deployment script, write it in advance. And so on and so forth. Because the moment a developer pushes new code, all manual work related to it must be finished. If you do not feel you can do your job in that fashion and that you cannot be proactive, then maybe you should step down and let others take over. Or admit your deficiencies and learn how to operate in this new world.

The only way to be effectively proactive during this "creative" stage is to define everything as code. Tests must be expressed as code, infrastructure needs to be defined as code, deployments need to be written as code, and so on and so forth.


<!-- .slide: data-background="../img/background/continuous-deployment.png" -->
> Be proactive with "**everything as code**" is the new mantra.

Note:
> Be proactive with "**everything as code**" is the new mantra.

Enough time passed for us to realize that there is no place for non-coders in the software industry. If you work with software, you code. It does not matter whether you are the "Jack of all trades" or you are specialized. Whatever you do, be it testing, developing, deploying, monitoring, or any other type of tasks, you have to write code. That's the reality of today's market, and if you do not think that you can do that, you can still change your calling.


<!-- .slide: data-background="../img/background/continuous-deployment.png" -->
> It's never too late.

> There's still time to change your profession and become a doctor, a lawyer, or a truck driver.

Note:
> It's never too late.

> There's still time to change your profession and become a doctor, a lawyer, or a truck driver.


<!-- .slide: data-background="img/assembly-cd-02.png" data-background-size="contain" -->

Note:
During this creative pre-commit phase, we use tools that are entirely different than the tools used during the pipeline. I do not care whether that's IntelliJ, VS Code, Vi, Eclipse, MS Project, or any other tool through which you use the creative side of your brain. As long as you do the job in advance, you're being proactive. If you can express your work through the code, you're doing fine.

I almost forgot one crucial piece of the story. You need to finish whatever you have to do before a new commit is pushed to the master branch.


<!-- .slide: data-background="img/assembly-cd-03.png" data-background-size="contain" -->

Note:
All those of you that were involved in manual processes during the latter phases of the software lifecycle need to move to the left or move out. You need to learn how to be proactive and do the work in advance. We do not have time to wait for you. Lean time is not acceptable anymore, nor it is allowed just to throw things over the wall to others. Those days are gone, and now we are expected to deliver fast (often multiple times a day). Such speed cannot be accomplished if there are **human blockers** in the process.


<!-- .slide: data-background="img/assembly-cd-04.png" data-background-size="contain" -->

Note:
Once the pipeline starts, machines take over. A pipeline executed through one of the CD platforms (e.g., Jenkins) will use a completely different set of tools than those you used during the creative phase. Those can be SonarQube, Selenium, Kubernetes, Docker, VMWare, Git, and many others. What they all have in common is that they do not require humans (in this phase) and that they have to do something. That "something" can be many things, and the only important factor is their exit code. Each step is either successful, and the pipeline moves to the next one, or it fails, and the execution of the pipeline stops. There is no gray area. There is no space for "we use SonarQube, but we do not fail builds when certain thresholds are reached." The result of an execution of a pipeline is black or white.


<!-- .slide: data-background="img/assembly-cd-05.png" data-background-size="contain" -->


<!-- .slide: data-background="img/assembly-cd-06.png" data-background-size="contain" -->


<!-- .slide: data-background="img/schrodinger-cat.jpg" data-background-size="contain" -->
> Continuous delivery builds are like **Schrodinger's cats**.

Note:
> Continuous delivery builds are like **Schrodinger's cats**.

While the builds are running (the cat is in the box), the result can be considered both success or failure (the cat can be dead or alive). Only when we open the lid (receive notifications) can we know the outcome. Or, to be more precise, we hear just about dead cats. No notifications are telling us about those who survived, only about those that failed.