## Prerequisites

The training assumes that you already know how to operate a Kubernetes cluster so we won't go into details how to create one nor we'll explore Pods, Deployments, StatefulSets, and other commonly used Kubernetes resources. If that assumption is not correct, you might want to read [The DevOps 2.3 Toolkit: Kubernetes](https://amzn.to/2GvzDjy) first.

Apart from assumptions based on knowledge, there are some technical requirements as well. If you are a **Windows user**, please run all the examples from **Git Bash**. It will allow you to run the same commands as MacOS and Linux users do through their terminals. Git Bash is set up during [Git](https://git-scm.com/download/win) installation. If you don't have it already, please re-run Git setup.

Since we'll use a Kubernetes cluster, we'll need **[kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)**. Most of the applications we'll run inside the cluster will be installed using **[Helm](https://helm.sh/)**, so please make sure that you have the client installed as well. Finally, install **[jq](https://stedolan.github.io/jq/)** as well. It's a tool that helps us format and filter JSON output.

Finally, we'll need a Kubernetes cluster. All the examples are tested using **Google Kubernetes Engine (GKE)**, **Amazon Elastic Container Service for Kubernetes (EKS)**, and **Azure Kubernetes Service (AKS)**.

If you're unsure which Kubernetes flavor to select, choose GKE. It is currently the most advanced and feature-rich managed Kubernetes on the market. On the other hand, if you're already used to EKS or AKS, they are, more or less, OK as well.

The commands specific for each of the three Cloud providers are below. Please register on [DevOps20](http://slack.devops20toolkit.com/) Slack channel and contact me directly if you have any issue creating your cluster. My Slack username is **vfarcic**.

## Prerequisites for AWS EKS

We'll need an up-and-running EKS cluster before the training. Feel free to reuse an existing cluster if you already have it or to create a new one for this training. You can use the commands that follow as inspiration.

```bash
# Make sure that you're using eksctl v0.1.5+.

# Follow the instructions from https://github.com/weaveworks/eksctl to intall eksctl.

export AWS_ACCESS_KEY_ID=[...] # Replace [...] with AWS access key ID

export AWS_SECRET_ACCESS_KEY=[...] # Replace [...] with AWS secret access key

export AWS_DEFAULT_REGION=us-west-2

export NAME=devops25

mkdir -p cluster

eksctl create cluster \
    -n $NAME \
    -r $AWS_DEFAULT_REGION \
    --kubeconfig cluster/kubecfg-eks \
    --node-type t2.small \
    --nodes 3 \
    --nodes-max 9 \
    --nodes-min 3

export KUBECONFIG=$PWD/cluster/kubecfg-eks
```

## Prerequisites for GCP GKE

We'll need an up-and-running GKE cluster before the training. Feel free to reuse an existing cluster if you already have it or to create a new one for this training. You can use the commands that follow as inspiration.

```bash
# Follow the instructions from https://cloud.google.com/sdk/install to install gcloud.

gcloud auth login

REGION=us-east1

MACHINE_TYPE=n1-standard-1

gcloud container clusters \
    create devops25 \
    --region $REGION \
    --machine-type $MACHINE_TYPE \
    --enable-autoscaling \
    --num-nodes 1 \
    --max-nodes 3 \
    --min-nodes 1

kubectl create clusterrolebinding \
    cluster-admin-binding \
    --clusterrole cluster-admin \
    --user $(gcloud config get-value account)
```

## Prerequisites for Azure AKS

We'll need an up-and-running AKS cluster before the training. Feel free to reuse an existing cluster if you already have it or to create a new one for this training. You can use the commands that follow as inspiration.

```bash
az login

az provider register -n Microsoft.Network

az provider register -n Microsoft.Storage

az provider register -n Microsoft.Compute

az provider register -n Microsoft.ContainerService

az group create \
    --name devops25-group \
    --location eastus

export VM_SIZE=Standard_B2s

export NAME=devops25

az aks create \
    --resource-group $NAME-group \
    --name $NAME-cluster \
    --node-count 3 \
    --node-vm-size $VM_SIZE \
    --generate-ssh-keys \
    --kubernetes-version 1.11.5

rm -f $PWD/cluster/kubecfg-aks

az aks get-credentials \
    --resource-group devops25-group \
    --name devops25-cluster \
    -f cluster/kubecfg-aks

export KUBECONFIG=$PWD/cluster/kubecfg-aks
```




## Something

```bash
kubectl create \
    -f https://raw.githubusercontent.com/vfarcic/k8s-specs/master/helm/tiller-rbac.yml \
    --record --save-config

helm init --service-account tiller
```