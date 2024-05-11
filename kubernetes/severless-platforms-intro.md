## What Do We Want?

# Serverless experience

* Here's source code, build it and run it
* Scale it up and down
* Don't ask me unnecessary questions
* Make it simple

# This experience is not available out-of-the-box in Kubernetes

* We need autoscalers
* We need a way to build from source to container
* We need to define the kind of Serverless experience we want
* We need a way to connect functions and infrastructure

# OpenFunction

* We looked at OpenFunctions (https://openfunction.dev)

<a href="https://openfunction.dev"><img src="img/openfunctions-architecture.png" style="width: 70%; height: 70%;"></a>

```sh
cat function.yaml
```

# Questions

* Does this experience work for you? 
* Are the projects used by OpenFunction glued in a way that works for your use case?
* What about application infrastructure that your functions will need? 

# Our findings

* OpenFunctions is great but:
  * It is quite complex for someone who doesn't know all the tools
  * It is hard to debug when things go wrong
* Use OpenFunctions as an inspiration
* Companies want to build their own experiences
  * Maybe you want to have full control on your `functions` interfaces
  * Maybe you want to use GitHub actions to build containers and deploy to environments
  * Maybe you want to use ArgoCD to manage environments using GitOps

# If you want to build your own experience, what do you need?

* Knative Serving
  * From Container to URL
  * Check Knative Functions (CLI / Developer Experience)
* Dapr
  * APIs for developers to
    * Connect functions together
    * Connect to infrastructure and service that are available in the environment
* Crossplane 
  * Provision and wire multi-cloud provider infrastructure

