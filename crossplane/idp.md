# DevOps


# DevOps

* Containers, Kubernetes
* Cloud
* CI/CD, GitOps
* Monitoring, logging, troubleshooting
* IaC
* Security
* Service mesh
* ...


## Those are
# Ops tools


# Developers

## Should they use those tools?
## Can they use those tools?


# DevOps

* Enabling devs to be self-sufficient
* Shift left
* NOT "now you do it!"


# DevOps

* Creating services that use ops tools...
* ...and enable devs


## Internal Developer Platform
# IDP

* **Internal**: Meant for internal usage
* **Developer**: App developer is the customer
* **Platform**: Where it all comes together


# IDP

* A layer on top of the tech and tooling
* Shift-left (for real)
* What Ops/SREs/DevOps teams create to enable developer self-service.


## Why Self-Service?
# Free ops to do
# what matters


# Why Self-Service?

* Increase productivity
* Reduce lean-time
* Increase deployment frequency
* Decrease mean time to repair (MTTR)
* Decrease change failure rate (CFR)
* etc.


## Full life-cycle of
# everything

* Change the desired state
* Perform actions
* Converge the actual into the desired state
* Observe


<!-- .slide: data-background="img/diag-01.png" data-background-size="contain" -->


# The Tools


# App And Infra Specs

* Kubernetes CRDs


# Pipelines

* Preferably those with k8s CRs
* Argo Workflows
* Tekton


# Synchronization

* Argo CD
* Flux
* Rancher Fleet


# Infra Orchestration

* Crossplane
* ACK
* IaC with Kubernetes operators
* etc.


# App Orchestration

* OAM/KubeVela
* Crossplane
* etc.


# RBAC

* Desired state: Git
* Actual state: Kubernetes


# The Process


<!-- .slide: data-background="img/diag-02.png" data-background-size="contain" -->


# Build vs. Buy

* **Buy**: Small company starting now
* **Build**: Bigger company that already has assets
* Build from scratch?


# Build vs. Buy

* We need tools that enable us to build opinionated platforms (IDPs)


# Build vs. Buy

* Must store changes to Git
* Must use Git as the source of the desired state
* Must have a universal API
* Must be a universal control plane


# Today?

* Backstage
* Crossplane
* Argo CD or Flux
* Pipelines
* Everything else


# Tomorrow?

* Upcoming wave
* The main focus of the industry in 2022 and beyond
* Kubernetes evolution beyond running containers
