# Using AI as a Dynamic Interface for Internal Developer Platforms

Traditionally, software engineers leverage AI primarily for writing code or executing routine tasks. In this session, we present a different approach: employing AI as a dynamic user interface for an Internal Developer Platform (IDP). Rather than forcing developers to interact directly with complex YAML manifests or platform-specific commands, we demonstrate how an AI-driven interface can seamlessly handle the creation, observation, troubleshooting, and deletion of platform services.

Our objective is not to answer generic questions or provide general Kubernetes tutorials, but rather to enable developers to effortlessly consume and manage services specifically provided by the platform without detailed knowledge of underlying implementations. Using an Internal Developer Platform built with Crossplane (though the approach applies broadly to any API-driven infrastructure) we explore how AI can dynamically discover available services, prompt users through wizard-like interactions, and autonomously manage the lifecycle of platform resources.

We illustrate how AI can dynamically discover available resources on-demand, guide users through creating databases and applications, automatically generate the necessary manifests, and assist in observing the status of deployed services. Additionally, we demonstrate the AI system's capabilities in identifying and resolving issues during service provisioning, and in safely deleting platform services.

This work highlights the potential of AI as an intuitive, powerful, and easily maintainable interface for internal platforms, radically simplifying service consumption, management, and troubleshooting for developers.

## Key takeaways:

* Using AI to dynamically interact with platform APIs and resource schemas.
* Designing intuitive, interactive user experiences for developers who lack deep platform knowledge.
* Utilizing custom AI-driven commands to automate complex workflows and enhance developer productivity.
