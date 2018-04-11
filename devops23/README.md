# [Workshop: Kubernetes: Deploying and managing highly-available and fault-tolerant applications at scale (2 days)](http://vfarcic.github.io/devops23/workshop.html)

## Abstract

Kubernetes is a container scheduler and quite a lot more. We can use it to deploy our services, to roll out new releases without downtime, and to scale (or de-scale) those services. It is portable. It can run on a public or private cloud. It can run on-premise or in a hybrid environment. Kubernetes, in a way, makes your infrastructure vendor agnostic. We can move a Kubernetes cluster from one hosting vendor to another without changing (almost) any of the deployment and management processes. Kubernetes can be easily extended to serve nearly any needs. We can choose which modules we'll use, and we can develop additional features ourselves and plug them in.

If we choose to use Kubernetes, we decide to relinquish control. Kubernetes will decide where to run something and how to accomplish the state we specify. Such control allows Kubernetes to place replicas of a service on the most appropriate server, to restart them when needed, to replicate them, and to scale them. We can say that self-healing is a feature included in its design from the start. On the other hand, self-adaptation is coming as well. At the time of this writing, it is still in its infancy. Soon it will be an integral part of the system.

Zero-downtime deployments, fault tolerance, high availability, scaling, scheduling, and self-healing should be more than enough to see the value in Kubernetes. Yet, that is only a fraction of what it provides. We can use it to mount volumes for stateful applications. It allows us to store confidential information as secrets. We can use it to validate the health of our services. It can load balance requests and monitor resources. It provides service discovery and easy access to logs. And so on and so forth. The list of what Kubernetes does is long and rapidly increasing. Together with Docker, it is becoming a platform that envelops whole software development and deployment lifecycle.

In this course, you will learn (almost) everything you need to know about Kubernetes.

## Agenda

### Day 1

* [Building Docker Images](http://vfarcic.github.io/devops23/workshop.html#/docker-image)
* [What Is A Container Scheduler?](http://vfarcic.github.io/devops23/workshop.html#/7)
* [Running A Kubernetes Cluster Locally](http://vfarcic.github.io/devops23/workshop.html#/8/1)
* [Creating Pods](http://vfarcic.github.io/devops23/workshop.html#/10)
* [Scaling Pods With ReplicaSets](http://vfarcic.github.io/devops23/workshop.html#/12)
* [Using Services To Enable Communication Between Pods](http://vfarcic.github.io/devops23/workshop.html#/14)
* [Deploying Releases With Zero-Downtime](http://vfarcic.github.io/devops23/workshop.html#/16)
* [Using Ingress To Forward Traffic](http://vfarcic.github.io/devops23/workshop.html#/18)
* [Using Volumes To Access Host's File System](http://vfarcic.github.io/devops23/workshop.html#/20)

### Day 2

* [Using ConfigMaps To Inject Configuration Files](http://vfarcic.github.io/devops23/workshop.html#/22)
* [Using Secrets To Hide Confidential Information](http://vfarcic.github.io/devops23/workshop.html#/24)
* [Dividing A Cluster Into Namespaces](http://vfarcic.github.io/devops23/workshop.html#/26)
* [Securing Kubernetes Clusters](http://vfarcic.github.io/devops23/workshop.html#/28)
* [Managing Resources](http://vfarcic.github.io/devops23/workshop.html#/30)
* [Creating A Production-Ready Kubernetes Cluster](http://vfarcic.github.io/devops23/workshop.html#/32)
* [Persisting State](http://vfarcic.github.io/devops23/workshop.html#/34)

# Workshop: Kubernetes (5 days)

## Agenda

### Day 1

[X] [DevOps 2.0](http://vfarcic.github.io/devops20/index.html)
[X] [DevOps 2.3](http://vfarcic.github.io/devops23/index.html)
[X] Management crash course on Kubernetes, Microservices, CI/CD
[X] Explanation of company's tools, practices, and architecture
[X] Discussion about microservices
[X] Discussion about Docker and schedulers

### Day 2

[X] [Hands-on introduction to Docker](http://vfarcic.github.io/devops21/workshop.html)
[X] Test driven development using Docker containers
[ ] Docker API
[X] Design and develop all the steps of a CI pipeline running from command line
[X] [Integrate manual command line steps into an automated Pipeline (e.g., Jenkins)](http://vfarcic.github.io/jenkins-docker/workshop.html)
[X] [Minikube installation](http://vfarcic.github.io/devops23/workshop.html)
[X] Pods
[X] ReplicaSets
[X] Services
[X] Deployments
[X] Networking
[X] Load balancing and Service Discovery
[X] K8s and Docker Security
[X] Compare K8s vs Docker Swarm

### Day 3

[X] Deploy CD service and agents
[X] Translate previous exercises into a CD pipeline
[X] Automated proxy configuration
[X] Zero downtime deployment
[X] Defining Logging Strategy
[ ] Monitoring and alerting (Introduction and best practices)

### Day 4

[ ] Introduction to Self-Adapting and Self-Healing System
[ ] Instrumenting Services
[ ] Notifications to Slack (Alerting Humans)
[ ] Alerting the System
[ ] Self-Healing Applied to Services
[ ] Self-Adaptation Applied to Services
[ ] Self-Adaptation Applied to Instrumented Services
[ ] Notifications to the system to enable self-adaptation
[ ] Setting Up A Production Cluster
[ ] Self-Healing Applied to Infrastructure
[ ] Self-Adaptation Applied to Infrastructure
[ ] Blueprint of A Self-Sufficient System

### Day 5

[ ] Follow-up and embed with the team for practical applications (also for overflow of any items from previous days)

# Talk: Deploying Fault-Tolerant And Highly-Available Jenkins To Kubernetes

Jenkins is the de-facto standard for continuous integration, delivery, and deployment process. Docker allows us to package our applications into immutable images that can be reliably deployed anywhere. Kubernetes become undisputable king of container orchestration.

What happens when we combine the three? We'll explore the steps we might take to combine Jenkins, Docker, and Kubernetes into a reliable, fault-tolerant, and highly-available platform for continuous deployment processes.


# Bio (short)

Viktor Farcic is a Principal Consultant at CloudBees, a member of the Docker Captains group, and books author.

His big passions are DevOps, Microservices, Continuous Integration, Delivery and Deployment (CI/CD) and Test-Driven Development (TDD).

He often speaks at community gatherings and conferences.

He published "The DevOps Toolkit Series" books the Test-Driven Java Development.

His random thoughts and tutorials can be found in his blog TechnologyConversations.com.
