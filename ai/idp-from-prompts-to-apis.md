# From Prompts to APIs


<!-- .slide: data-background="img/idp-solution-capabilities.jpeg" data-background-size="contain" data-background-color="black" -->

Note:
The AI should be using the Kubernetes API to discover what's available.

But here's the catch: you can't do semantic search against the Kubernetes API directly. If you want an AI to intelligently find the right resources for a given intent, you need to convert those Kubernetes API definitions and CRDs into embeddings and store them in a Vector database. I call these **capabilities**.

So what exactly are capabilities? Let me explain this concept because it's absolutely fundamental to building AI that actually understands your infrastructure.


<!-- .slide: data-background="img/capabilities-01.png" data-background-size="contain" data-background-color="black" -->

Note:
Here's the thing: the capabilities we need are already there. The Kubernetes API acts as a single, unified control plane (1)...


<!-- .slide: data-background="img/capabilities-02.png" data-background-size="contain" data-background-color="black" -->

Note:
...that can manage resources not just inside the cluster itself, but also external resources in AWS, Google Cloud, Azure, and pretty much anywhere else you can think of (2).

This is crucial for two reasons. First, it gives AI a single API to work with instead of having to learn dozens of different cloud provider APIs, tools, and interfaces. Instead of the AI needing to understand AWS CLI, Azure CLI, Google Cloud CLI, Terraform, Pulumi, and who knows what else, it just needs to understand one thing: the Kubernetes API.

Second, and this is equally important: by controlling which API endpoints and resource types are available in your Kubernetes cluster, you're defining the scope of what can and should be done. You're not giving AI access to everything under the sun. You're curating a specific set of capabilities that align with your organization's standards and policies.


<!-- .slide: data-background="img/capabilities-03.png" data-background-size="contain" data-background-color="black" -->

Note:
But here's where we hit a problem: the AI agent can't figure out which resource definitions might match a user's intent (3). What's it supposed to do, go through every single resource definition in your cluster every time someone asks for something? That would be insane. There are potentially hundreds or thousands of custom resources, and there's no semantic search capability in the Kubernetes API.


<!-- .slide: data-background="img/capabilities-04.png" data-background-size="contain" data-background-color="black" -->

Note:
So here's the solution: if we convert the relevant information from the Kubernetes API into embeddings (4)...


<!-- .slide: data-background="img/capabilities-05.png" data-background-size="contain" data-background-color="black" -->

Note:
...and store them in a Vector database (5)...


<!-- .slide: data-background="img/capabilities-06.png" data-background-size="contain" data-background-color="black" -->

Note:
...then the AI can perform semantic search and actually find what it's looking for (6). Instead of blindly iterating through every resource definition, it can intelligently search for resources that match the intent.

So that's capabilities: teaching AI what infrastructure resources are available. But knowing what's available is only part of the equation. The AI also needs to understand how your organization actually uses those resources.

