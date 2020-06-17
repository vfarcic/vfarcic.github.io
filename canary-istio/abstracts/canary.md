# Canary Deployments To Kubernetes Using Istio and Friends

Kubernetes provides a few "decent" deployment strategies out of the box. However, they might not be enough. Canary is missing.

What is the canary deployments process? How should we implement it in Kubernetes? Which tools should we use? We'll try to answer those and quite a few other questions.

This talk will guide you through the journey of practical implementation of canary deployments. We'll use Kubernetes because it makes many things easier than any other platform before it. We'll need service mesh because, after all, most of the canary process is controlled through networking and changes to Kubernetes definitions. We'll need a few other tools, and we might even need to write our own scripts to glue everything into a cohesive process.

The end result will be a set of instructions and a live demo of a fully operational canary deployment process that can be plugged into any continuous delivery tool. We'll define the process, and we'll choose some tools. Nevertheless, we'll do all that while making the process agnostic and applicable to any toolset you might pick.

# Workshop: Canary Deployments To Kubernetes Using Istio and Friends

Kubernetes provides a few "decent" deployment strategies out of the box. However, they might not be enough. Canary is missing.

What is the canary deployments process? How should we implement it in Kubernetes? Which tools should we use? We'll try to answer those and quite a few other questions.

This workshop will guide you through the journey of practical implementation of canary deployments. We'll use Kubernetes because it makes many things easier than any other platform before it. We'll need service mesh because, after all, most of the canary process is controlled through networking and changes to Kubernetes definitions. We'll need a few other tools, and we might even need to write our own scripts to glue everything into a cohesive process.

The end result will be a set of instructions and a hands-on experience of creating a fully operational canary deployment process that can be plugged into any continuous delivery tool. We'll define the process, and we'll choose some tools. Nevertheless, we'll do all that while making the process agnostic and applicable to any toolset you might pick.