<!-- .slide: data-background="../img/background/waterfall.jpg" -->
# Waterfall
# Assembly Line

---

Note:
A long time ago in a galaxy far, far away, someone came up with a brilliant idea. "Why don't we do the same thing as manufacturing. We'll design a linear process that will be bullet-proof and will result in high-quality software being delivered to our customers fast." Now, for the sake of clarity, the idea came from Winston W. Royce as a description of a flawed, non-working model. But, be it as it may, we adopted it nevertheless, and we started calling it the Waterfall process. So, how does it work?

The process, in spite of some variations, is linear.


<!-- .slide: data-background="img/assembly-waterfall-01.png" data-background-size="contain" -->

Note:
Analysts figure out what users need. 


<!-- .slide: data-background="img/assembly-waterfall-02.png" data-background-size="contain" -->

Note:
They write specifications and give them to developers. They write code that makes those requirements a working software.


<!-- .slide: data-background="img/assembly-waterfall-03.png" data-background-size="contain" -->

Note:
Developers, in turn, are not to be trusted, so they pass it on to testers that validate the software against the requirements.


<!-- .slide: data-background="img/assembly-waterfall-04.png" data-background-size="contain" -->

Note:
Once testers are finished, they deliver it to operators, who install that software in production.


<!-- .slide: data-background="img/assembly-waterfall-05.png" data-background-size="contain" -->

Note:
Just to be on the safe side, the last stage is maintenance. Just as cars sometimes malfunction, our software often contains some undesirable effects which are fixed after its delivered to its users.


<!-- .slide: data-background="img/assembly-waterfall-06.png" data-background-size="contain" -->

Note:
The whole process would take only a couple of years or, if we're very good at our jobs and very lucky, sometimes just months.


<!-- .slide: data-background="../img/background/waterfall.jpg" -->
# That NEVER Worked!

---

Note:
The major problem with the Waterfall process and its assembly line is that **it never worked**. And yet, we were repeating it over and over again. We do a project, and it fails either by not having sufficient quality, or by being more expensive, or by missing deadline (by months or years), or (the most common outcome) by not delivering things that users want. The first project would fail, and we'd to the second using the same process. When the second failed, we did the third. And so on and so forth, until we retire. Every once in a while, we would be successful. But, those were either exceptions or we'd "fake" the plan to make sure that it works. By fake, I mean double the estimates and rewrite the requirements so that we can say "look, we delivered on time, and it's what you want." **What users wanted was in most cases not what users needed.**

We were not learning from our mistakes. The process was flawed and even when a project was considered a success, that was usually because we did not follow the process. When I look back at those times, I can only conclude that we were all insane. At least, according to Einstein.


<!-- .slide: data-background="img/einstein.jpg" data-background-size="contain" -->
> "Insanity Is Doing the Same Thing Over and Over Again and Expecting Different Results"
> -- Albert Einstein

Note:
> "Insanity Is Doing the Same Thing Over and Over Again and Expecting Different Results" -- Albert Einstein


<!-- .slide: data-background="../img/background/waterfall.jpg" -->
> We are not producing cars where an error in design results in thousands of faulty cars being delivered and never to be fixed.

Note:
There were quite a few problems with the whole process. First of all, the duration. We cannot expect to work on something for months or even years before we deliver that something. Remember, we are not manufacturing identical copies.

> We are not producing cars where an error in design results in thousands of faulty cars being delivered and never to be fixed.


<!-- .slide: data-background="../img/background/waterfall.jpg" -->
> We are delivering bytes that can change whenever we want and that can be re-delivered to all users in no time.

Note:
> We are delivering bytes that can change whenever we want, and that can be re-delivered to all users in no time.


<!-- .slide: data-background="../img/background/waterfall.jpg" -->
> It was impossible to make the process linear.

Note:
> The second reason for the failure of the waterfall process is that it was impossible to make it linear.

We cannot expect analysists to know in advance all the features users want. We couldn't expect developers to work for months without producing bugs or, more importantly, not to make mistakes from the start and, at the end of their work, to expect them not to go back to the beginning due to those mistakes. Testers were supposed to confirm that our software works flawlessly, and not to return with hundreds or thousands of bug reports and misinterpreted requirements. If that was not our expectation, why were testers involved only after developers produce months or years of faulty software? It gets worse. After the testing stage, we'd give it to operators, only to discover that, after the software is deployed, it does not work correctly and it needs to go back to developers and, consequently, to testers. Finally, if the system worked well, why did we have months of maintenance? We do not return cars because there is no wheel in them, but because there is a problem caused by driving thousands of kilometers.


<!-- .slide: data-background="img/assembly-waterfall-07.png" data-background-size="contain" -->


<!-- .slide: data-background="img/assembly-waterfall-08.png" data-background-size="contain" -->


<!-- .slide: data-background="img/assembly-waterfall-09.png" data-background-size="contain" -->


<!-- .slide: data-background="img/assembly-waterfall-10.png" data-background-size="contain" -->

Note:
Even though the Waterfall process tried to create an equivalent of the manufacturing assembly line, it went into the opposite direction. If anything, the Waterfall is closer to slave labor. **You have tight control over everything and everyone, the process is mostly manual, and everyone dislikes you.** The waterfall is equivalent to pre-industrial revolution. Or, to find an even better parallel, to the way Egyptians built pyramids.


<!-- .slide: data-background="../img/background/waterfall.jpg" -->
> The process to build pyramids: a lot of managers overview the workforce working on implementing a multi-year plan that is likely going to be delayed, to require more slaves, or to crumble.

Note:
> The process to build pyramids: a lot of managers overview the workforce working on implementing a multi-year plan that is likely going to be delayed, to require more slaves, or to crumble.

There was no incentive for automation, and therefore, for an assembly line. Everything could be fixed by finding more people to work.

This brings me to the main problem.
