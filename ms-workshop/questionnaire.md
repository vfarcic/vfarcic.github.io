* **Why did you start using microservices?**

I started using them out of frustration. That frustration was generated from continuous failures to implement some of the practices I was proposing. We tried to have a good test coverage and failed. We tried to implement continuous integration and, later on, continuous deplivery, and failed. We tried to have short release cycles, and failed. We tried to create immutable deployment and failed. We tried to split the horizontal teams vertically and make them small and agile. That failed as well. In retrospective, the list of my failures is much bigger than the list of my successes. At one moment I realized that the root of the problems were not development, testing, and release practices but architecture. The problem was in monolithic architecture. I won't say that good development practices (for example XP) cannot be applied to monoliths. They can but, more often than not, the results are sub-optimum. My switch to microservices was motivated by the desire to apply better development practices.

* **What is the most important benefit of microservices?**

There are many so I'll just name the first few that come to my mind. Innovation is probably on the top of my list of benefits. When you have a big monolithic application that was in development for a long time, changing it is a nightmare. Repercussions of a wrong decision can be so big that many choose to stick with what they have. On the other hand, microservices allow us to change things fast and with a limited inpact on the system as a whole. Shall we experiment with GoLang? Why not? Choose a single, small service, rewrite it and evaluate the result. If we are to develop a new feature as a new microservice, we might choose NodeJS and MongoDB even though most of the system is written in Java and MariaDB. Why not do that if for that particular case NodeJS seems like a better fit? Microservices allow us to change things and experiment with new languages and frameworks. Change is the major motor behind innovation and innovation is driving change. Monoliths are too big and often too coupled to allow us such a freedom.

Some of the other arguments in favor of microservices is the ability to have small autonomous teams, speed of delivery, true decoupling, scalability, fault tolerance, and so on.

* **Have microservices helped you achieve your goals?**

That depends on the point of view. In some projects they helped me accomplish my goals much faster, innovate, and apply XP practiced. In others, rejection to move to microservices architecture it helped me realize that it is time to move on, and switch to another company.

* **What do you think should be the optimal size of a microservice?**

I do not think there is an answer to that question. There are cases when a microservice is not longer than a hundred lines of code and other with thousands. Sure, a microservice is smaller than a monolith but its not the size that truly matters. What truly distinguishes architecture based on microservices is their decomposition and the size of the team that can maintain it. If what you wrote is fulfilling a single purpose, can be maintained by a single small team, is completely decoupled from other services, is self sufficient, and it can be deployed independently from the rest of the system, then your microservice is just the right size. I'm trying to stay away from absolute statements. There is no formula that says that microservices are between X and Y lines of code.

* **What is the biggest challenge of microservices?**

The major challenge is best through Conway's Law.

> Organizations which design systems ... are constrained to produce designs which are copies of the communication structures of these organizations.
>
> — M. Conway

Monoliths are reflections of organizations that created them. Switching to microservices architecture without changing organization will results in a failure. Since microservices become popular, everyone wants them, but only few are truly willing to apply changes required for a successful transition. The key challenge lies not in technology but in culture. We can take a look at Linux, as the oldest example of a successful implementation of microservices model (at least oldest I'm aware of). The whole OS is based on microservices. It consists of a huge number of small and autonomous programs (microservices) that have a clearly defined input and output (API). Most of those programs can be changed, updated, or replaced without bringing down the whole system. The complexity is accomplished through a combination of many small programs. Now compare that architecture with the organization behind it. It is open source. Chaotic (on a first look), decentralized, in most cases, formed out of many small teams in charge of some specific parts of the system. Now, compare that with organizations behind monolithic applications and, in most cases, you'll notice that they appear less chaotic, that they are more centralized, and are made by much bigger teams, often organized horizontally.

* **What technology do you think is the most important as far as microservices are concerned?**

The most important technology is, without a doubt, containers. To be more precise, Docker. Containers are nothing new. They exist for a long time. However, without Docker, containers are, often, too complicated to implement. Without containers, microservices tend to produce more problems than value. Without self-sufficiency and immutability, microservices tend to produce too many, often conflicting, dependencies. Many struggle with deployments of a single application. Deploying hundreds, or even thousands microservices, exponentially multiplies the operational effort. Before Docker, the solution was to deploy each microservice as a separate VM. However, that creates an additional cost in infrastructure since each VM carries an additional overhead in resource usage. It is not a coincidence that the interest in microservices increased when Docker's appearance.

* **How much do microservices influence an organization? Can they leave the organization unchanged?**

Adopting microservices must be followed with changes in organization. One does not go without the other. Centralized organization with teams organized horizontally will fail to adopt microservices. With a risk of repeating myself, I will, again, quote Conway.

> Organizations which design systems ... are constrained to produce designs which are copies of the communication structures of these organizations.
>
> — M. Conway

* **When should you not use microservices?**

You should not use microservices when they do not bring additional value. There is no solution that fits all cases. I cannot tell you a rule that states in which situations microservices are a good fit and in which they aren't. The decision depends on many factors; maturity of the team(s), organizational structure, type of the application, and so on.

* **What principles should guide you in the division of an application into microservices?**

The most important thing to understand when dividing an application into microservices is that the division should not be based on technology. Monolithic applications are divided in horizontal layers based on technological decisions. We have data access layer divided from business logic layer, that is separated from user interface layer, and so on. They primary way we were dividing applications in the past was based on technological decisions. It is horizonal division. An application should be split into microservices based on functional criteria. One microservice should be separated from the other vertically.  Domain Drive Design is a very good starting point when brainstorming how to split an application.

* **Should every microservice be written in the same language or is it possible to use more languages?**

I think that the question is misplaced. One of the requirements of successfull implementation of microservices architecture are small and autonomous teams in charge of the whole lifecycle of a microservice. If that team is truly autonomous, it will decide itself in which language to write the microservice. That decision might coincide with the decision of other teams or it may not. There are many factors that will influence those decisions. Are all developers proficient with only one language or the are multilingual? Ideally, we should pick the best tool for the job. One language might be more suited for system services, while the other shines as the weapon of choice for backend. However, having the best tool for the job does not mean that we know how to use it. Personally, I like diversity in almost anything, including programming. I do think that a good programmer knows how to code in multiple languages. Every team is different. My suggestion is to give them as much autonomy as possible. Whether that will result in all services written in the same language or each will be different is of lesser importance.

* **What aspects should you take into consideration before using microservices?**

Do not make a decision to go for the big bang approach. Do not try to change the whole monolith into microservices in one go. Microservices are much harder then they look and you are likely to make many mistakes. Start small, make mistakes, learn from them, improve, repeat. Do not expect to do it right from the first attempt. Embrace containers, form small autonomous teams, invest in DevOps practices, automate, automate, and automate.