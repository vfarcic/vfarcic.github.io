# [Workshop: Kubernetes (2 days)](http://vfarcic.github.io/devops23/workshop.html)

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

* [DevOps 2.0](http://vfarcic.github.io/devops20/index.html)
* Management crash course on Kubernetes, Microservices, CI/CD
* Explanation of company's tools, practices, and architecture
* Discussion about microservices
* Discussion about Docker and schedulers

### Day 2

* Hands-on introduction to Docker
* Test driven development using Docker containers
* Docker API
* Design and develop all the steps of a CI pipeline running from command line
* Integrate manual command line steps into an automated Pipeline (e.g., Jenkins)
* Minikube installation
* Pods
* ReplicaSets
* Services
* Deployments
* Networking
* Load balancing and Service Discovery
* K8s and Docker Security
* Compare K8s vs Docker Swarm

### Day 3

* Deploy CD service and agents
* Translate previous exercises into a CD pipeline
* Automated proxy configuration
* Zero downtime deployment
* Defining Logging Strategy
* Monitoring and alerting (Introduction and best practices)

### Day 4

* Introduction to Self-Adapting and Self-Healing System
* Instrumenting Services
* Notifications to Slack (Alerting Humans)
* Alerting the System
* Self-Healing Applied to Services
* Self-Adaptation Applied to Services
* Self-Adaptation Applied to Instrumented Services
* Notifications to the system to enable self-adaptation
* Setting Up A Production Cluster
* Self-Healing Applied to Infrastructure
* Self-Adaptation Applied to Infrastructure
* Blueprint of A Self-Sufficient System

### Day 5

* Follow-up and embed with the team for practical applications (also for overflow of any items from previous days)

# Talk: Deploying Fault-Tolerant And Highly-Available Jenkins To Kubernetes

Jenkins is the de-facto standard for continuous integration, delivery, and deployment process. Docker allows us to package our applications into immutable images that can be reliably deployed anywhere. Kubernetes become undisputable king of container orchestration.

What happens when we combine the three? We'll explore the steps we might take to combine Jenkins, Docker, and Kubernetes into a reliable, fault-tolerant, and highly-available platform for continuous deployment processes.


# Bio (short)

Viktor Farcic is a Principal Consultant at CloudBees, a member of the Docker Captains group, and books author.

His big passions are DevOps, Microservices, Continuous Integration, Delivery and Deployment (CI/CD) and Test-Driven Development (TDD).

He often speaks at community gatherings and conferences.

He published "The DevOps Toolkit Series" books the Test-Driven Java Development.

His random thoughts and tutorials can be found in his blog TechnologyConversations.com.
