**Q:** Developers should take what steps after they discover a critical error? For instance, what's the first thing they should do?

**A:**

There is no need to use the word *critical* in that question. Assuming that we are discussing errors found during a continuous delivery process, there is nothing more important for a developer than to fix the mistake (no matter its impact). If we are applying continuous delivery (or deployment) processes, that error will be found shortly after a developer committed changes. Everything he did is still fresh in his mind and fixing the problem should be, in most cases, trivial. The more we postpone the work on the fix, the more time it will take.

Two important things come into play and translate into a cost.

The first cost is context switching. It is a very expensive operation. Every time we start working on a new context, we need time to prepare. We need to understand the new context, we need to make a plan, we need to figure out what will be the best approach, and so on and so forth. Those are actions actions required before we start being productive and coding. Most of those steps need to be repeated every time we change the context. Let's say that, on average, we need 15-30 minutes to get situated and become productive (again). Every time we change our focus, that time is lost.

Context switching is inevitable. Every time we start working on a new feature, we have to make a switch. However, even though we cannot avoid it, it does not mean that we cannot reduce it. The best way to prevent context switching is to not to do it more often than needed. Fixing a failed test before moving to the new feature is one way to stay focused on the task at hand. A feature is not done when it's committed but when it's working as expected.

The second cost is related to the time we need to find the cause of a problem and fix it. If we start correcting an error that was produced by a commit we did minutes ago, we will probably spend a negligible time working on it. After all, how much time a developer needs to correct an issue he created a few moments ago? As time passes, memory fades, and we need an increased amount of time to remember what we did and figure out how to fix the problem. In other words, the time required to correct a problem is directly proportional to the time that passed since the problem was created.

Fixing a problem as soon as it is detected is only a part of the solution for an optimum CD process. If a pipeline takes hours to execute, by the time an error was detected, we will be already deeply immersed into a new feature. The switch is already made, and we do not want to stop bashing the code that defines that feature. That's why it is paramount that a CD pipeline executes fast. The ideal time required to run a pipeline should be equivalent to what it takes us to get up from our desk, grab a coffee, and, maybe, have a short chat with a colleague or two. Just enough to clear our minds before we start working on the next bing thing. By the time we reach our desk, an email should be in our inbox notifying us that there's something wrong with what we did. If it is there, we should fix the problem. If there isn't one, we can start working on something else.

That does not necessarily mean that the whole pipeline should execute in only 15-20 minutes (time to get a coffee and come back). There are often some longer running tests (e.g. performance, all combination of browsers, and so on). However, problems found in those stages are most of the time found in other types of tests as well. Assuming that the pipeline is designed to fail fast and as soon as a problem is detected, later stages rarely discover an issue.

Some errors are not caught by a CD pipeline. As an example, a user might report a problem that could not be found by automated tests. Similar rules apply in those cases as well. It is pointless to work on a new set of features when those that are in production are not functioning properly. Such a situation is one of the arguments for continuous deployment. Deploy often, detect production problems quickly, and fix them.

Errors are like diseases. Every doctor will tell you that the best medicine is prevention, followed by early detection of a disease. Software errors are the same. Make sure that you have a continuous delivery (or deployment) process in place. When done properly, it will detect most of the issues before they reach production (equivalent to prevention). Have a good monitoring and alerting system in place that will try to correct the problem automatically (equivalent to self-healing). If a problem cannot be fixed automatically, act swiftly and fix it yourself (equivalent to going to a doctor at the first sign of an illness that your body could not resolve). When errors are left unattended, they tend to spread and mutate (just like viruses).

**Q:** What's something a developer shouldn't do when finding an error?

**A:**

A developer should not do anything but fix the error. It does not matter whether he reveals the exploit on Hacker News, tweets about it, reports it on CNN, puts it on WikiLeaks.com, or does anything else, as long as the error is fixed first. There's no harm if the information about the problem is out after that issue is gone. In other words, a developer can do whatever he wants as long as the error is fixed before anything else. Such an attitude poses particular problems if we're developing applications for desktop or mobile devices. While you can, and should, in such a case fix problems as soon as they are detected, please do not post them on Hacker News since not all users will get the new release fast enough.

**Q:** How bad is it if a developer discovers a fatal error? What does that mean for the company or for development?

**A:**

If a developer discovers a fatal error, he should be rewarded. That means that the company found an issue before its users faced it. If we are fast enough, we can fix an internally discovered problem before our users start experiencing it. Still, more often than not, fatal errors are not found internally. If they are, it usually means that we do not have a good set of automated tests and that our iterations are not small enough.

When found by users, fatal errors can destroy company reputation and business. On the other hand, there are examples when companies converted those errors into an asset. One of the recent examples comes from GitLab. Early this year, they faced one of those fatal errors that can easily destroy a company. However, they handled it with full transparency and, throughout the process, gained respect from the community. I think that they successfully converted potential a business loss into a gain.

**Q:** What are some tips to best get things done? What are some best practices for developers?

**A:**

I think that the best practice is not to follow anyone's best practice blindly. Way too often, we get stuck trying to apply a process that does not fit the team and the product it is developing. Even when you do find the best practice that makes sense, the chances are that it will become obsolete shortly afterward. Our industry changes so often that whatever was the best practice today, might not be valid tomorrow. Do what makes sense and make your own decisions. The only thing that matters is that those decisions are based on enough practice. That leads to me one "best practice" that will not become obsolete any time soon. Make sure that everyone has sufficient time to experiment. Dedicate a day every week to unstructured and open innovation and exploration of new practices and tools. That will lead to things you did not even know exist and will end up as a best practice. Do not make company-wide decisions nor enforce strict rules. Let developers choose their own paths and let them change directions as often as they want. You'll be surprised how many great practices will come.

**Q:** When you work with teams globally, does that create additional challenges?

**A:**

That depends on software architecture and organization of your teams. If a team is in charge of a whole service and its size is relatively small (up to eight people), it does not matter much whether some other team is located on the other side of the globe. Such teams need to be self-sufficient, and that's where microservices come into play. Each team can develop their own service(s) without being coupled with those developed by other teams. On the other hand, if teams are split horizontally (e.g. one team with developers and the other with testers), separation can introduce huge penalties. Such a horizontal separation is unproductive even when teams are in the same location. Geographical separation only increases the lean time and degrades communications.
