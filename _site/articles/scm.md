**Q:** What is SCM and has the process of SCM changed at all in recent years?

SCM (short for Software Configuration Management) is a set of practices, backed by tools, which allow us to track and control changes introduced to software.

Typically, developers would checkout code from an SCM tool, make modifications, and push those changes back. In many cases, those changes would be pushed to a branch (a copy) and, when the time comes to release the software (or immediately afterward), that branch would be merged to master (primary copy).

In recent years it became apparent that Git is the tool to rule them all. As a result, many of the companies switched from their previous SCM choice to Git. Those few that are still using one of the other tools (e.g. SVN, CVS, Perforce, and so on) are most likely planning to switch to Git soon.

With the adoption of Git, we got the adoption of different practices when working with SCM tools. Forking a repository and creating pull requests is becoming a norm. If branches are used, their lifespan is much shorter than it was before Git. Distributed repositories are allowing teams to communicate much better and work more efficiently.

**Q:** How does SCM fit in with continuous delivery and DevOps?

SCM is the initiator of continuous delivery processes. It all starts with a change in SCM and ends in production. Every commit would trigger a build in one of the CD tools which would initiate the tasks that lead to software being deployed to our production clusters. That trigger is what makes the process continuous. Without it, we would be delivering periodically and could just as well call it *eventual delivery*.

One of the changes that CD brought is that there is an increasing number of companies that are abandoning branches and committing code directly to master. That, on the first look, sounds like a step back. It took as many years to convince everyone that a good branching strategy is a must in every software development company. Working without branches was too risky due to conflicts and potential bugs that would be introduced through commits. Now we (proponents of continuous delivery and deployment) are telling those same teams that they should commit directly to master. What changed? Why was that a bad practice yesterday and it's a good practice today.

The difference is in the processes that are initiated on every commit. CD, together with microservices adoption and the ideas behind immutable deployments, allows us to have a robust set of automated pipeline steps that can provide a reasonable guarantee that a commit that passed them all is ready to be deployed to production. By committing to a master branch we have a truly continuous process and, as a result, the time between a feature being developed and its deployment to production is reduced to an absolute minimum. Time to market was never shorter, and it is not uncommon for an organization to have tens or even hundreds of deployments every day. The flexibility and the power behind Git is one of the essential pieces that allowed us to reach this speed.

DevOps, on the other hand, depends heavily on automation with CD being one of the main driving factors behind it. The three (Git, CD, and DevOps) are almost indispensable. There is no CD without an SCM (and Git is the SCM tool of choice), and there is no DevOps without automation (and CD is the culmination of automated processes).

**Q:** Is Git the end all tool or are there other SCM tools out there that developers use?

Git is the only tool that matters today. Nobody questions it anymore. Instead, the debate is which flavor one will choose. Will it be GitHub, GitLab, Bitbucket, or something else? All of those tools use Git as a backend and most of the differences are in the user interfaces.

Git managed to accomplish something that very few did before. It became the de-facto standard and threw all other SCM tools into oblivion. That does not mean that others are still not used. They are. For example, quite a few companies are still running SVN. However, that is almost never by choice but because of their inability to modernize infrastructure and a fear of change.

**Q:** How does your company orchestrate the whole SCM process?

CloudBees is developing Jenkins, the most popular continuous delivery (CD) tool in the market. It is only natural that we practice CD ourselves with Git being an integral part of it. Since every CD process is triggered by a commit to SCM, it's only natural that our processes are following the same pattern. Every piece of code we develop is stored in Git. Each of us works on a fork, commits changes, and creates a pull request. We are firm believers in code reviews as a process that allows us not only to ensure quality but also as a way to share the knowledge. Therefore, each of the pull requests is reviewed (often within an hour) and merged to the original repository. From there on, GitHub triggers Jenkins pipeline and initiates a continuous delivery process.

**Q:** Why is SCM important?

SCM is important because it is the only effective way to allow teams to work on the same code. Without SCM, we would not be able to work on our laptops but would need to develop code stored in a central server. Without it, we would need to coordinate among ourselves so that only one person would work on the same file. Without SCM code reviews would be too expensive, and we would not have a history of all the changes.

SCM is arguably the only common thing all developers have and Git is the tool that rules the market. We are often arguing whether there is value in TDD, whether to adopt microservices, which tool to use to track our tasks, and so on and so forth. The only thing no one argues about is whether to use an SCM (we all do).

**Q:** Anything additional? Are there any areas of SCM you suggest SD Times focuses on?

No