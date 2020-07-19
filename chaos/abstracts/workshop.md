# Kubernetes Chaos Engineering With Chaos Toolkit And Istio

There are very few things as satisfying as destruction, especially when we’re frustrated.

How often did it happen that you have an issue that you cannot solve and that you just want to scream or destroy things? Did you ever have a problem in production that is negatively affecting a lot of users? Were you under a lot of pressure to solve it, but you could not “crack” it as fast as you should. It must have happened, at least once, that you wanted to take a hammer and destroy servers in your datacenter. If something like that never happened to you, then you were probably never in a position under a lot of pressure. In my case, there were countless times when I wanted to destroy things. But I didn’t, for quite a few reasons. Destruction rarely solves problems, and it usually leads to negative consequences. I cannot just go and destroy a server and expect that I will not be punished. I cannot hope to be rewarded for such behavior.

What would you say if I tell you that we can be rewarded for destruction and that we can do a lot of good things by destroying stuff? If you don’t believe me, you will soon. That’s what chaos engineering is about. It is about destroying, obstructing, and delaying things in our servers and in our clusters. And we’re doing all that, and many other things, for a very positive outcome.

Chaos engineering tries to find the limits of our system. It helps us deduce what are the consequences when bad things happen. We are trying to simulate the adverse effects in a controlled way. We are trying to do that as a way to improve our systems to make them more resilient and capable of recuperating and resisting harmful and unpredictable events.

That’s our mission. We will try to find ways how we can improve our systems based on the knowledge that we will obtain through the chaos.

## Agenda

### Introduction To Chaos Engineering

* Introduction
* Principles Of Chaos Engineering
* Are You Ready For Chaos?
* Examples Of Chaos Engineering
* The Principles And The Process
* Chaos Experiments Checklist

### Choosing The Right Tool

* Requirements Guiding The Choice
* Which Tool To Pick?

### Setting Up The Environment

* Installing Chaos Toolkit

### Destroying Application Instances

* Introduction
* Creating A Cluster
* Deploying The Application
* Discovering ChaosToolkit Kubernetes Plugin
* Terminating Application Instances
* Defining Steady State Hypothesis
* Pausing After Actions
* Probing Phases And Conditions
* Making The Application Fault-Tolerant

### Experimenting With Application Availability

* Introduction
* Validating Application Health
* Validating Application Availability
* Terminating Application Dependencies

### Obstructing And Destroying Network

* Introduction
* Installing Istio Service Mesh
* Deploying The Application
* Discovering ChaosToolkit Istio Plugin
* Aborting Network Requests
* Rolling Back Abort Failures
* Making The Application Resilient To Partial Network Failures
* Increasing Network Latency
* Aborting All Requests
* Simulating Denial Of Service Attacks
* Running Denial Of Service Attacks

### Draining And Deleting Nodes (works only if NOT using local Kubernetes)

* Introduction
* Draining Worker Nodes
* Uncordoning Worker Nodes
* Making Nodes Drainable
* Deleting Worker Nodes

### Creating Chaos Experiment Reports

* Introduction
* Exploring Experiments Journal
* Creating Experiment Report
* Creating A Multi-Experiment Report

### Running Chaos Experiments Inside A Kubernetes Cluster

* Introduction
* Setting Up Chaos Toolkit In Kubernetes
* Types Of Experiment Executions
* Running One-Shot Experiments
* Running Scheduled Experiments
* Running Failed Scheduled Experiments
* Sending Experiment Notifications
* Sending Selective Notifications

### Executing Random Chaos

* Introduction
* Deploying Dashboard Applications
* Exploring Grafana Dashboards
* Exploring Kiali Dashboards
* Preparing For Termination Of Instances
* Terminating Random Application Instances
* Disrupting Network Traffic
* Preparing For Termination Of Nodes
* Terminating Random Nodes
* Monitoring And Alerting With Prometheus

## Requirements

The full list of the requirements is as follows.

* [Git](https://git-scm.com/)
* WSL or GitBash (if using Windows)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* A Docker Desktop, Minikube, GKE, EKS, AKS, or any other Kubernetes cluster
* [Helm v3.x](https://helm.sh/docs/intro/install/) (if EKS)
* [Python v3.x](https://www.python.org/downloads)
* [pip](https://pip.pypa.io/en/stable/installing)

Please make sure that you have the requirements before the workshop session.
