A short while ago [beaglecat.com](http://www.beaglecat.com/) interviewed 15 tech experts (I included). The full text can be found in the [Technology Trendsetters eBook](http://www.beaglecat.com/will-future-tech-iot-vr-robotics-shape-lives/). The interview I gave is as follows.

**Beaglecat: What is your one tip for companies wanting to implement your product/service/solution at a large scale?**

**Viktor Farcic:** Elasticity and scalability are the keys. If your product is aimed at large scale, it needs to be able to adapt itself to the ever-changing needs of your users. It has to be able to scale up or down depending on the traffic and future predictions, and that capability needs to be fully automated.

Gone are the days when a company can plan system needs in advance. With the reaction speed that is expected today, we cannot decide anymore on how many servers the system will need, since those predictions change from one day to another. If we allocate more servers than needed, we are losing money by having idle hardware. If the allocation is below the current needs, we are potentially losing customers. The system itself needs to be able to grow, and shrink, depending on the present and future needs, and that change must be automated. I think that we are starting to see systems as autonomous bodies with some kind of a (simple) intelligence capable of making these adjustments, automatically.


**BC:** What are the technologies that could influence the development of your product/service/solution in the foreseeable future? And what are the fields that could be influenced by your company?

**V.F:** Jenkins has a very complicated goal. It acts as an orchestrator of everything from a commit to a CMS all the way until the application is deployed to production. The number of tools that can be used to perform all the steps in the deployment pipeline is enormous, and we need to support (almost) all of them. Due to such a broad scope, we are bound to follow all the tendencies. As soon as a new tool is released and it seems to get traction, it is followed by a community or CloudBees-developed plugin. In other words, the technologies that influence the development of our product are (almost) all of them.

Jenkins is probably the main influence in the continuous integration (CI), continuous delivery (CD) and deployment area. It, in a way, defines what CI/CD is. Judging by the trends and our resolve, we will continue leading the continuous delivery movement and, through it, be in the front seat of influencing the move to DevOps.


**BC:** How much does your customers’/clients’/consumers’ feedback matter in how your product/service/solution turns out?

**V.F:** User feedback is the key to our immediate and future plans. Since our company is based on the Jenkins open source project, we are used to defining the roadmap based on the needs of our users. Every feature added to the product is a result of someone's request for that feature. That is the advantage of OSS.

While closed source projects tend to guess what users need, with OSS users are developers and developers are users. For that reason, enterprise products based on OSS have a distinct advantage when compared with closed source products. We get lots of feedback from users. What CloudBees is all about is taking that feedback and developing enterprise features that enhance the use of open source Jenkins for large enterprises.

However, the dual audiences pose quite a challenge. Being behind both a successful OSS product and an enterprise solution that accompanies it, means that the number of users is huge and, with it, the amount of different, and often conflicting, needs and requests  we receive is considerably bigger than if the product would be closed source. Listening to your users is  nothing new. However, what poses a genuine challenge  is the prioritization of the requests and the attempt to accommodate them quickly. It is not uncommon that the time since the request for a fix or a new feature is made until the solution is available is measured in hours for a quick-fix but days, or weeks, until the feature is developed, tested and available to everyone.


**BC:** In your opinion, how will the world look like in 2030?

**V.F:** I think it is impossible to imagine how the world will look in 2030. Technology is moving so fast that I would  not even be able to predict how the world would look in 2020. I can only provide my answer in the context of a much nearer future and based on current trends.

I will, however, provide one prediction, before moving towards more evident, short-term guesses. Intelligent, self-healing systems will become more and more common. We are, slowly, realizing that the response times required of us are too short and that only machines will be able to perform the system adjustments we need, and in the timeframe they are needed. Instead of monitoring the system ourselves and reacting to changing conditions, we'll expect the system to heal and improve itself. Our jobs, from the operations perspective, will be only to observe the results and improve the "intelligence."

Now back to short term predictions.

I think that in this year and those that follow we'll see massive changes in how we architect and deliver software. The focus in the last decade has been on agile methodologies. While they brought a lot of value and drastically changed the way we develop software, they were, mostly, limited in their scope. They are oriented either towards management (e.g. Scrum) or practices that affect developers and testers (e.g. eXtreme Programming). With few exceptions, architecture and operations were left out and, until recently, continued existing in a similar form as they did before.

With the increase in the popularity of DevOps, we'll see operations and architecture being added to the mix. As a result, we'll finally see continuous deployment becoming the norm. We will be expected to deploy, reliably and automatically, new releases to production many times a day. Besides the cultural change that is under way through DevOps, the movement towards continuous deployment will be followed by many technological changes. Breaking legacy monolithic applications into microservices will continue gaining momentum and become a standard practice soon.

Since microservices are too hard to accomplish without immutability and self-sufficiency, Docker will keep gaining ground. However, we will see new players in that field in the near future. It is still early to say who will be those players, but I am confident that they will emerge.

I think that this and the following year will be dedicated to microservices, containers, continuous deployment, and scalable and elastic systems capable of self-healing. You might say that already happened, but I think that we have only scratched the surface.

One of the most interesting areas to look for in the near future are orchestrators. I am intentionally avoiding a more precise term since they can have many forms (cluster orchestrators, deployment orchestrators, self-healing orchestrators and so on). Deployments will be fully automated and our cluster and services running in it will have the ability to self-heal. For that to truly happen, we'll see a rise in "intelligent" systems that are capable of managing the whole systems lifecycle  without human intervention. The tools we have at our disposal right now are not nearly good enough. They are only showing us the future and opening the door for machine learning and, later on, artificial intelligence.

The future will be all about speed and autonomy. We will define features faster; we'll develop and test them faster; we'll deploy them faster. The key is in speed and time-to-market. The systems we develop will be fully autonomous and capable of making complicated decisions without human intervention.