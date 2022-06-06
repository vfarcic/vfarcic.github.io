# Applying GitOps To Everything

You are likely already using GitOps for your applications, but not for everything else. You are likely not using Argo CD, Flux, Rancher Fleet, or similar tools to manage the state of your infrastructure and services. Why is that? If GitOps is a great solution for apps, isn't it safe to assume that it would be equally beneficial for anything else? What is missing?

The problem is that most of the commonly used GitOps tools are managing Kubernetes resources which, traditionally, do not deal with infrastructure and Cloud services. That's what we need to change. We need to expand Kubernetes with custom resources that can manage anything, no matter whether that's AWS, Azure, Google Cloud, GitHub, Elastic, DataDog, or any other Cloud service. If we do that, we might convert Kubernetes API into a universal API. We might convert the Kubernetes control plane into a universal control plane. If we do that, we will get end-to-end GitOps through which everything is always in sync and where all we have to do is push changes to Git repositories.

All we need to make that happen is Crossplane (an open-source project donated to CNCF), combined with Argo CD, Flux, or Rancher Fleet. Let's see it in action.
