Shortwhile ago I got the following question.

> I used to be more of a sysadmin and network guy but previously I did also Application support jobs.
I'm about to enter a new Devops project and the project manager is asking me to assess their technology set and see if does allow or inhibit Continuous Delivery practices? Could you pass me some steps/tips?

I thought that the question is so interesting that it deserves an article in itself. Here's the answer I sent back.



On a very high level, the first thing you need to look at is company culture. If a company is organized in a slow, bureaucratic way around different horizontal departments, any DevOps attempt will fail. DevOps is all about being fast, automated, and reliable. To accomplish that, you need small (up to ten people) autonomous teams capable of delivering an application or a service from beginning (requirements) to the end (running and being monitored in production). If there are handoffs, it will fail. If there's too much paperwork, it will fail. If DevOps is a separate department instead being part of team skills, it will fail.

Once the culture is solved, start looking into software architecture. If it's big, teams cannot be small, it cannot be passed through the deployment pipeline fast, it cannot be easily scaled and de-scaled, the system cannot be fast to reach to problems (e.g. node failure), and so on. In other words, if your system is a big monolithic application, start thinking how to break it into smaller pieces. There is a very good reason why microservices, devops, and containers became popular at the same time. They depend on each others heavily if the result is to be their utilization. Read about "Domain Driven Design" to learn how to break the applications.

When the first piece of the monolithic application is chipped away and you've got your first microservice, start thinking about the tools you'll use to pass it through the pipeline. In most cases, there is no good reason not to use containers. Benefits are too big to be ignored and, in many cases, without containers you'll realize that having microservices is too expensive as an effort and that it creates too much trouble. Today, the only container technology worth talking about is Docker. Once you start using Docker, you'll realize that you need a cluster orchestrator. My choice is to go with Swarm (the new one introduced in Docker 1.12 that will become available in a few weeks). Kubernetes is also a very good alternative (there would be a long discussion why I think the new Swarm is better). With containers and some kind of cluster orchestration, you'll realize that many things change. Your services/applications should follow "12 factor app" logic. Configuration should be moved from static files to service discovery. Proxies will have to become much more dynamic. Monitoring should also be dynamic. Logging needs to be centralized. The list can go on and on. Tools will be different than what you're used to. They tend to be smaller and more specific. They have to be very dynamic. In a way, microservices philosophy should be applied to tools as well, not only the services we write.

The point I'm trying to make is that successful DevOps implementation is much more than using a few new tools. It requires changes on all levels. Organization needs to change, people's mindset needs to change, architecture needs to change, tools need to change.

I know that my answer was too generic. However, giving a more concrete answer would require a more concrete question. Please don't hesitate to send me another email or contact me through Skype (user: vfarcic) or HangOuts (email: viktor@farcic.com) and we can talk further.

I think this would be an interesting article. Do you mind if I use this email as the base for the next post in my blog (I will not reveal your identity)?




Do you consider containerization (Docker or Kubernetes) mature enough to be used in production as well - consider that I havent used this technology until now - I just started testing.



Containers are used for 10-15 years (Google is one example). What Docker did is make the usage much easier (working with containers on kernel level is quite difficult). Docker is more than mature enough to be used in production as long as one understands what containers do. I heard, quite a few times, stories how containers are not yet stable in, in most cases, the problem was that they did not fully understand the use cases for containers.

As for orchestrators, all three major players (Swarm, Kubernetes, and Mesos) are used in production by some very large organizations. They are mature and production ready.

The major problem is that big, traditional, enterprise organizations have a tendency to be quite a lot behind and containers might not be a good fit for them since there might be a huge gap.