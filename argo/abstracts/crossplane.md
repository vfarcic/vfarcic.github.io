# How To Apply GitOps On Infrastructure (For Real)

When managing infrastructure today, we have a few requirements beyond the obvious ones, such as defining everything as code.

* It should be based on GitOps principles
* It should detect drifts automatically and converge the actual (infra) into the desired (Git) state automatically
* It should be based on a common API, potentially the same one we are using for managing other states (e.g., applications)

That means that the definitions should be stored in Git and that there should be a process that monitors the actual state and reconciles drifts continuously. As for the common API, the best candidate we have today is Kubernetes API.

None of the mainstream IaC tools meet those requirements. Chef and Puppet had automatic drift detection and reconciliation, but they are on life-support. Ansible and Terraform can be considered GitOps from the perspective of "we can store definitions in Git," but are not monitoring the infra looking for drifts. Neither of them adopted an existing common API.

Crossplane, on the other hand, meets all those requirements. It uses Kubernetes API and scheduling capability. It continuously monitors the states and performs reconciliation. Since it is inside the Kubernetes ecosystem, we can use GitOps tools like Argo CD and Flux to pull and apply manifests.

In this session, we will explore Crossplane combined with Argo CD as a potential solution for all our infrastructure needs and see whether it fits into the broader Kubernetes ecosystem.
