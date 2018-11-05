<!-- .slide: data-background="../img/background/agile.jpg" -->
# Agile & DevOps

---

Note:
After a lot of misery and suffering introduced through Waterfall, we got Agile and, later on, DevOps. The idea is simple, even though the two implemented it differently. Form a small and self-sufficient team capable of delivering a new set of features in each short iteration. The time of delivery changed from months, or even years, to weeks, and sometimes even days or hours.


<!-- .slide: data-background="../img/background/agile.jpg" -->
> The significant difference between Agile and DevOps is that the former forgot to invite experts from the second half of the software development lifecycle.

Note:
> The significant difference between Agile and DevOps is that the former forgot to invite experts from the second half of the software development lifecycle.

Even though that was never officially prescribed, Agile teams forgot that they do need operational, infrastructure, and maintenance knowledge if they are to deliver features "for real". They would often say, "we're finished, and we are moving into the next sprint", even though there was a lot of work left to be done by others. DevOps remedies that by trying to form genuinely self-sufficient teams that are in charge of everything, from requirements to deploying to production and maintaining software. Nevertheless, I'll assume that both types of teams are the same for the rest of this narrative.


<!-- .slide: data-background="../img/background/agile.jpg" -->
> The only way to say that something is done is to run it in production successfully. Everything else is faking the status.

Note:
> The only way to say that something is done is to run it in production successfully. Everything else is faking the status.

Those self-sufficient teams decided that iterations should be short (e.g., weeks, or even days), so they had to move fast.


<!-- .slide: data-background="img/assembly-agile-01.png" data-background-size="contain" -->

Note:
Analysists (product owners?) would come up with the requirements for the upcoming sprint and pass it to developers.


<!-- .slide: data-background="img/assembly-agile-02.png" data-background-size="contain" -->

Note:
Developers would write their code and give it to testers.


<!-- .slide: data-background="img/assembly-agile-03.png" data-background-size="contain" -->


<!-- .slide: data-background="img/assembly-agile-04.png" data-background-size="contain" -->

Note:
Testers would move it to operators.


<!-- .slide: data-background="img/assembly-agile-05.png" data-background-size="contain" -->

Note:
Operators would deploy to production and leave it to maintainers. Each of those handovers could fail, and when that happens, the process must start over.

The problem with that process is that it is not fundamentally different from the Waterfall, except that an iteration shrank from months or years to weeks or days. 


<!-- .slide: data-background="../img/background/agile.jpg" -->
> The problem of coupling creative design work with repetitive tasks of an assembly line often exists no matter whether you're using Waterfall or Agile processes.

Note:
> The problem of coupling creative design work with repetitive tasks of an assembly line often exists no matter whether you're using Waterfall or Agile processes.

There is no place for creativity in an assembly line. Ask any factory worker, and you'll get the same response. Assembly line is supposed to be fast and reliable, and we accomplish that through repetition. If a worker in a factory would stop to think whether he liked the color of the new car or if it should be better with a slightly lighter shade, the whole process would break. That does not mean that a worker cannot stop the assembly line. It can (at least those in Toyota), but only if there is an issue that prevents repeatability and quality of the outcome of production, not design.

The result of applying some of the assembly line processes is continuous delivery or continuous deployment.