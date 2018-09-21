# Talk: Continuous Deployment With Jenkins X, Docker, And Kubernetes

## Abstract

Jenkins X, an open source project introduced to the community by CloudBees, enables the rapid creation, delivery and orchestration of cloud-native applications based on continuous delivery best practices and the proven Kubernetes platform.

By combining the power of Jenkins, its community and the power of Docker and Kubernetes, the Jenkins X project provides a path to the future of continuous delivery for microservices and cloud-native applications.

Jenkins X is Jenkins and additional best of breed tools and software for Kubernetes. It provides an interactive command-line interface to instantiate applications, repositories, environments, and pipelines and  orchestrate continuous integration and continuous delivery

It is the CI/CD solution for development of modern cloud applications on Kubernetes

We'll explore some of the features of Jenkins X through a hands-on demo.

# Workshop

## Prerequisites

Please install the tools that follow.

* [Git](https://git-scm.com/)
* GitBash (if Windows)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [eksctl](https://github.com/weaveworks/eksctl)
* [aws-iam-authenticator](https://github.com/kubernetes-sigs/aws-iam-authenticator) (follow the instructions from the "**install aws-iam-authenticator for Amazon EKS**" section in [Getting Started with Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html))

Make sure that you have **AWS admin permissions**. If in doubt, use your personal instead of a corporate account (they are often too restrictive).

You'll need a [Docker Hub account](https://hub.docker.com/). Please register, if you haven't already.

Execute the instructions that follow to confirm that the prerequisites are met. If using Windows, run the commands from GitBash.

First, create AWS **access key ID** and **secret access key**. If you never created them before, please follow the instructions from [Managing Access Keys for Your AWS Account](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html).

Execute the commands that follow.

```bash
# Replace [...] with AWS access key ID
export AWS_ACCESS_KEY_ID=[...]

# Replace [...] with AWS secret access key
export AWS_SECRET_ACCESS_KEY=[...]

export AWS_DEFAULT_REGION=us-west-2

mkdir -p cluster

eksctl create cluster -n devops24 --kubeconfig cluster/kubecfg-eks \
    --node-type t2.medium --nodes 3 -r $AWS_DEFAULT_REGION

export KUBECONFIG=$PWD/cluster/kubecfg-eks

kubectl get nodes
```

If all the commands were successful, the output of the last should display three nodes. It should be similar to the one that follows.

```
NAME                                         STATUS ROLES  AGE VERSION
ip-192-168-175-68.us-west-2.compute.internal Ready  <none> 1m  v1.10.3
ip-192-168-197-18.us-west-2.compute.internal Ready  <none> 1m  v1.10.3
ip-192-168-89-157.us-west-2.compute.internal Ready  <none> 1m  v1.10.3
```

If you got a similar output, you are successful and you're ready for the workshop.

Please use those commands to create a cluster shortly before the workshop starts. That'll save us 15-20 minutes thus allowing us to jump into continuous deployment straight away.

Please execute the command that follows to delete the cluster (we'll create a new one shortly before the workshop).

```bash
eksctl delete cluster -n devops24
```

If you have problems fulfilling the requirements, please contact me through [DevOps20](http://slack.devops20toolkit.com/) Slack (my user is vfarcic) or send me an email to viktor@farcic.com.