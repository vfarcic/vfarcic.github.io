# Microservices Checklist

## Don't create services around horizontal layers

Microservices should not be organized around technical aspects of software development. They are not another name for horizontal layers we've been used to create. Don't create a services called *DAO service* or *business logic service*.

## Do define a service around a single functionality or a single bounded context

A microservice is small and encapsulates a single functionality or a single bounded context. Microservices are best described through *domain-driven design* concepts where each service is a bounded context focused on business needs, not technical. Those contexts are vertical and span the whole organization in order to provide a full functionality and has no dependencies with other services.

## Do communicate through APIs

Each microservice must be physically separated from the rest. Otherwise, human factor will, sooner or later, couple different services and they will not be self-sufficient independent life-cycles. The only connection between services should be through their APIs.

## Do form a self-sufficient team in charge of a service or a group of services

The major advantage and the primary reason behind microservices is the ability to form small teams, each fully in charge of a service. If an application is big (monolith), a team that maintains it must be big as well. Smaller teams (4-8 people) are much faster, have better communication, and can adapt to changes much easier. For a team to be truly effective, it needs to be self-sufficient. Such a team cannot depend on anyone outside or it'll stop being self-sufficient. A team should be in charge of one or more services. A single service cannot belong to two or more teams.

## Don't enforce dependencies between services

Don't try to come up with a set of libraries or other dependencies that MUST be implemented in all services. Such decisions are severely limiting the teams developing services. You are allowed to help the teams by offering a set of libraries or other dependencies that might be useful. It should be their choice whether to use them or not. If a team is responsible for a service, than the same team should be able to choose how to fulfil that responsibility. Don't confuse enforcement with help.

## Do make services stateless

For services to be fully independent, scalable, and fault tolerant, they cannot have any state. That does not mean that there should be no state but that it should be separated. If you need to store and retrieve data, use a database. If you need to store user's session, use an in-memory key/value store.

## Don't do hand-overs

A team in charge of a service should be in charge of its whole lifecycle. It should be able to gather requirements, develop, test, and deploy to production. If a service fails at 3AM during a weekend, the team should fix it, not someone from some other department in charge of monitoring. After all, no one knows better how to fix it but those that introduced the bug in the first place.

## Do make each microservice deployable independently from others

Each microservice should have its own lifecycle. Each should be developed and deployed independently from others. If that's not the case, your microservices are probably still a monolith in disguise.

## Don't make a project to break the monolith

Moving from monoliths to microservices is a long and painful process for which you might not be prepared (yet). Do not make a big project that will break legacy monolith. You'll fail or, more likely, end up with only cosmetic changes. Start small. Pick a new feature that is not critical and develop it as a microservice. Learn from your mistakes. Only once you're comfortable with the result, start moving existing features from monolith to microservices. Even then, refactor only those features that do need to change. Leave parts that do not require (much) maintenance effort as they are.

## Do create a continuous delivery or deployment pipeline

Every type of architecture should strive towards automation of all the repetitive tasks. The culmination of that automation is continuous delivery (CD) and deployment (CDP). The problem is that implementing CD and/or CDP is very hard with legacy applications. Microservices, by being small and focused on a specific domain, make CD/CDP easier than ever. There is no good excuse not to make the whole process fully automated and let the team dedicate their time to creative tasks.

## Don't do it just because you might need it one day

Do not over-engineer your services by putting into them things that might be needed in the future. Small is good. Just enough is great. There might not be a reason to use, for example, Hibernate if a service will do only a few queries to the database.

## Don't couple microservices with infrastructure tools

There are no reasons (any more) to put infrastructure libraries and frameworks inside microservices. For example, don't adopt a service discovery solution that forces you to add some code or libraries to your services. They should be focused on their bounded context and everything else should be done outside and independent of a particular service.

## Do deploy services as containers

It's not a hype any more. Containers are here to stay. Leverage immutability and portability they provide or you'll be facing "infrastructure hell" generated with exponentially increased number of deployments, dependencies, and configurations.

## Don't write log entries to files

Do not send your logs to files. They are hard to manage, aggregate, and explore when distributed across the cluster and many services. Instead, send your logs to `stdout` and `stderr`. Logging tools will make sure to capture `stdout` and send it to some central location.

## Do allow diversity and freedom of choice

Every microservice should evaluate for itself what is the best language, frameworks, and libraries it should use. There is no such thing as a best language but only a good choice for a given use case. Don't be afraid to introduce diversity. There are many benefits in, for example, using Scala when in need to develop a service that requires heavy computations, NodeJS when backend serves mostly as a JSON pass-through from the front-end towards the database, Go when you need multi-threading and to execute system wide tasks, and so on.

Do NOT try to define which language should the teams use to write code or which frameworks they should embrace. If microservices are developed by self-sufficient teams, they should make those decisions, not you. Otherwise, they are not self-sufficient and, therefore, cannot be fully responsible for services they are in charge of.

No one can be an expert in everything so there must be a balance between choosing the right tool/language/framework and the current team knowledge. Make sure to give the teams enough time to experiment and learn new things.

## Do discard big, heavy solutions

If you choose to develop microservices, try to keep things small. Choose light application servers instead big ones designed to host multiple applications. Remember, small is often (not always) a good thing. Aim towards adopting solutions that do what you need them to do, not more. It's better to combine five tools that together provide just what you need, then one big "monster" that does much more.

## Provide everything as a service

For the teams to be able to develop and deploy services at their own pace and not be slowed down by external influences, every other type of tasks performed by experts working outside those teams needs to be done as a service. Creating new servers, deploying services to the cluster, monitoring and alerting are only a few examples of the type of tasks that might be better done by specialized teams. If that's the case, those teams should make their work available as a service so that the teams in charge of microservices can avoid making requests that would introduce waiting time and increase time to market.

## Don't share a database between multiple services

A common mistake is to create microservices that share the same database. Such a combination introduces too much coupling and will prevent microservices from having their own life-cycles. Instead, each service should have it's own database (when needed). If one service need to access data generated by another, it should to that through its API.
