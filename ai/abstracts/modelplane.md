# From GPUs to Endpoints: A Crossplane Control Plane for Self-Hosted Inference

Getting a model to answer a request is one thing. Making self-hosted inference a service the rest of your company can rely on is another. GPUs are scarce, expensive, and scattered across clusters, regions, and providers. Every new model becomes a negotiation about where it fits, who has capacity, and which endpoint an application should call. Before long, the platform team is an inference helpdesk, and developers are learning infrastructure they never wanted to manage.

The problem is that two different jobs have been tangled together: providing GPU capacity and consuming it. What if platform teams could manage the fleet without knowing every model, and application and ML teams could deploy models without knowing every cluster? That requires more than automating installation. It requires a control plane that continuously connects what a workload needs to what the fleet can provide, while keeping the service applications consume independent of where its replicas happen to run.

This talk builds that idea from the GPU fleet to the application endpoint. We'll explore the boundary between platform ownership and self-service, the difference between placing workloads and routing requests, and why deploying a model is only the beginning. Capacity changes, replicas come and go, and callers should not have to follow those changes around the fleet.

Then we'll make it concrete with Modelplane, an open source inference control plane built on Crossplane. Live demos follow the two sides of the platform: publishing GPU capacity, declaring what a model needs, watching it land on compatible hardware, and calling it through an OpenAI-compatible endpoint. We'll use that working path to examine how the platform adapts as the fleet changes, and where its responsibilities end and the serving engine's begin.

Attendees will leave with an architectural approach to turning GPU infrastructure into a self-service inference platform, plus an honest view of what an early, evolving implementation can do today.

## Short Abstract

Self-hosted inference becomes a platform problem when every model deployment needs the platform team and every infrastructure change reaches the developers. This talk explores how to separate providing GPU capacity from consuming it, connect workload requirements to a heterogeneous fleet, and keep application endpoints independent of replica placement. We'll make those ideas concrete through live demos with Modelplane, an open source control plane built on Crossplane, following a model from declared requirements to a working OpenAI-compatible request. Leave with an architectural approach to inference as an internal service, grounded in a working implementation and its limits.

## Benefits to the CNCF Ecosystem

The session applies a familiar cloud-native principle to inference: teams declare the outcome they need, and a continuously reconciling platform manages the infrastructure behind it. It shows how platform engineers can extend their existing control-plane expertise to GPU fleets while giving application and ML teams a service they can consume independently.

Modelplane provides a concrete example of composing that platform from Crossplane, Kubernetes, Envoy, and OpenTelemetry, alongside inference-specific serving components. The emphasis is on architectural boundaries, reusable platform contracts, and operational visibility, so the lessons apply beyond this particular project. Attendees will understand both how the ecosystem's building blocks fit together and which decisions still belong to the teams operating them.

## Key takeaways:

* Why self-hosted inference becomes a fleet and platform problem beyond the first working model
* How to separate responsibility for GPU capacity from responsibility for deploying and consuming models
* Why workload placement and request routing are different problems, and how a stable service connects them
* How continuous reconciliation lets the platform respond to changes without making callers track the infrastructure
* Where an inference control plane's responsibilities end, how it builds on serving engines, and what Modelplane demonstrates today

## Open Source Projects Used

- Modelplane
- Crossplane
- Kubernetes
- Envoy Gateway
- Envoy AI Gateway
- OpenTelemetry
- vLLM
- llm-d
- LeaderWorkerSet
- NVIDIA Dynamo, including Grove, KAI Scheduler, and ModelExpress
