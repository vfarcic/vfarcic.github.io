# Modelplane talk: current-state research and adaptation plan

## Source and baseline

- Manuscript: `../devops-catalog/manuscript/infrastructure-as-code/modelplane.md`.
- Manuscript metadata: `../devops-catalog/manuscript/infrastructure-as-code/modelplane.yaml`; publication date July 20, 2026.
- Existing proposal: `ai/abstracts/modelplane.md`.
- Project: <https://github.com/modelplaneai/modelplane>.
- Research date: October 3, 2026.
- Presentation baseline: **v0.5.0**, released October 2, 2026.
- Reviewed release source: tag `v0.5.0`, commit `4616c916a88a419d2fda9eec99493f7ef15e56d6`.
- Release notes: <https://github.com/modelplaneai/modelplane/releases/tag/v0.5.0>.

The talk should feature Modelplane as a continuously reconciling inference control plane: provisioning, scheduling, scaling, routing, and caching. Fleet telemetry makes that system observable. Preserve the manuscript's conversational voice and its central division of responsibility between platform teams and developers, including application engineers rather than only ML specialists.

The narrative is problem-first, solution-second, implementation-third. Omit the
manuscript's short project-announcement opener ("We've been working on something
new"). Use its fleet-management problem and two tangled responsibilities as the
backbone, explain the control-plane approach, then introduce Modelplane as a
concrete implementation. The conference talk is about the architecture and its
practical outcome rather than announcing a project.

The cover, demo, diagram, and closing notes now contain adapted spoken narration,
using the manuscript's fleet-management, platform/developer split, hardware
contract, deployment, request, and recap prose as their backbone. Execution-only
instructions are occasional italic lines; repetitive presenter-cue labels are
omitted. New narration covers the added scaling beat and current architecture.

## Current implementation and validation status

The runnable demo now follows the existing NuShell layout: user-facing `dot.nu`,
shared scripts copied from `../nu-scripts` into `scripts/`, and Modelplane-specific
orchestration in `scripts/modelplane.nu`. Setup is one `./dot.nu setup` command,
followed by `source .env`. The scripts use the current Crossplane v2.4.2 chart and
Modelplane v0.5.0; the KinD image remains explicitly pinned to the upstream
Modelplane installation example. Generic helper updates are made in nu-scripts
first and copied into the demo repository.

The initial offline checks covered NuShell parsing, CLI availability, Helm
rendering, manifest schemas, and mocked setup/query/teardown paths. The executable
demo slides remain a validation draft; narration and timing depend on the live
validation results below.

Live validation update (October 5): AWS control-plane provisioning succeeded, but
both the original xlarge GPU instances and the next-size instances hit real
capacity failures. That attempt was fully destroyed; direct AWS checks found no
matching clusters, VPCs, instances, NAT gateways, volumes, Elastic IPs, EFS
filesystems, or IAM roles/policies remaining. Setup now supports one selected
provider, `aws` or `google`, with provider-specific manifests and a shared model
deployment. Google setup creates a unique project for each fresh run and records
ownership for resume and destroy. GCP setup validation completed successfully:
three ready clusters, one L4 plus two A100 instances, a ready gateway, and a
successful external health check. A bounded HTTP readiness retry fixed the initial
load-balancer timing race. Models remain undeployed for the user's live-demo
review; token generation and model-startup timing have not yet been validated.

## Corrections to carry into the speaker notes and demos

| Earlier material | Current treatment |
| --- | --- |
| The abstract says every workload becomes a KServe `LLMInferenceService`. | Replace this architecture. A standalone engine becomes a Kubernetes Deployment. A multi-node engine becomes a LeaderWorkerSet on the Standard stack or a Grove PodCliqueSet on the Dynamo stack. Both use cluster-edge routing with an llm-d endpoint picker. |
| The manuscript puts `engines` directly under `ModelDeployment.spec`. | Move the replica shape under `spec.template.spec`; `spec.replicas` stays at the deployment level. Labels on the replica template also propagate to endpoints. |
| The client reads `ModelService.status.address` and requests the Hugging Face model ID. | Read the gateway's `status.endpoints.openAI` and request `<namespace>/<service>`, e.g. `ml-team/qwen`. The gateway resolves that name and rewrites it for the selected backend. |
| The front door is a singleton gateway on the control cluster. | `InferenceGateway.spec.clusterName` names an InferenceCluster where the gateway runs. Gateways can be regional, one per inference cluster, and scoped to services by labels. A gateway-only cluster needs no GPU pools. |
| The engine only specifies `--model`. | For the vLLM demo, retain `--model` and add `--served-model-name=$(MODELPLANE_SERVED_MODEL_NAME)` as in the current getting-started manifest. Engine flags remain the developer's responsibility. |
| Provisioning sources are EKS, GKE, and Existing. | Current native sources are EKS, GKE, AKS, Nebius, Vultr, and Civo, plus Existing. Distinguish native provisioning from BYO support and future provider integrations. |
| BYO amounts to a kubeconfig and node labels. | Include dedicated-cluster ownership, a recent DRA-capable Kubernetes version, NVIDIA GPU driver and Container Toolkit, pool labels, a load balancer, and any storage/fabric prerequisites in presenter preparation. Modelplane installs the NVIDIA DRA driver, not the GPU driver itself. |
| The scheduler finds GPUs and places replicas. | Explain the two levels: fleet matching against published classes and node capacity, then workload-cluster scheduling and DRA admission. Fleet accounting charges whole nodes; it is not fine-grained GPU bin-packing. |
| Replicas are shown across regions with an incidental GPU-capacity failure. | Inspect actual placement and conditions. Do not script the old failed second replica as an expected result. Healthy replicas retain their placement; adding a better cluster does not move them automatically. |
| One replica could imply a model split across the fleet. | A replica is a complete serving topology on one cluster. Multi-node engine members share one pool. Prefill/decode engines can use different pools, but remain on the same cluster. The fleet distributes replicas, not one model's tensor parallelism across WAN links. |
| A unified endpoint is the end of the story. | Add stable model names, API-key authentication, weighted rollout entries, priority-based failover, optional external ModelEndpoints, and the distinction between backend resilience and gateway resilience. |
| Weight downloads and monitoring are supporting plumbing. | Introduce ModelCache for per-cluster shared weights and TelemetryDestination/MetricMapping for fleet metrics. Cache hydration supports Hugging Face today; collection is enabled by a TelemetryDestination and requires an external backend for dashboards. |
| Dynamo is only an adjacent project. | Describe the implemented Dynamo stack: Grove, KAI Scheduler, and optional ModelExpress loading. Full Dynamo graph deployment and request-routing integration remain planned. |
| Cleanup deletes clusters before everything composed onto them is gone. | Order teardown around actual dependencies. Current protections block deletion while replicas, gateways, routes, or caches still depend on a cluster. Wait for cloud resources to disappear before deleting the control plane. |

## Proposed talk arc

1. **The hard part is the fleet.** Keep the manuscript's opening: serving one model is relatively straightforward; operating scarce, heterogeneous GPU capacity is the harder problem. Qualify "solved" as the basic serving path, not a claim that inference optimization is trivial.
2. **Two jobs tangled together.** Preserve the platform/developer split. Platform teams publish tested hardware and fleet capacity; developers bring model, engine, and explicit hardware requirements.
3. **One control plane, two APIs.** Build an architecture diagram progressively: control cluster and Crossplane; InferenceClass and InferenceCluster; ModelDeployment; composed ModelReplica and ModelEndpoint; ModelService and regional InferenceGateway. Keep reconciliation separate from the request data path.
4. **Inspect the prepared fleet.** Apply hardware classes, provision clusters, and install the serving stack during pre-talk setup. On stage, show those manifests and the real ready fleet without reapplying infrastructure. Explain native provisioning and the BYO contract from this prepared state.
5. **Declare a model, not a cluster.** Inspect the current vLLM/Qwen manifest, apply it, and show the hardware selector meeting the platform's hardware contract. Inspect ModelReplica placement and readiness.
6. **Reach it through one model name.** Apply ModelService, inspect the InferenceGateway base URL, list models, and send a standard chat-completions request for `ml-team/qwen`.
7. **Change the fleet without changing the client.** Scale the deployment with the Kubernetes scale subresource; inspect new placement and ready endpoints. Show service selection or a weighted rollout while the caller retains the same base URL and model name.
8. **Operate inference as a service.** Explain priority failover, gateway placement, and fleet telemetry. Use real backend metrics if prepared; otherwise inspect the declarative telemetry resources and explain the measurements. Do not invent dashboards or use a few requests as evidence of exact traffic percentages.
9. **The same shape gets bigger.** Briefly explain multi-node gangs, prefill/decode separation, caching, and the Standard/Dynamo choice. Use a current recipe as an honestly identified prepared example instead of waiting for a giant model to load on stage.
10. **Why Crossplane, and where this stops.** Show the actual composition chain. Functions perform fleet scheduling and compose replica resources; providers act on the infrastructure and workload clusters. Explain engine neutrality, current scheduling limits, early-project status, and ways to contribute.

This is a hands-on conference talk. Commands and essential context headings belong on demo slides. Installation, credentials, environment values, and teardown belong in a presenter preparation guide. Convert the manuscript's recordings and fast-forward cues into live actions plus clearly identified prepared checkpoints.

Slow infrastructure work belongs to setup; model deployment and replica scaling
remain live. Use read-only status inspection between explanation beats, and keep
the long readiness waits in the rehearsal guide rather than blocking the talk.

## Updated demo foundation

Keep `../modelplane-demo`, the repository used by the manuscript, as the runnable demo source. Its original fleet-to-model-to-request flow remains appropriate. Update those same manifests against upstream v0.5.0 APIs and prerequisites rather than creating a separate demo repository. The local checkout now contains the adapted manifests, staged setup, request, and teardown scripts, and an execution README. These changes need local cloud/GPU validation before publishing.

Before authoring runnable demo slides:

- Pin the Modelplane package and source checkout to the same rehearsed release. The v0.5.0 tag's install configuration example still names package v0.3.1; do not install it unchanged and assume v0.5 gateway behavior. Main subsequently updates the example to v0.5.0.
- Verify Crossplane and provider requirements against the chosen release. The install docs specify Crossplane v2.3+ and bootstrap prerequisites, which the old setup lacks.
- Resolve documentation drift against source: the FAQ says Kubernetes 1.35+ for workload DRA, while the dedicated existing-cluster requirements specify 1.34.2+. Pin the version actually rehearsed and do not repeat either as an unqualified universal requirement.
- Prepare real GPU capacity, model images and weights, gateway connectivity, and an observability backend ahead of the talk. Use the small Qwen model to keep the core demo affordable and state that it illustrates fleet orchestration rather than demanding multi-node hardware.
- Keep a ready second replica or completed alternate deployment for long cold starts. Identify that checkpoint as previously completed work.
- Rehearse scaling, endpoint withdrawal, and routing separately from cloud provisioning. Scaling to zero is supported, but do not imply automatic wake-on-request without a configured and verified scaler.
- If showing an external fallback, provision a real compatible endpoint and credential and confirm its schema. OpenAI requests cannot route to an Anthropic-only backend; the gateway's Anthropic-to-OpenAI translation is directional.
- Review deployment conditions instead of interpreting `SYNCED` as "the model is serving." Inspect routes as well as endpoints when troubleshooting gateway availability.

Research verifies documentation, release notes, API manifests, and implementation. The real cloud/GPU demo still needs preparation and rehearsal.

## Title options

Working title, matching the existing proposal:

**From GPUs to Endpoints: A Crossplane Control Plane for Self-Hosted Inference**

Recommended alternative:

**Modelplane: One Control Plane for Your GPU Fleet**  
Subtitle: **From GPUs to Self-Hosted Inference**

Other options:

- **Your GPU Fleet, One Inference Platform: Introducing Modelplane**
- **From GPU Clusters to Inference-as-a-Service with Modelplane and Crossplane**

Keep the `ai/modelplane` topic and slug. Once a new title is approved, synchronize the cover, HTML title, abstract heading, and existing catalog entry.

## Proposal alignment to review

The existing abstract promises a KServe-based serving layer and a control-plane inference endpoint. Those details no longer match v0.5.0. Its broader promise of fleet provisioning, hardware-aware placement, self-service inference, and Crossplane extensibility remains appropriate. Review revised proposal language alongside the updated talk rather than carrying those outdated details into the deck.

## Evidence

Version-pinned references used for the update:

- [Architecture and API roles](https://github.com/modelplaneai/modelplane/blob/v0.5.0/docs/content/overview/how-it-works.md)
- [Fleet scheduling and limits](https://github.com/modelplaneai/modelplane/blob/v0.5.0/docs/content/architecture/scheduling.md)
- [Cluster sources, ownership, requirements, and serving stacks](https://github.com/modelplaneai/modelplane/blob/v0.5.0/docs/content/platform/inference-cluster.md)
- [Gateway placement, API names, and authentication](https://github.com/modelplaneai/modelplane/blob/v0.5.0/docs/content/platform/inference-gateway.md)
- [Service weighting, priorities, routing, and requests](https://github.com/modelplaneai/modelplane/blob/v0.5.0/docs/content/models/model-service.md)
- [Replica shape, topologies, and scaling](https://github.com/modelplaneai/modelplane/blob/v0.5.0/docs/content/models/model-deployment.md)
- [Cache sources, storage, and loading](https://github.com/modelplaneai/modelplane/blob/v0.5.0/docs/content/models/model-cache.md)
- [Fleet telemetry and engine mappings](https://github.com/modelplaneai/modelplane/blob/v0.5.0/docs/content/platform/telemetry.md)
- [Current small-model demo manifest](https://github.com/modelplaneai/modelplane/blob/v0.5.0/docs/manifests/getting-started/eks/model-deployment.yaml)
- [Deployment composition pipeline](https://github.com/modelplaneai/modelplane/blob/v0.5.0/apis/modeldeployments/composition.yaml)
- [Actual workload backend selection](https://github.com/modelplaneai/modelplane/blob/v0.5.0/functions/compose-model-replica/function/backends/base.py#L560-L570)
- [Cluster draining and deletion dependencies](https://github.com/modelplaneai/modelplane/blob/v0.5.0/docs/content/platform/drain-cluster.md)
