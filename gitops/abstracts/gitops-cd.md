# Managing Full Application Lifecycle Using GitOps

## Abstract

GitOps is nothing new. Or, to be more precise, the principles of GitOps existed long before the term was invented. But hey, that's the pattern in our industry. It is the fate of all good practices to be misunderstood, so we need to come up with new names to get people back on track. That is not to say that we are in a constant loop. Instead, I tend to think of it as a periodic reset trying to eliminate misinterpretations. GitOps is one of those resets. It fosters the practices and the ideas that existed for a while now and builds on top of them.

We'll explore the fundamental principles of GitOps and the outcomes of those principles. We also try to answer some fundamental questions like "why do we want GitOps?", "why isn't everyone using GitOps?", and whether GitOps is mature enough for everyone to adopt it. More importantly, we'll try to see how GitOps fits into continuous delivery and how it might change the way we define application lifecycle pipelines.

Through a hands-on demo, we'll explore a full lifecycle of applications in production. We'll use Terraform to create and manage a Kubernetes cluster and Argo CD to deploy applications. We'll rely on Codefresh to run pipelines that will tie those and other tools together.

# Kubernetes GitOps for Mere Mortals

## Abstract

GitOps is the gold standard for managing and deploying Kubernetes applications. In this talk, we’ll show you how we use Helm and Argo CD to manage our deployments to a wide range of clusters and clouds.

Codefresh operates a global SaaS product in the cloud using Kubernetes. CloudPosse helps companies like PeerStreet, RMS, Sportech, and others migrate to Kubernetes. Between the two of us, we’ve deployed to every cloud and in almost any kind of situation. We’ve built an established, well-worn path for using the principles of “GitOps” to take advantage of Kubernetes declarative infrastructure in order to deploy more often, and with more reliability.
 
In this session, you’ll learn the principles of GitOps and how it solves both technology and organizational problems around CI/CD, Kubernetes application drift, and traceability through the engineering process.