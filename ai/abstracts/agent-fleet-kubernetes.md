# Your Agents Scale. Your Laptop Doesn't. Running an Agent Fleet on Kubernetes

Running one coding agent is easy. Running a fleet turns your laptop into a shared build server and your attention into the scheduler. Git worktrees keep agents from editing the same working copy. They don't isolate credentials, network access, or resource consumption. Agents running under the same OS user can have access to credentials available to that user. Kubernetes can spread the work across machines. But how do we control what agents can access, how much they can consume, and what happens when their work ends?

This talk follows the progression from local agents and specialist teams to disposable execution environments in Kubernetes clusters. Using the open-source Agent Deck, we'll dispatch a single agent or a whole team into its own environment, follow its progress, and reconnect to its native terminal session. The work keeps running when the laptop disconnects. Results need to survive when the environment disappears.

Then we'll tackle the problems that more compute doesn't solve. Kyverno enforces execution profiles that bound privileges, images, and resource configuration. Cilium restricts which services each unit can reach, with Hubble showing blocked connections. External Secrets Operator supplies project-scoped credentials instead of copying the developer's home directory. Kueue holds work until its resource quota allows it to start. OpenTelemetry connects dispatch, startup, delegation, and completion so we can distinguish an agent waiting for input from a workload waiting for capacity or failing under resource pressure.

Live demonstrations follow those boundaries from an accepted task to a rejected configuration, a blocked connection, and a retained result. Attendees will leave with a practical architecture for a cloud-native agent fleet, an understanding of which controls belong outside the agents, and a clearer view of the bottlenecks that remain: validation, integration, and human judgment.

## Short Abstract

Running one coding agent is easy. Running a fleet turns your laptop into a shared build server and your attention into the scheduler. Git worktrees separate code changes, but not credentials, network access, or resource consumption. This talk uses the open-source Agent Deck to dispatch coding agents and specialist teams into disposable Kubernetes environments while preserving their native terminal sessions. We'll explore Kyverno execution policies, Cilium network boundaries, project-scoped credentials with External Secrets Operator, capacity-aware queues with Kueue, and execution visibility through OpenTelemetry. Live demos follow task launch, a rejected configuration, a blocked connection, and results retained after an environment disappears. Work continues when the laptop disconnects, but more compute doesn't solve everything. Leave with an architecture for a cloud-native agent fleet and an understanding of where validation, integration, and human judgment remain the bottlenecks.

## Benefits to the CNCF Ecosystem

The session applies Kubernetes and CNCF projects to the execution of coding agents, showing how policy, network controls, secret delivery, and telemetry can enhance an existing open-source developer tool. Each integration addresses a concrete operational problem and exposes its outcome through Agent Deck, connecting familiar platform capabilities to the workflows developers use to delegate and inspect agent work.

The architecture separates agent behavior from platform-enforced boundaries and distinguishes disposable compute from durable results. Kubernetes-native queueing with Kueue complements the CNCF components by making capacity constraints visible before work starts. Attendees gain reusable patterns for operating heterogeneous coding agents without depending on one agent client's permission model or replacing its native interface.

## Key takeaways:

* How to run a single agent or specialist team as a Kubernetes execution unit while preserving native terminal access
* Why Git worktrees isolate code changes, and how execution profiles and network policies bound the surrounding environment
* How project-scoped secret delivery avoids giving every unit the developer's full credential environment
* How capacity-aware queues and execution telemetry distinguish resource constraints from agent-level delays and failures
* Why result preservation and cleanup must work without the laptop, and why validation and integration remain scaling bottlenecks

## Open Source Projects Used

- Agent Deck
- Kubernetes
- Kyverno
- Cilium, including Hubble
- External Secrets Operator
- OpenTelemetry
- Kueue (Kubernetes SIG project)
- Git
