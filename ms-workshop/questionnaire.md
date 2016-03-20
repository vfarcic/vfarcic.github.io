* **Why did you start using microservices?**

I started using microservices out of frustration. That frustration was generated from continuous failures to implement some of the practices I was proposing. We tried to have a good test coverage and failed. We attempted to implement continuous integration and, later on, continuous delivery, and failed. We sought to have short release cycles, and failed. We tried to create immutable deployment and failed. We decided to split the horizontal teams vertically and make them small and agile. That failed as well. In retrospective, the list of my failures is much bigger than the list of my successes. At one moment I realized that the root of the problems were not development, testing, and release practices but architecture. The problem was in monolithic architecture. I won't say that good development practices (for example XP) cannot be applied to monoliths. They can, but, more often than not, the results are sub-optimum. My switch to microservices was motivated by the desire to implement better development practices.

* **What is the most important benefit of microservices?**

There are many so I'll just name the first few that come to my mind.

Innovation is probably on the top of my list of benefits. When you have a big monolithic application that was in development for a long time, changing it is a nightmare. Repercussions of a wrong decision can be so significant that many choose to stick with what they have. On the other hand, microservices allow us to change things fast and with a limited impact on the system as a whole. Shall we experiment with GoLang? Why not? Choose a small single service, rewrite it, and evaluate the result. If we are to develop a new feature as a new microservice, we might choose NodeJS and MongoDB even though most of the system is written in Java and MariaDB. After all, if for a particular case NodeJS seems like a better fit, why shouldn't we go for it? Microservices allow us to change things and experiment with new languages and frameworks. Change is the major motor behind innovation and innovation is driving change. Monoliths are too big and often too coupled to allow such freedom.

Some of the other arguments for microservices is the ability to have small autonomous teams, the speed of delivery, true decoupling, scalability, fault tolerance, and so on.

* **Have microservices helped you achieve your goals?**

That depends on the point of view. In some projects microservices helped me accomplish my goals much faster, innovate, and apply XP practices. In others, rejection to move to microservices architecture helped me realize that it is time to move on, and switch to another company. I know that it might sound silly that one leaves a company because it is developing monolithic applications. However, the problem lies beyond the types of applications. Usually such companies tend to have an organizational structure that is equally monolithic (inflexible, centralized, hierarchical, split horizontally, and so on). Monoliths are a reflection of the type of the organization that develops it.

* **What do you think should be the optimal size of a microservice?**

I do not believe there is an answer to that question. There are cases when a microservice is not bigger than a hundred lines of code and others with thousands. Sure, a microservice is smaller than a monolith but it's not the size that matters. What truly distinguishes architecture based on microservices is their decomposition and the size of the team that can maintain it. If what you developed is fulfilling a single purpose, can be managed by a single small team, is completely decoupled from other services, is self-sufficient, and it can be deployed independently from the rest of the system, then your microservice is just the right size. I'm trying to stay away from absolute statements. There is no formula that says that microservices should be between X and Y lines of code.

* **What is the biggest challenge of microservices?**

The major challenge is best described through Conway's Law.

> Organizations which design systems ... are constrained to produce designs which are copies of the communication structures of these organizations.
>
> — M. Conway

Monoliths are reflections of organizations that created them. Switching to microservices architecture without changing organization will result in a failure. Since microservices become popular, everyone wants them, but only a few are willing to apply changes required for a successful transition. The fundamental challenge does not lie in technology but in culture. We can take a look at Linux, as the oldest example of a successful implementation of microservices model (at least the oldest I'm aware of). The whole OS is based on microservices. It consists of a vast number of small and autonomous programs (microservices) that have a clearly defined input and output (API). Most of those programs can be changed, updated, or replaced without bringing down the whole system. The complexity is accomplished through a combination of many small programs. Take a look at the organization behind it. It is open source. Chaotic (on a first look), decentralized, in most cases formed out of many small teams in charge of particular parts of the system. Now, compare that with organizations behind monolithic applications. In most cases, you'll notice that they appear less chaotic, that they are more centralized, and that they are made by much bigger teams which are, often, organized horizontally.

* **What technology do you think is the most important as far as microservices are concerned?**

The most important technology is, without a doubt, containers. To be more precise, Docker. Containers are nothing new. They existed for a long time. However, without Docker, containers are, often, too complicated to implement. Without containers, microservices often produce more problems than value. Without self-sufficiency and immutability, microservices tend to produce too many, often conflicting, dependencies. Many struggle with deployments of a single application. Deploying hundreds, or even thousands of microservices, exponentially multiplies the operational effort. Before Docker, the solution was to deploy each microservice as a separate VM. However, that creates additional cost in infrastructure since each VM carries additional overhead in resource usage. It is not a coincidence that the interest in microservices increased with the appearance of Docker.

* **How much do microservices influence an organization? Can they leave the organization unchanged?**

Adopting microservices must be followed with changes in organization. One does not go without the other. Centralized organization with teams organized horizontally will fail to adopt microservices. With a risk of repeating myself, I will, again, quote Conway.

> Organizations which design systems ... are constrained to produce designs which are copies of the communication structures of these organizations.
>
> — M. Conway

* **When should you not use microservices?**

You should not use microservices when they do not bring additional value. No solution fits all cases. I cannot tell you a rule that states in which situations microservices are a good fit, and in which they aren't. The decision depends on many factors; maturity of the team(s), organizational structure, type of the application, and so on.

* **What principles should guide you in the division of an application into microservices?**

The most important thing to understand when dividing an application into microservices is that the division should not be based on technology. Monolithic applications are divided in horizontal layers based on technological decisions. We have the data access layer separated from the business logic layer, that is split from the user interface layer, and so on. The primary way we were dividing applications in the past was based on technological decisions. Microservices divide the system horizontally. An application should be split into microservices based on functional criteria. It should be separated from the others vertically and communicate with the rest of the system through clearly defined APIs. Domain Drive Design is an excellent starting point when brainstorming how to split an application.

* **Should every microservice be written in the same language or is it possible to use more languages?**

I think that the question is misplaced. One of the requirements of successful implementation of microservices architecture are small and autonomous teams in charge of the whole lifecycle of a microservice. If that team is truly independent, it will decide itself in which language to write the microservice. That decision might coincide with the decisions made by other teams, or it may not. Many factors will influence those decisions. Are all developers proficient in only one language or they are multilingual? Ideally, we should pick the best tool for the job. One language might be more suited for system services while the other might shine as the weapon of choice for the backend. We might choose GoLang because of the size of its binaries and concurrency, Scala for its streaming capabilities, and JavaScript because of its dynamic nature. However, having the best tool for the job does not mean that we know how to use it. Personally, I like diversity in almost anything, including programming. I do think that someone can be considered a good programmer without knowing how to code in multiple languages. On the other hand, every team is different, and we should leverage their existing skills. My suggestion is to give your teams as much autonomy as possible. Whether that will result in all services being written in the same language or each will be different is of lesser importance.

* **What aspects should you take into consideration before using microservices?**

Do not make a decision to go for the big bang approach. Do not try to change the whole monolith into microservices in one go. Microservices are much harder than they look and you are likely to make many mistakes. Start small, make mistakes, learn from them, improve, repeat. Do not expect to do it right from the first attempt. Embrace containers, form small autonomous teams, invest in DevOps practices, automate, automate, and automate.