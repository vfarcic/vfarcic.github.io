# Choose Your Own Adventure: Inference

Self-hosting a model looks like one decision: pick a model, pick a GPU, deploy. Then the real decisions show up, and every one of them is a trade-off nobody warned you about. Do you keep the model as precise as it was trained, or shrink it to make room for more conversations? You have two GPUs: do you split one engine across both, or run two copies side by side? Should the model write one token at a time, or let a small draft model guess ahead while the big one checks its work? Each answer sounds reasonable. Each one changes how many people you can serve, how fast they get answers, and sometimes what those answers say.

In this session, you make those decisions. Scan the QR code, and your phone becomes a ballot. Three questions, one per trade-off, and the room votes. The moment the last vote closes, your configuration is applied to a real Kubernetes cluster and starts coming up on two NVIDIA L4 GPUs, right next to a deployment that someone who has done this before already tuned, on identical hardware. Then we race them. The same agent workload hits both, and you can chat with either one from your phone while it runs. Whoever wins, we'll know why.

While your deployment boots, we'll go through what you actually chose. **Quantization**, and why it is less about making a model fit than about buying room for the **KV cache**, the memory every conversation needs and the thing that really decides how many people you can serve. **Tensor parallelism** versus **replicas**, and why splitting one engine across two GPUs is not the same as having two engines. **Speculative decoding**, and why it can make answers faster on a quiet GPU and slower on a busy one. And we'll be honest about the costs: what precision you give up, where it shows up, and why none of these are switched on by default.

Everything runs on open source. Modelplane, a Crossplane-based control plane for inference, turns each configuration into running vLLM engines behind an OpenAI-compatible gateway, with the Gateway API Inference Extension picking which replica serves each request. OpenTelemetry carries the metrics from both deployments, and Datadog puts them side by side, so the verdict comes from the numbers rather than from whoever argues loudest.

The audience might beat the tuned deployment. That's the fun part. Either way, you'll leave knowing which knobs matter, what each one costs, and how to tell which one your own workload needs.

## Short Abstract

Self-hosting a model is a chain of trade-offs. Precision or room for more conversations? One engine across two GPUs, or two copies? One token at a time, or a draft model guessing ahead?

In this session, the audience decides. Everyone votes from their phones, and the winning configuration is deployed live to a Kubernetes cluster through Modelplane, next to a tuned deployment on identical GPUs. While it boots, we'll explain what was chosen: quantization and the KV cache, tensor parallelism versus replicas, and speculative decoding. Then we race the two under the same agent workload, the audience chats with both, and the metrics, through OpenTelemetry and Datadog, pick the winner.

You'll leave knowing which inference knobs matter, what each one costs, and how to choose for your own workload.

## Benefits to the CNCF Ecosystem

Self-hosted inference is landing on Kubernetes, and most guidance still stops at "request a GPU and set replicas." The knobs that decide cost and capacity, such as quantization, tensor parallelism, replica count, and speculative decoding, are usually explained in isolation and rarely measured against each other on the same hardware. This session puts them side by side on a live cluster and lets the audience feel each trade-off by making it.

It also shows CNCF projects composing into a complete inference stack: Kubernetes (Graduated) as the substrate, Crossplane (Graduated) as the control plane underneath Modelplane, Envoy (Graduated) as the gateway, the Gateway API Inference Extension (Kubernetes SIG Network) for model-aware routing, and OpenTelemetry (Incubating) for the metrics. Platform engineers leave with a mental model they can apply to any vLLM-based stack, and with the vocabulary to push back on buying more GPUs when a configuration change would do.

## Key takeaways:

* Why the KV cache, not the size of the model, decides how many people a GPU can serve, and why quantization is mostly a way to buy room for it
* What precision you give up with FP8 weights and an FP8 KV cache, and where it shows up
* The difference between splitting one engine across GPUs (tensor parallelism) and running more copies, and when each one wins
* How speculative decoding speeds up answers, and why it can stop paying off under load
* How Kubernetes routes inference traffic with the Gateway API Inference Extension, and why model-aware routing differs from a plain load balancer
* How to compare two inference deployments with metrics instead of opinions

## Open Source Projects Used

- Modelplane
- Crossplane (CNCF Graduated)
- Kubernetes (CNCF Graduated)
- Envoy, via Envoy AI Gateway (CNCF Graduated)
- Gateway API Inference Extension (Kubernetes SIG Network)
- OpenTelemetry (CNCF Incubating)
- vLLM (community-governed, not CNCF)
