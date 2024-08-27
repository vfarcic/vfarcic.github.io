# Automate Everything: How One Manifest Powers Your Entire DevOps Pipeline

In this talk I want to get back to the first steps when developer platforms are concerned. I want to enable developers to start a new project through an **easy interface** to specify a programming language, whether to use a database, whether to use GitOps, and a few other things.

For simple and customizable interfaces to work, much more needs to happen behind the scenes. Manifests based on such interfaces need to be **synced into the Crossplane control plane** only to be taken over by processes that create and manage a Git repositories, files like the initial source code of applications, CI pipelines like GitHub Actions, build scripts like Earthly, GitOps references like those for Argo CD, Kubernetes manifests, and much much more.

In other words, I expect an easy interface for everything and complexity hidden inside a control plane and behind an API.

In this talk we'll explore how it all works and how to do all that (and much more).
