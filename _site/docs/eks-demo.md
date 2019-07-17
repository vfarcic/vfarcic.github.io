## Hands-On Time

---

# Creating An EKS Cluster


## Prerequisites

---

* [Git](https://git-scm.com/)
* GitBash (if Windows)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [AWS CLI](https://aws.amazon.com/cli/)
* [eksctl](https://github.com/weaveworks/eksctl)
* [aws-iam-authenticator](https://github.com/kubernetes-sigs/aws-iam-authenticator) (follow the instructions from the "**install aws-iam-authenticator for Amazon EKS**" section in [Getting Started with Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html))
* AWS admin permissions


## Getting The Code

---

```bash
git clone https://github.com/vfarcic/k8s-specs.git

cd k8s-specs
```


## Getting The Code

---

* We cloned the repository that contains (almost) all the examples we'll use in this course


## Creating A Cluster

---

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


## Creating A Cluster

---

* We created a few environment variable that allow us to connect to AWS API
* We created a 2 node cluster with managed masters using `eksctl`.
* We set `KUBECONFIG` variable to the path of the configuration created through `eksctl`.
* We confirmed that the cluster is accessible by listing the nodes using `kubectl`.