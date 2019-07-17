# Building A Self-Sufficient System

## Abstract: Talk

What do we expect from a modern cluster? If a replica fails, it should be brought back up (rescheduled). If a node goes down all the services that were running inside it should be distributed among healthy nodes. Those tasks are easy to accomplish. Schedulers (Swarm, Kubernetes, Mesos/Marathon, and so on) are already doing those things for us. Many solutions provide self-healing by making sure that the system is (almost) always in the desired state.

The problem with self-healing is that it does not take into the account constant changes. The number of requests is continuously changing, errors are created, network bandwidth is fluctuating, and so on. A cluster, and services inside it, is like a living body that needs to adapt to changes continuously. Services need to be scaled and de-scaled, nodes need to be created and added to the cluster only to be removed soon after. We call that process adaptation. Even that is not the problem in itself, as long as we have an army of operators that will monitor the system and do reactive and preventive actions.

How about converting adaptation into self-adaptation? Can we remove humans from the process and make a system that is **self-sufficient**?

The goal of this talk is to try to outline the steps required for a design of a **self-adapting** and **self-healing** system that will continue operating efficiently even when we are on vacations.

## Abstract: Workshop

What do we expect from a modern cluster? If a replica fails, it should be brought back up (rescheduled). If a node goes down all the services that were running inside it should be distributed among healthy nodes. Those tasks are easy to accomplish. Schedulers (Swarm, Kubernetes, Mesos/Marathon, and so on) are already doing those things for us. Many solutions provide self-healing by making sure that the system is (almost) always in the desired state.

The problem with self-healing is that it does not take into the account constant changes. The number of requests is continuously changing, errors are created, network bandwidth is fluctuating, and so on. A cluster, and services inside it, is like a living body that needs to adapt to changes continuously. Services need to be scaled and de-scaled, nodes need to be created and added to the cluster only to be removed soon after. We call that process adaptation. Even that is not the problem in itself, as long as we have an army of operators that will monitor the system and do reactive and preventive actions.

How about converting adaptation into self-adaptation? Can we remove humans from the process and make a system that is **self-sufficient**?

The goal of this workshop is to provide hands-on exercises that outline the steps required for a design of a **self-adapting** and **self-healing** system that will continue operating efficiently even when we are on vacations. We'll define goals and processes and explore quite a few tools (Docker, Prometheus, Alertmanager, Jenkins, AWS, and so on). The end-result of the workshop will be a base for a **self-sufficient** system that you'll be able to implement in your organization.

## Abstract: Short

Can we remove humans from the process and make a system that is **self-sufficient**?

The goal of this talk is to try to outline the steps required for a design of a **self-adapting** and **self-healing** system that will continue operating efficiently even when we are on vacations.