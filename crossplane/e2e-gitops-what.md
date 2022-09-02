# GitOps?

## Declarative
## Versioned and immutable
## Pulled automatically
## Continuously reconciled


# Why Now?

## Chef and Puppet == GitOps
## Flux, Argo CD, Rancher Fleet, and others...
## Kubernetes API makes the difference


# Problems

## Tools NOT GitOps-friendly (e.g., canary)
## Approval flow (e.g., PR)


# Why Only Apps?

## GitOps tools treat k8s as the actual state
## K8s is all about applications (containers)?
## K8s main strength is its API, not containers
## Convert Kube API into the universal API


# Universal Control Plane

## Universal API + universal scheduler
## Manage everything (apps, services, infra)
## Vendor-neutral (everyone is multi-cloud)


# Extending GitOps To Everything

## Universal CP + k8s == Universal GitOps
## Git == the source of truth for everything
## Git == the only interaction point
## Git == a universal RBAC


# What Is Missing?

## Scope (limited to containers)
## Adoption (limited to ops)


<!-- .slide: data-background="linear-gradient(to bottom right, rgba(25,151,181,0.9), rgba(87,185,72,0.9)), url(../img/products/crossplane2.png) center / cover" -->
# Crossplane

## Based on Kube API
## Vendor neutral (CNCF)
## More mature than others
## Shift-left (Compositions)
## Enables e2e GitOps and adopted by everyone
