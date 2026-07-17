# A Thousand Mistakes an Hour: Keeping Agents on a Leash with GitOps, Policy, and Crossplane

You're being told to hand your infrastructure over to AI agents. An agent is non-deterministic, it never gets tired, and it can make a thousand mistakes an hour - and production is exactly where a confident wrong answer gets expensive fast. So the real question isn't whether an agent *can* run your infrastructure. It's how you let it, and still sleep at night.

Here's the reframe this talk is built on: non-determinism isn't new. People are non-deterministic too, and we never let an engineer SSH straight into production and run whatever they want. We built pull requests, reviews, policies, and pipelines precisely because humans are fallible. An AI agent - even a whole swarm of them - is just another non-deterministic actor knocking on a door we already learned to lock. The only thing that really changed is speed.

We'll build that lock live, one problem at a time, as a single diagram that grows from "you talking to the cloud" into a full pipeline. We give agents a control plane instead of cloud credentials (Crossplane), so they declare desired state to blessed, compliant-by-construction abstractions - "a database" - instead of firing imperative commands at thousands of raw knobs. We take away direct cluster access entirely, so the only way in is Git, with Argo CD or Flux pulling and reconciling: a complete audit trail, instant rollback, and review - by humans *or* other agents - that you can require or skip. And we add Kyverno: deterministic policy that stops accidental and intentional mistakes whether a change was reviewed or auto-merged. Finally, we put inference itself on the same control plane with Modelplane, so the models your agents call run on infrastructure you own, governed exactly the same way.

The punchline: agents don't need a new platform. They need the cloud-native one you already built - Crossplane, Argo CD/Flux, Kyverno - all CNCF, nothing proprietary. That's the leash that lets you keep the controller in your hands.

## Short Abstract

AI agents are non-deterministic and fast enough to make a thousand mistakes an hour - and production is no place for that. But non-determinism isn't new: we've always guardrailed fallible humans with pull requests, reviews, and policies. This keynote builds the same leash for agents, live, as a single growing diagram. A control plane (Crossplane) lets agents declare compliant desired state instead of firing commands. GitOps (Argo CD/Flux) removes direct cluster access, so nothing reaches production without an audit trail and rollback. Policy (Kyverno) deterministically stops bad changes whether they were reviewed or not. Then the same control plane is extended to inference with Modelplane, so the models agents rely on run on infrastructure you own. Agents don't need a new platform - they need the CNCF one you already run.

## Benefits to the CNCF Ecosystem

This keynote reinforces a message at the heart of the CNCF ecosystem: the primitives to operate AI agents safely already exist and are production-proven. Rather than reaching for a new, proprietary "AI platform," the talk shows Crossplane (Graduated), Argo CD and Flux (Graduated), and Kyverno (Incubating) composing into a complete guardrail for non-deterministic actors - the very pattern the community already uses for humans.

It also extends a principle the CNCF community has long advocated - the separation of platform teams and consumers expressed through declarative APIs - to two new frontiers: AI agents as first-class API consumers, and inference as just another declarative, policy-governed workload. Attendees leave able to apply the pattern immediately with the projects they already run, no new vendor required.

## Key takeaways:

* Why non-determinism - human or AI - is an old, already-solved problem, and how the existing guardrail stack applies directly to agents
* How a control plane (Crossplane) turns imperative cloud access into declarative, compliant-by-construction abstractions that bound an agent's blast radius
* How removing direct cluster access and routing everything through Git (Argo CD/Flux) delivers audit trail, rollback, and review by humans or other agents - required or optional
* Why deterministic policy (Kyverno) is the guarantee that holds whether a change was reviewed, auto-merged, or slipped through
* How the same control plane can govern inference (Modelplane), so the models agents call run on infrastructure you own
* How to assemble the whole thing from graduated and incubating CNCF projects, with nothing proprietary

## Open Source Projects Used

- Crossplane (CNCF Graduated)
- Argo CD (CNCF Graduated)
- Flux (CNCF Graduated)
- Kyverno (CNCF Incubating)
- Kubernetes (CNCF Graduated)
- Modelplane
