## Hands-On Time

---

# Creating An EKS Cluster


## Prerequisites

---

* [Git](https://git-scm.com/)
* GitBash (if Windows)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [eksctl](https://github.com/weaveworks/eksctl)
* [aws-iam-authenticator](https://github.com/kubernetes-sigs/aws-iam-authenticator)
* AWS admin permissions


## Getting The Code

---

```bash
git clone https://github.com/vfarcic/k8s-specs.git

cd k8s-specs
```


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
    --node-type t2.medium --nodes 2

export KUBECONFIG=$PWD/cluster/kubecfg-eks

kubectl get nodes
```
