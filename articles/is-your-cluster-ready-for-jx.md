# Is Your Cluster Ready For Jenkins X?

If you're reading this, the chances are that you do not want to use `jx cluster create` to create a new cluster that will host Jenkins X. That is OK, or even welcome. That likely means that you are already experienced with Kubernetes and that you already have applications running in Kubernetes. That's a sign of maturity and your desire to add Jenkins X to the mix of whichever applications you are already running there. After all, it would be silly to create a new cluster for each set of applications.

However, using an existing Kubernetes cluster is risky. Many people think that they are so smart that they will assemble their Kubernetes cluster from scratch. "We're so awesome that we don't need tools like Rancher to create a cluster for us." "We'll do it with `kubeadm`." Then, after a lot of sweat, we announce that the cluster is operational, only to discover that there is no StorageClass or that networking does not work. So, if you assembled your own cluster and you want to use Jenkins X inside it, you need to ask yourself whether that cluster is set up correctly. Does it have everything we need? Does it comply with standards, or did you tweak it to meet your corporate restrictions? Did you choose to remove StorageClass because all your applications are stateless? Were you forced by your security department to restrict communication between Namespaces? Is the Kubernetes version too old? We can answer those and many other questions by running compliance tests.
<!--more-->

Before we proceed, we'll verify whether the cluster we're hoping to use meets the requirements. Fortunately, `jx` has a command that can help us. We can run compliance tests and check whether there is anything "suspicious" in the results. Among many other things, `jx` has its own implementation of the [sonobuoy](https://github.com/heptio/sonobuoy) SDK.

So, what is sonobuoy? It is a diagnostic tool that makes it easier to understand the state of a Kubernetes cluster by running a set of Kubernetes conformance tests in an accessible and non-destructive manner.

Sonobuoy supports Kubernetes versions 1.11, 1.12 and 1.13, so bear that in mind before running it in your cluster. As a matter a fact, if your Kubernetes cluster is older than that, you likely think that creating a cluster is a one-time deal and that there is nothing to maintain or upgrade.

Given that I do not know whether your cluster complies with Kubernetes specifications and best practices, I cannot guarantee that Jenkins X installation will be successful. Compliance tests should give us that kind of comfort.

Before we proceed with compliance, I must warn you that the execution lasts for over an hour. Is it worth it? That depends on your cluster. Jenkins X does not need anything "special". It assumes that your Kubernetes cluster has some bare minimums and that it complies with Kubernetes standards. If you created it with one of the Cloud providers and you did not go astray from the default setup and configuration, you can probably skip running the compliance tests.

On the other hand, if you baked your own Kubernetes cluster, or if you customized it to comply with some corporate restrictions, running compliance tests might be well worth the wait. Even if you're sure that your cluster is ready for Jenkins X, it's still a good idea to run them. You might find something you did not know exists or, to be more precise, you might see that you are missing things you might want to have.

Anyway, the choice is yours. You can run the compliance tests and wait for over an hour, or you can be brave and skip right into [Installing Jenkins X In An Existing Kubernetes Cluster](#jx-install).

```bash
jx compliance run
```

Once the compliance tests are running, we can check their status to see whether they finished executing.

```bash
jx compliance status
```

The output is as follows.

```
Compliance tests are still running, it can take up to 60 minutes.
```

If you got `no compliance status found` message instead, you were too hasty, and the tests did not yet start. If that's the case, re-execute the `jx compliance status` command.

We can also follow the progress by watching the logs.

```bash
jx compliance logs -f
```

After a while, it'll start churning a lot of logs. If it's stuck, you executed the previous command too soon. Cancel with *ctrl+c* and repeat the `jx compliance logs -f` command.

Once you get bored looking at endless logs entries, stop following logs by pressing *ctrl+c*.

The best thing you can do right now is to find something to watch on Netflix since there's at least an hour left until the tests are finished.

We'll know whether the compliance testing is done by executing `jx compliance status`. If the output is the same as the one that follows, the execution is finished.

```
Compliance tests completed. Use `jx compliance results` to display the results.
```

Let's see the results.

```bash
jx compliance results
```

If the statuses of all the tests are `PASSED`, you're probably good to go. I used the word "probably" since there is an infinite number of things you might have done to your cluster that are not covered by the compliance tests. Nevertheless, with everything `PASSED`, it is very likely that everything will run smoothly. By "everything", I don't mean only Jenkins X, but whatever else you're planning to deploy to your cluster.

What happens if one of the tests failed? The obvious answer is that you should fix the issue first. A little less obvious response would be that it might or might not affect Jenkins X and whatever else we'll do in that cluster. Still, no matter whether the issue is going to affect us or not, you should fix it because you should have a healthy and conformant Kubernetes cluster.

We don't need compliance tests anymore, so let's remove them from the system and free some resources.

```bash
jx compliance delete
```
