<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Creating A Jenkins X Cluster

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Prerequisites

* [Git](https://git-scm.com/)
* GitBash (if using Windows)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [Helm](https://helm.sh/) (MUST BE `helm` 2.+)
* If Google: [gcloud CLI](https://cloud.google.com/sdk/docs/quickstarts) and GCP admin permissions
* If Azure: [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) and Azure admin permissions
* If AWS: [AWS CLI](https://aws.amazon.com/cli/) and AWS admin permissions


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Creating A GKE Cluster

```bash
# TODO:
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Creating An EKS Cluster

```bash
# TODO:
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Creating An AKS Cluster

```bash
az login

az provider register -n Microsoft.Network

az provider register -n Microsoft.Storage

az provider register -n Microsoft.Compute

az provider register -n Microsoft.ContainerService

export CLUSTER_NAME=jxworkshop
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Creating An AKS Cluster

```bash
az group create --name $CLUSTER_NAME --location eastus

az aks create --resource-group $CLUSTER_NAME --name $CLUSTER_NAME \
    --node-count 3 --node-vm-size Standard_D4s_v3 --generate-ssh-keys

az aks get-credentials --resource-group $CLUSTER_NAME --name $CLUSTER_NAME
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Jenkins X Boot

```bash
export GH_USER=[...] # Replace `[...]` with your GitHub user

git clone https://github.com/vfarcic/jenkins-x-boot-config-workshop.git \
    environment-$CLUSTER_NAME-dev

cd environment-$CLUSTER_NAME-dev

jx boot
```

* If NOT GKE, open `jx-requirements.yml`
* If NOT GKE, change the `provider` to `aks` or `eks`


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Jenkins X Boot

```bash
kubectl get pods

cd ..
```
