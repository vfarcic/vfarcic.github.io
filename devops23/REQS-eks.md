## Requirements

You will need:

* [Git](https://git-scm.com/)
* GitBash (only if using Windows; it's installed with Git)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [Minikube](https://github.com/kubernetes/minikube/releases)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (or any other virtualization supported by minikube)
* [AWS account](https://aws.amazon.com/)
* [AWS CLI](https://aws.amazon.com/cli/)
* [eksctl](https://github.com/weaveworks/eksctl)
* [jq](https://stedolan.github.io/jq/)
* [Docker For Windows](https://www.docker.com/docker-windows), [Docker For Mac](https://www.docker.com/docker-mac), or [Docker Server](https://docs.docker.com/install/#server) if using Linux
* [Docker Hub Account](https://hub.docker.com/)
* [Helm](https://helm.sh/docs/using_helm/#installing-helm)

If you are a Windows user, please make sure that your Git client is configured to check out the code *AS-IS*. Otherwise, Windows might change carriage returns to the Windows format. You will also need an [AWS account](https://aws.amazon.com/) and [AWS CLI](https://aws.amazon.com/cli/). Please note that it should be free from any customizations and limitations your company might have introduced. If in doubt, please use your personal account.

Follow the instructions from https://github.com/weaveworks/eksctl to intall eksctl.

Please double check that AWS EKS works by executing:

```bash
export AWS_ACCESS_KEY_ID=[...] # Replace [...] with AWS access key ID

export AWS_SECRET_ACCESS_KEY=[...] # Replace [...] with AWS secret access key

export AWS_DEFAULT_REGION=us-west-2

mkdir -p cluster

eksctl create cluster -n devops23 -r $AWS_DEFAULT_REGION \
    --kubeconfig cluster/kubecfg-eks --node-type t2.small \
    --nodes 3 --nodes-max 9 --nodes-min 3

export KUBECONFIG=$PWD/cluster/kubecfg-eks

# Confirm that the nodes are created and joined the cluster
kubectl get nodes

# Delete the cluster, we'll create it again during the workshop
eksctl delete cluster -n devops24
```

