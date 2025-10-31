# Tracing the Unpredictable: OpenTelemetry for AI Agents

## Abstract

Building AI agents is an exercise in taming uncertainty. We design them to be flexible and autonomous, yet we need to maintain visibility and control. But here's the challenge: when you deploy an AI agent, you can't predict what will happen. You don't know what users will ask, which context will be sent to LLMs, which tools the agent will execute, or what the responses will be. How can we improve and debug systems when we can't see what's happening inside them?

This problem isn't new. We've faced it before with distributed systems. When a user request enters your frontend and bounces between microservices, functions, databases, and external APIs, tracking its journey is critical. The trajectory of these requests is complex and often unpredictable. That's exactly why we use OpenTelemetry tracing in cloud-native applications.

AI agents present the same observability challenge, just with different actors. Instead of requests flowing through microservices, we have interactions flowing between users, agents, LLMs, and tools. A single user query might trigger multiple LLM calls, execute various tools, spawn sub-agents, and involve numerous decision points, all in an unpredictable sequence.

OpenTelemetry is rapidly becoming the emerging standard for AI agent observability. With dedicated semantic conventions for generative AI, native support in frameworks like LangChain and LangGraph, and growing ecosystem adoption, it provides the same distributed tracing capabilities we rely on in Kubernetes environments, now extended to AI workflows.

In this talk, you'll learn:
- Why AI agents create new observability challenges
- How OpenTelemetry tracing captures interactions between users, agents, LLMs, and tools
- The new GenAI semantic conventions and what they mean for your AI applications
- Practical implementation patterns for instrumenting AI agents with OpenTelemetry
- How to integrate AI observability into your existing Kubernetes monitoring stack
- Real-world examples of debugging multi-agent systems using distributed traces

Whether you're building autonomous agents, RAG pipelines, or LLM-powered applications on Kubernetes, this session will show you how to apply familiar observability patterns to tame the uncertainty of AI systems.

**Target Audience:** Platform engineers, SREs, and developers building or operating AI-powered applications in cloud-native environments.

**Takeaway:** Attendees will understand how to apply OpenTelemetry tracing to AI agents and gain practical knowledge for implementing observability in their AI systems.

## Short Abstract

Building AI agents means taming uncertainty. You can't predict what users will ask, which context gets sent to LLMs, which tools execute, or what responses emerge. How can we debug what we can't see?

We solved this using OpenTelemetry tracing for distributed systems. When requests bounce between microservices, functions, and APIs, tracking their journey is critical. AI agents present the same challenge—interactions flow between users, agents, LLMs, and tools in unpredictable sequences.

OpenTelemetry is becoming the standard for AI observability, with GenAI semantic conventions and native support in major AI frameworks.

You'll learn how OpenTelemetry captures AI agent interactions, the GenAI semantic conventions, practical implementation patterns, and debugging multi-agent systems with distributed traces. Plus, how to integrate AI observability into your Kubernetes monitoring stack with real-world examples of troubleshooting autonomous agents and RAG pipelines in production.

## Benefits to the Ecosystem

This talk directly benefits the CNCF community by bridging cloud-native observability practices with the rapidly growing AI workload landscape. As organizations deploy AI agents on Kubernetes, they need observability solutions that integrate seamlessly with their existing monitoring infrastructure. By demonstrating how OpenTelemetry (CNCF graduated project) extends naturally to AI observability, this session helps platform engineers and SREs leverage their existing expertise and tools for emerging AI use cases. It promotes standardization in AI observability through CNCF projects, preventing fragmentation and proprietary lock-in. Additionally, it strengthens OpenTelemetry's position as the universal observability standard by showcasing its applicability beyond traditional distributed systems to modern AI architectures running on Kubernetes.

## Open Source Projects Used

- OpenTelemetry (CNCF Graduated)
- Kubernetes (CNCF Graduated)
- Jaeger (CNCF Graduated)
