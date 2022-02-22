# DevOps

### Containers, Kubernetes, cloud,
### GitOps, CI/CD, logging,
### monitoring, IaC, troubleshooting,
### security, service mesh,
### ...

## Ops tools


# Developers

## Should they use those tools?
## Can they use those tools?


# DevOps

## Enabling devs to be self-sufficient
## Shift left
## NOT "now you do it!"


# DevOps

## Creating services that use ops tools...
## ...and enable devs


# Internal Developer Platform (IDP)

## **Internal**: Meant for internal usage
## **Developer**: App developer is the customer
## **Platform**: Where it all comes together


# IDP

## A layer on top of the tech and tooling
## Shift-left (for real)
## What Ops/SREs/DevOps teams create to enable developer self-service.


# Why Self-Service?

## Free ops to do what matters


# Why Self-Service?

## Increase productivity
## Reduce lean-time
## Increase deployment frequency
## Decrease mean time to repair (MTTR)
## Decrease change failure rate (CFR)
## etc.


# Full live-cycle of everything

## Change the desired state
## Perform actions
## Converge the actual into the desired state
## Observe


# The Actual State

## **Providers**: AWS, Azure, Google Cloud, on-prem, DataDog, Elastic, Splunk, etc.
## **Infrastructure**: servers, clusters, DBs, etc.
## **Apps**: yours and 3rd-party self-hosted


# The Desired State

## App Code, manifests, configs, etc.
## Manifests (cannot be building blocks)
## Must be in Git


# The Tools

## Pipelines
## GitOps
## Infra
## RBAC
## etc.


# User Interface (UI)

## Web UI or CLI or IDE or all?
## NOT links
## Not embeeded tools
## Only if there are APIs for everything
## It must be Kubernetes


# Universal API (KubeAPI)

## Single API for everything
## Continuous drift-detection and reconciliation
## Designed to be extensible
## It's not (only) about running containers


# CRDs And CRs

## Who writes manifests?
## Opportunity to define what something is
## Opportunity to simplify
## Opportunity for ops to create compositions
## Devs write CR manifests


# The Tools


# App And Infra Specs

## Kubernetes CRDs


# Pipelines

## Preferably those with k8s CRs
## Argo Workflows
## Tekton


# Synchronization

## Argo CD
## Flux
## Rancher Fleet


# Infra Orchestration

## Crossplane
## ACK
## IaC with Kubernetes operators
## etc.


# App Orchestration

## OAM/KubeVela
## Crossplane
## etc.


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.9), rgba(87,185,72,0.9)), url(../img/background/why.jpg) center / cover" -->
# RBAC

## Desired state: Git
## Actual state: Kubernetes


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.9), rgba(87,185,72,0.9)), url(../img/background/why.jpg) center / cover" -->
# The Process

## Dev writes code and pushes it to Git
## Pipeline executes one-shot builds
## Dev stores (CR) manifests in Git
## GitOps detects the drift
## GitOps converges the states
## The CR does drift-detection and reconciliation


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.9), rgba(87,185,72,0.9)), url(../img/background/why.jpg) center / cover" -->
# What Do We Do In IDP?

## Write manifests based on CRDs
## Push manifests to Git
## Observe the desired state
## Observe the actual state


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.9), rgba(87,185,72,0.9)), url(../img/background/why.jpg) center / cover" -->
# What Do We Do In IDP?

## Everything is tailor-made to match dev needs


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.9), rgba(87,185,72,0.9)), url(../img/background/why.jpg) center / cover" -->
# Build vs. Buy

## **Buy**: Small company starting now
## **Build**: Bigger company that already has assets
## Build from scratch?


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.9), rgba(87,185,72,0.9)), url(../img/background/why.jpg) center / cover" -->
# Build vs. Buy

## We need tools that enable us to build opinionated platforms (IDPs)


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.9), rgba(87,185,72,0.9)), url(../img/background/why.jpg) center / cover" -->
# Build vs. Buy

## Must store changes to Git
## Must use Git as the source of the desired state
## Must have a universal API
## Must be a universal control plane


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.9), rgba(87,185,72,0.9)), url(../img/background/why.jpg) center / cover" -->
# Today?

## Backstage
## Crossplane
## Argo CD or Flux
## Pipelines
## Everything else


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.9), rgba(87,185,72,0.9)), url(../img/background/why.jpg) center / cover" -->
# Tomorrow?

## Upcoming wave
## One of the main focuses of the industry in 2022 and beyond
## Kubernetes evolution beyond running containers
