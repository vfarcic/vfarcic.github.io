# Talk: Running Continuous Delivery At Scale

## Abstract

Jenkins X was committed from the very beginning of its existence at creating a platform that can scale to accomodate any volume. Almost nothing is running when at rest. Processes are created on demand, and shut down when not in use. It can accomodate (almost) any number of concurrent pipelines given that there is sufficient compute capacity. But that type of scaling is not the subject of this talk. Instead, we'll explore how to scale your environments.

How can we use Jenkins X to manage deployments to one, ten, or thousands of clusters? Can we do that without any significant resource overhead and be efficient at the same time? Can we employ GitOps principles when deploying at scale?

We'll explore the newly released feature that allows us to attach any number of clusters to the platform and manage them through Jenkins X.
