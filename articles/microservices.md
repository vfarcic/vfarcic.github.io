## What are microservices and how do they work?

To understand microservices, one needs to understand monoliths first.

Most software today is made using monolithic architecture. We would decide what the application should do and than keep writing code that adds features we need. As the needs grow, so does the software we're developing. We keep adding more and more code to it, thus making it bigger and bigger. At the beginning, there is no substantial difference between monoliths and microservices. Everything starts small. We'd decide the architecture, design some layers so that there is a clear technical separation, and we start developing with a relatively small team. As the needs grow, so does the codebase and, with it, the team grows as well. Something that was manageable with, let's say 5 people, might need 15 the next year, and 40 the year after that. Before we know it, we might need tens or hundreds of developers and testers to develop new features and maintain those that were developed before.

The bigger something is, the more difficult it is to operate it. Airplane is more difficult to park than a bus which is still harder than a car. Nothing beats a motorcycle or a bicycle. The same applies to software. The bigger it is, the more difficult it is to maintain it.

When a team dedicated to a single application grows above eight, it stops being efficient. Thirty people (developers and testers combined) cannot work efficiently on the same project. They will clash with each other. They will depend on each others work. They will have to wait for others. A team with thirty people dedicated to a single application is not a software development team. It's a school reunion.

If the size of teams required to develop an application would be the only problem, we would solve it easily. But, it's not. Physics applies to everything. Big applications are slow to build, they are slow to test, slow to deploy, slow to debug, and so on. There's no escape from the slowness introduced by bigness.

If slowness is not enough, there are other issues as well. Take scaling as an example. If we discover that certain part of our application is too slow, the only solution is to scale everything. That does not fare well. It defies logic. That would be the same as if I'd invite guests for dinner. Let's say that I prepared everything for six people. When they come, I realize that one of the invites brought a friend. The more the merrier. Normally, that would mean that I'd bring another chair to the table. Now imagine that, silly as it may be, the chairs are glued to the table, and so are the plates, and the utensils, and the glasses. They all come in the same package. It's all or nothing. You either host six people or you host twelve. The only solution would be to purchase another set with a new table for six. To make things more complicated, imagine that the additional guest only came for a drink. He won't stay long. Still, he'll be placed in a separate room, he'll get a separate set of plates, and utensils, and glasses. He'll sit at the table set up for six people, all by himself. He only came for a drink and yet I had to multiply everything as if twelve people came, not seven. What I should have done is bring another chair, give him a glass, and pour him a drink. That's what should have happened if I had flexibility to mix and match things depending on my needs.

The same is true for software. If everything is constructed as one big monolith, the only way to scale a particular segment is to scale everything. That is far from efficient.

Microservices solve those, and quite a few other problems. By splitting applications into smaller chunks, we can have small and autonomous teams, each dedicated to a single service (or a few). They can move with their own speed without depending on others. Microservices are faster to build, to test, and to deploy. Their codebase is often small, easy to understand, and fast to debug. It'll scale well.

## Who is using microservices?

Amazon is one of my favorite examples. They have the saying "you build it, you run it". A single team is in charge of all aspects of a service. Those teams are fully autonomous and relatively small. They call them two pizza teams. The size of a team cannot exceed the number of people you can feed with two pizzas. Such teams could not do their work if the services they are developing (and testing, and deploying, and monitoring) are not small.

## What are the pros and cons of microservices?

The obvious advantage is size. Small things are easier to handle. Generally speaking, microservices build faster, are tested faster, are deployed faster, and are scalable (in the true meaning of that word). When compared with monolithic applications, the downsides are operational costs. Having many applications, potentially written in different languages, and with different system level dependencies, can easily add a huge operational overhead on infrastructure. However, that problem is mostly mitigated with the emergence of containers (Docker) and schedulers (Kubernetes, Swarm, Mesos). They are drastically reducing operational costs and thus making microservices much more appealing than they were before. It is no coincidence that the rise in popularity of containers is followed with the rise in microservices adoption. They complement each other very well and remove some of the obstacles of the other.

## What are the differences between SOA vs. microservices vs. monoliths?

There are no conceptual differences between SOA and microservices. They are based on the same principles. However, SOA became so perverted with time that the original intention behind them got lost. SOA became dominated with ESB tools that are, in my opinion, quite opposite from the original principles. ESBs make companies feel good when making decisions NOT to refactor their applications. It brings another layer on top of many others. It does not solve problems but buries them deeper. We had to get away from ESBs and their association with SOA. Hence, we came up with a new name.

I already explained the differences between microservices and monoliths in the previous answers. The short version is that monoliths are slow, require too many people to develop, and do not scale.

## How about microservices vs. APIs?

Microservices communicate with each other through APIs. They are a cornerstone of microservices architecture. We should not care what's inside a microservice. That's up to the team in charge of it to decide. What we should all care are API contracts. That should be sacred since we cannot know who is communicating with us (our services). Once an API is created, it cannot be changed (at least not without a deprecation notice and a long adaptation period). The only thing that can be done is to introduce API changes as new versions while maintaining the old ones.

In other words, there is no microservices vs. APIs. I'd rather say that APIs are integral and indispensable part of each microservice. They are the only entry point. They are doors into the features residing inside microservices.
