# Canary Deployments To Kubernetes Using Istio And Friends

## Abstract

This talk will guide you through the journey of practical implementation of canary deployments. We'll use Kubernetes because it makes many things easier than any other platform before it. We'll need service mesh because, after all, most of the canary process is controlled through networking and changes to Kubernetes definitions. We'll need a few other tools, and we might even need to write our own scripts to glue everything into a cohesive process.

The end result will be a set of instructions and a live demo of a fully operational canary deployment process that can be plugged into any continuous delivery tool. We'll define the process, and we'll choose some tools. Nevertheless, we'll do all that while making the process agnostic and applicable to any toolset you might pick.

# Testing In Production

## Abstract

No matter how much we try, the only real validation of a release is how it behaves when running in production. We all know that. But, where we might disagree is which types of validations are needed. Should we run the same tests in production as those we're running in staging? Are we talking about the same technology but potentially different test scenarios? Or is it something completely different?

TLDR; it is something completely different.