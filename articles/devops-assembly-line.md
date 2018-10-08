# Managing And Maintaing DevOps Assembly Line

Let's start with setting the record straight. There is no such thing as **DevOps Assembly Line**. I invented it by replacing **Software** with **DevOps**. Why did I do that? Because everything needs to put the word DevOps to be popular. Saying software assembly lines is boring. It sounds like something you already know, or at least you heard or it. Nevertheless, everything changes, and software assembly lines are not an exception. So, in the spirit of self-marketing, the title contains **DevOps** as a way to attract your attention. Still, from now on, I'll call it what it is. It'll be **software assembly line**.

## What Is (Software) Assembly Line?

To understand software assembly line, we need to understand manufacturing assembly line first. After all, we (software industry) based a lot of our practices on manufacturing industry. That is terribly wrong, but that's where most of us are, so let's see what does it mean in manufacturing.

Manufacturing assembly line can be described with the sentence that follows.

> "Manufacturing process in which parts are added in sequence until the final assembly is produced."

That sounds straightforward. Actually, it's so easy to understand that many thought that should be the way to assemble software. Add the parts in sequence from gathering requirements, all the way until it's deployed to production. Yippee! We got a process.

The problem is that manufacturing process differs from software development in one key aspect.

> "The goal of the manufacturing assembly line is to mass-produce a product with the same specifications and quality."

We do not have such goals. We are trying to produce a **single** product with a **repeatable process**. We do not make many copies of the same product (excluding those still delivering CDs and floppy disks to their desktop customers). At least, not in a physical form.

Every release is a different product. If that's not your case, and if you do make the same release over and over again, you are probably confused and choose the wrong industry.

All that is not to say that there is nothing to be learned from manufacturing assembly line. It features a repeatable process. Our processes should be repeatable as well. However, almost every manufacturing assembly line involves automation and manual labour. Ours should because we do not deal with physical world (everything are bytes). We can have a truly automated process, after the creative tasks end. And that leads me to yet another very important difference.

In manufacturing, considerable investment in time, people, and money goes into manufacturing while the design is usually much cheaper. We do, for example, need to design a car, but that is only a fraction of the cost. Producing it is where the real expense lies. In sooftware, design is almost entire cost of a release. Now, I need to clarify that by design, I want to say creative and not repeatable work that involves not only brainstorming of a solution, but also coding. Every feature we deliver is a result of a huge effort in creative tasks, and almost no effort to move it (after a committ) through the assembly which, in this context, means building, testing, deploying, and other repetitive tasks. At least, that's how it should be, even though in many cases its not.

We tend to employ an army of people dedicated to work manually on repetitive tasks (e.g., manual testing, deployments, etc). That is, kind of silly given that we are in business of writing software that does things and helps others in their daily lives. And yet, we are somehow better at creating software for others, than software that will help us.

But, I might have moved too fast. Let's go back in history and find out how we got where we are, and where should we go next.

## Waterfall Assembly Line

A long time ago in a galaxy far, far away, someone came up with a brilliant idea. "Why don't we do the same thing as manufacturing. We'll design a linear process that will be bullet-proof and will result in high-quality software being delivered to our customers fast." Now, for the sake of clarity, the idea came from Winston W. Royce as a description of a flawed, non-working model. But, be it as it may, we adopted it nevertheless and we started calling it waterfall. So, how does it work?

The process, in spite some variations, is linear. Analysts figure out what users need. They write specificatins and give them to developers. They write code that make those requirements a working software. They, in turn, are not to be trusted, so they pass it on to testers, that validate the software against the requirements. Once testers are finished, they deliver it to operators, who install that software in production. Just to be on the safe side, the last stage is maintenance. Just as cars sometimes mallfunction, our software often contains some undersirable effects which are fixed after its delivered to its users. The whole process would take only a couple of years or, if we're very good, sometimes only six months.

The only problem with the Waterfall process and its assembly line is that **it never worked**. And yet, we were repeating it over and over again. We do a project, and it fails either by not having sufficient quality, or by being more expensive, or by missing deadline (by months or years), or (the most common outcome) by not delivering things that users want. The first project would fail, and we'd to the second using the same process. When the second failed, we'd do the third. And so on and so forth until we retire. Every once in a while, we would be successful. But, those were either exceptions or we'd "fake" the plan to make sure that it works. By faking, I mean double the estimates and rewrite the requirements so that we can say "look, we delivered on time, and it's what you want". **What users wanted was in most cases not what users needed.**

We were not learning from our mistakes. The process was flaved and even when a project was considered a success, it was only because we did not follow the process. When I look back at those times, I can only conclude that we were all insane. At least, according to Einstein.

> "Insanity Is Doing the Same Thing Over and Over Again and Expecting Different Results" -- Albert Einstein

There were quite a few problems with the whole process. First of all, the duration. We cannot expect to work on something for months, or even years, before we deliver that something. Remember, we are not manufacturing identical copies. We are not producing cars where an error in design results in thousands of faulty cars being delivered and never to be fixed. We are delivering bytes that can change whenever we want and re-delivered to all users in no time.

The second reason for the failure of the waterfall process is that it was impossible to make it linear. We cannot expect analysists to know in advance all the features users want. We couldn't expect developers to work for months without producing bugs or, more importantly, not to make mistakes from the start and, at the end of their work, to expect them not to go back to the beginning due to those mistakes. Testers were supposed to confirm that our software works flawelessly, and not to return with hundreds or thousands of bug reports and missinterpreted requirements. If that was not our expectation, why were testers involved only after developers produce months or years all the faulty software? It gets worse. After the testing stage, we'd give it to operators, only to discover that, after the software is deployed, it does not work correctly and it needs to go back to developers and, consequenty, to testers. Finally, if the system worked well, why did we have months of maintenance? We do not return cars because there is no wheel in them but because there is a problem caused by driving thousands of kilometers.

This brings me to the main problem.

## The Tools Used In Software Development


