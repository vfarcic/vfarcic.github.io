# From GPUs to Endpoints: A Crossplane Control Plane for Self-Hosted Inference

Running your own models instead of paying for a SaaS API sounds simple until you actually have to do it. You have a fleet of GPU clusters spread across regions, providers, and hardware generations. Someone has to decide which model lands on which hardware, how capacity is shared, and what happens when a cluster fills up. Application developers, AI product engineers, and ML teams alike just want a single endpoint they can point their app at. The platform team wants to manage the fleet without becoming an on-call inference helpdesk for the rest of the company. The result is usually a pile of bespoke scripts, hand-rolled operators, and a lot of Slack messages asking "who owns this cluster again?"

In this session, we'll explore Modelplane, an open source control plane that extends Crossplane to manage AI model inference across a fleet of GPU clusters. The pitch comes down to three things.

First, **a unified inference endpoint across a heterogeneous fleet.** OpenAI-compatible APIs are already a de facto standard; what's missing is one endpoint that sits in front of many clusters and many hardware classes, with traffic routed to the right replicas automatically through Envoy Gateway. Consumers don't care which cluster their request lands on, and they don't have to.

Second, **platform teams as internal service providers.** Platform engineers describe their GPU fleet through `InferenceClusters` and define hardware recipes (GPU type, count, topology) as `InferenceClasses`. They set the rules of the road — what hardware exists, where, in which tier — without becoming the bottleneck for every model deployment.

Third, **self-service self-hosted inference for anyone who needs it.** Anyone in the org can create a `ModelDeployment` and get back a working endpoint: ML teams, AI product engineers, backend developers building AI features, internal tooling teams, research groups — anyone who wants the model running on the company's infrastructure instead of someone else's. They don't need to know the difference between an H100 and an A100, which cluster has capacity, or how to wire Envoy. Modelplane's scheduler picks where each replica lands based on capacity and topology and composes the resources underneath.

Modelplane doesn't try to reinvent the per-cluster serving layer. On each workload cluster it composes a KServe `LLMInferenceService`, which in turn runs an inference engine like vLLM (and LeaderWorkerSet for multi-node topologies). The fleet, scheduling, and unified endpoint are what Modelplane adds on top.

Through live demos, we'll provision a multi-cluster GPU fleet, deploy a model across it with a few lines of YAML, and watch traffic land on the right hardware automatically. We'll cover the design decisions behind the API, how Crossplane composition makes the architecture extensible, and how Modelplane relates to projects like KServe, vLLM, and Dynamo — composing the per-cluster stack rather than replacing it, and adding the fleet-level layer that nobody else ships today.

## Short Abstract

Running your own models instead of paying for a SaaS API sounds simple until you have to do it across a fleet of GPU clusters. Modelplane is an open source control plane built on Crossplane that makes self-hosted inference work like an internal service.

Platform teams describe their GPU fleet and hardware classes once, as `InferenceClusters` and `InferenceClasses`. Anyone who needs self-hosted inference — ML teams, AI product engineers, backend developers, internal tooling teams — creates a `ModelDeployment` and gets back a unified, OpenAI-compatible endpoint. Modelplane handles multi-cluster scheduling, composition, and routing through Envoy Gateway, composing KServe and vLLM per cluster rather than replacing them.

In this session, we'll provision a fleet, deploy models across it live, and show how Crossplane composition makes the whole thing extensible.

## Benefits to the CNCF Ecosystem

This session demonstrates how existing CNCF projects compose into a coherent answer for one of the most pressing infrastructure problems in the industry today: serving AI models at scale, on infrastructure you own. Crossplane (Graduated) provides the composition and API extension layer, KServe (Incubating) handles per-cluster model serving, Envoy (Graduated) — via Envoy Gateway — handles unified traffic routing, and Kubernetes (Graduated) remains the substrate. Rather than introducing yet another standalone AI platform, Modelplane shows that the cloud-native ecosystem already has the primitives to build a fleet-level inference control plane, if you compose them well.

The talk also reinforces a pattern the CNCF community has long advocated: clear separation between platform teams and the rest of the organization, expressed through declarative APIs. By making this pattern concrete for GPU and inference workloads, the session helps platform engineers extend their existing Crossplane and Kubernetes expertise into AI infrastructure without reaching for proprietary tooling.

## Key takeaways:

* How a unified, OpenAI-compatible endpoint can sit in front of a heterogeneous, multi-cluster GPU fleet, with traffic routed through Envoy Gateway
* How platform teams use `InferenceCluster` and `InferenceClass` to expose GPU capacity as an internal service without becoming a bottleneck
* How anyone who needs self-hosted inference — not just ML teams — can self-serve by creating a `ModelDeployment`, without knowing anything about the underlying hardware
* How Modelplane's scheduler picks which cluster each replica lands on based on capacity and topology, and how Crossplane composition assembles the per-cluster resources
* Where Modelplane fits next to inference engines (vLLM, Dynamo) and serving frameworks (KServe), and what it deliberately does not try to do
* Practical patterns for extending Modelplane to new cluster sources, hardware classes, and serving engines

## Open Source Projects Used

- Modelplane
- Crossplane (CNCF Graduated)
- KServe (CNCF Incubating)
- Envoy Gateway, part of Envoy (CNCF Graduated)
- Kubernetes (CNCF Graduated)
- vLLM (community-governed, not CNCF)
- LeaderWorkerSet (Kubernetes SIG)
- NVIDIA Dynamo (not CNCF)
