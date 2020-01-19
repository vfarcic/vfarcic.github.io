# Requirements

## General

* [Git](https://git-scm.com/)
* GitBash (if using Windows)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* GitHub account
* [Helm v2.x](https://github.com/helm/helm/releases) (IT CANNOT BE HELM v3.x)

If you choose to use your own account, please follow the instructions for the cloud-specific requirements. If you're in doubt which one to choose, I strongly recommend GKE. If you register, you'll get 300$ in free credit and we won't spend more than a few $ during the workshop. On the other hand, if you do choose to use the cluster that will be available (and prepared by me) during the workshop, there is nothing else you need to do in advance.

If you are a **Windows user**, make sure that **TTY is enabled**. A simple test to detect whether TTY is enabled, assuming that you have Docker Desktop running, is as follows.

```bash
docker container run --rm -it alpine sh

exit
```

If that produced an error, TTY is disabled. You will need to **enable TTY**. If you don't know how to do that, the alternative is to run Google Cloud Shell and, in that case, you will need a Google Cloud Platform account.

You can choose to have a cluster in you own Google (GKE), Amazon (EKS), or Azure (AKS) account, or you can use one that will be available to you during the workshop.

## GKE (GCP)

Please make sure that you have the tools that follow installed.

* [gcloud CLI](https://cloud.google.com/sdk/docs/quickstarts)

You'll need **Google Cloud Platform (GCP) admin permissions**. If you don't have the account or the one you're using does not have admin permissions, please create a personal account by visiting [cloud.google.com](https://cloud.google.com/). You'll get $300 of free credit.

Please make sure you have the name of a GCP project ready. If you don't have one, you can follow the instructions from the [Creating and Managing Projects](https://cloud.google.com/resource-manager/docs/creating-managing-projects) documentation.

To be on the safe side and confirm that you can create a GKE cluster, please execute the commands that follow.

```bash
gcloud auth login

gcloud container clusters \
    create jxrocks \
    --region us-east1 \
    --machine-type n1-standard-1 \
    --enable-autoscaling \
    --num-nodes 1 \
    --max-nodes 3 \
    --min-nodes 1

kubectl create clusterrolebinding \
    cluster-admin-binding \
    --clusterrole cluster-admin \
    --user $(gcloud config get-value account)

gcloud container clusters \
    delete jxrocks \
    --region us-east1 \
    --quiet
```

Those commands created a GKE cluster and destroyed it right away. Their purpose was only to validate whether you are able to create a GKE cluster. We'll create a new cluster during the training.

Please contact me on [DevOps20](http://slack.devops20toolkit.com/) Slack channel (my user is *vfarcic*) if you encountered any problems.

## EKS (AWS)

Please make sure that you have the tools that follow installed.

* [AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
* [eksctl](https://github.com/weaveworks/eksctl)

You'll need **Amazon Web Services (AWS) admin permissions**. If you don't have the account or the one you're using does not have admin permissions, please create a personal account by visiting [aws.amazon.com](https://aws.amazon.com/account/).

Please make sure you have the name of a GCP project ready. If you don't have one, you can follow the instructions from the [Creating and Managing Projects](https://cloud.google.com/resource-manager/docs/creating-managing-projects) documentation.

To be on the safe side and confirm that you can create an EKS cluster, please execute the commands that follow.

```bash
export AWS_ACCESS_KEY_ID=[...] # Replace [...] with AWS access key ID

export AWS_SECRET_ACCESS_KEY=[...] # Replace [...] with AWS secret access key

export AWS_DEFAULT_REGION=us-west-2

eksctl create cluster \
    -n jx-rocks \
    -r $AWS_DEFAULT_REGION \
    --kubeconfig kubecfg-eks \
    --node-type t2.small \
    --nodes 3 \
    --nodes-max 9 \
    --nodes-min 3

eksctl delete cluster -n jx-rocks
```

Those commands created an EKS cluster and destroyed it right away. Their purpose was only to validate whether you are able to create an EKS cluster. We'll create a new cluster during the training.

Please contact me on [DevOps20](http://slack.devops20toolkit.com/) Slack channel (my user is *vfarcic*) if you encountered any problems.

## AKS (Azure)

Please make sure that you have the tools that follow installed.

* [az CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

You'll need **Azure admin permissions**. If you don't have the account or the one you're using does not have admin permissions, please create a personal account by visiting [azure.microsoft.com](https://azure.microsoft.com/en-us/free/). You'll get $200 of free credit.

To be on the safe side and confirm that you can create an AKS cluster, please execute the commands that follow.

```bash
az login

az provider register -n Microsoft.Network

az provider register -n Microsoft.Storage

az provider register -n Microsoft.Compute

az provider register -n Microsoft.ContainerService

az group create \
    --name jxrocks-group \
    --location eastus

az aks create \
    --resource-group jxrocks-group \
    --name jxrocks-cluster \
    --node-count 3 \
    --node-vm-size Standard_D4s_v3 \
    --generate-ssh-keys \
    --kubernetes-version 1.11.5

az group delete \
    --name jxrocks-group \
    --yes
```

Those commands created an AKS cluster and destroyed it right away. Their purpose was only to validate whether you are able to create an AKS cluster. We'll create a new cluster during the training.

Please contact me on [DevOps20](http://slack.devops20toolkit.com/) Slack channel (my user is *vfarcic*) if you encountered any problems.
