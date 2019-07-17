## The Four Quadrants of A Dynamic And Self-Sufficient System

Any system that intends to be fully automated and self-sufficient must be capable of self-healing and self-adaptation. As a minimum, it needs to be able to monitor itself and perform certain actions both on service and infrastructure levels.

Two axes can represent the set of actions a system might execute. One group of actions be represented through the differences between infrastructure and services. The other axis can be explained by the type of activities, with self-healing on one end, and self-adaptation on the other.

The most common type of self-healing, when applied to infrastructure, is to recreate a failed or a faulty node. When infrastructure needs to be adapted to changed conditions, nodes are scaled. Self-healing is mostly about rescheduling failed services. When system's conditions change, it should self-adapt by scaling some of the services.

![Figure 7-1: The types of system actions](images/ch07/dimensions-system.png)

How does the system distinguish self-adaptation from self-healing? When should it choose to perform one action over the other?

Every system has a design. It might stay unchanged for a long time, or it can be redesigned every few minutes. The frequency of a change of a system design distinguishes static from dynamic systems. Throughout most of the short history of the software industry, we favored long lasting designs. We would spend a long time planning and even longer time designing a system before implementing it. It was no wonder that we were not very eager to spend months, or even years, in doing all that only to change it the week after launch. We worked using waterfall model where everything is planned in advance and executed in very long phases. Most of the time the result would be a failure, but we won't enter into that discussion right now. If you worked in this industry for a while, you probably know what waterfall is. Hopefully, your company changed, or you changed the company. Waterfall is dead, and long lasting static designs are gone with it.

Dynamic systems are characterized by very frequent, not to say continuous, change in design. We would design a service that would run five replicas, only to change that number to seven a week later. We would design infrastructure that is composed of twenty-seven nodes, only to change it to thirty short while later. Every time we make a conscious decision to change something inside a system, we are changing the design. Each of those changes is a result of either the initial miscalculation or the modification in the external conditions that are affecting the system. A steady increase in traffic requires a change in design. It demands that we scale the number of replicas of one or more services. Everything else being equal, an increase in the number of replicas requires an increase of infrastructure resources. We need to add more nodes that will host that increase. If that's not the case, we over-provisioned the system. We had idle resources that can be put to use when scaling up the services.

Self-adaptation is an automated way to change a design of a system. When we (humans) change it, we do it by evaluating metrics. At least, we should do it like that. Otherwise, we are consulting a crystal ball, employing a fortune teller, or purely guessing. If we can make decisions based on metrics, so can the system. No matter who changes the system, every change is a modification of the design. If we automate the process, we get self-adaptation.

Self-healing does not impact the design. Quite the contrary, it follows it. If the design is to have five replicas and only four are running, the system should do its best to add another replica. And it's not always about increasing numbers. If there are more replicas than designed, some should be removed. The same logic applies to nodes or any other quantifiable part of the system. Long story short, self-healing is about making sure that the design is always followed.

T> *Self-adaptation* is about having an automated way to apply changes to the design of a system. The objective behind *self-healing* is to make sure that the design is followed at any given moment. When we combine self-adaptation with self-healing, the result is a truly dynamic, resilient, and fault tolerant system with high availability.

A system can adapt or heal services or infrastructure. The most common action behind healing is to recreate things that failed while adaptation is often about scaling. They are the four quadrants that represent a dynamic and self-sufficient system.

# The DevOps 2.2 Toolkit: Self-Healing Docker Clusters

<a href="https://leanpub.com/the-devops-2-2-toolkit"><img src="https://technologyconversations.files.wordpress.com/2017/06/cover-small1.jpg?w=249" alt="" width="249" height="300" class="alignright size-medium wp-image-3563" /></a>If you liked this article, you might be interested in **[The DevOps 2.2 Toolkit: Self-Healing Docker Clusters](https://leanpub.com/the-devops-2-2-toolkit)** book. The book goes beyond Docker and schedulers and tries to explore ways for building self-adaptive and self-healing Docker clusters. If you are a Docker user and want to explore advanced techniques for creating clusters and managing services, this book might be just what you're looking for.

The book is still under development. If you choose to become early reader and influence the direction of the book, please get a copy from [LeanPub](https://leanpub.com/the-devops-2-2-toolkit). You will receive notifications whenever a new chapter is added.

Give the book a try and let me know what you think.
