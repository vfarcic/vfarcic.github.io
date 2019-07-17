# Docker Flow Projects: Making A Dynamic Cluster Even More Dynamic

## Abstract

You are practicing continuous deployment, aren't you? I will assume you are. Now, let's say that you just finished the first release of your new service. That first version is the first commit to your code repository. Your CD tool of choice detected the change in your code repository and started the CD pipeline. At the end of it, the service will be deployed to production. I can see a smile on your face. It's that expression of happiness that can be seen only after a child is born, or a service is deployed to production for the first time. That smile should not be long lasting since deploying a service is only the beginning. It needs to be integrated with the rest of the system. The proxy needs to be reconfigured. Logs parser needs to be updated with the format produced by the new service. Monitoring system needs to become aware of the new service. Alerts need to be created with the goal of sending warning and error notifications when the state of the service reaches certain thresholds. The whole system has to adapt to the new service and incorporate the new variables introduced with the commit we made a few moments ago.

How to we adapt the system so that it takes the new service into account? How do we make that service be an integral part of the system?

We'll go through *Docker Flow* projects which aim at bridging the gap between a dynamic cluster running Docker Swarm and third-party services designed in the previous era. We'll go through a few open source projects:

* [Swarm Listener](http://swarmlistener.dockerflow.com/) which propagates service events to other services
* [Proxy](http://proxy.dockerflow.com/) that reconfigures itself whenever a service is created, updated, or destroyed
* [Monitor](http://monitor.dockerflow.com/) that tracks metrics and fires alerts when some threshold is reached.
* [Cron](http://cron.dockerflow.com/) that allows scheduling of batch-like processes.
* and a few more...