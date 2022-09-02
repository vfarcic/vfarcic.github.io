# How To Apply Automated Drift Detection And Reconciliation To Infrastructure

By now, most of us have experienced the benefits of automated drift detection and reconciliation. Any application running in Kubernetes is benefiting from those. No matter what happens to our resources, Kubernetes will always try to converge the actual into the desired state without human intervention.

Why don't we have those features when working with infrastructure? Why don't we embrace Kubernetes API for everything, and not only for infra? If we do, we'll be able to manage all our resources in the same way and rip the same benefits, no matter whether those resources are applications, infrastructure, services, or anything else.

In this talk, we'll explore the effects of having (and not having) automated drift detection and reconciliation applied on infrastructure and explore Crossplane as one possible solution that enables us to leverage the Kubernetes control plane to manage everything, including infra.

## Benefits To The Ecosystem

Kubernetes drift detection and reconciliation is often limited to containers running inside clusters.

This talk helps bring clarity to Kubernetes' ability to extend itself through CRDs and controllers and, through those extensions, extend the scope of drift-detection and reconciliation to infrastructure and services.

This talk will focus on integration between open source CNCF project Crossplane and GitOps tools like Argo CD and Flux.
