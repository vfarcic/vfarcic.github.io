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
* [Helm](https://github.com/helm/helm/releases) (MUST BE `helm` 2.x)
* If Google: [gcloud CLI](https://cloud.google.com/sdk/docs/quickstarts) and GCP admin permissions
* If Azure: [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) and Azure admin permissions
* If AWS: [AWS CLI](https://aws.amazon.com/cli/) and AWS admin permissions
* [Terraform](https://www.terraform.io/downloads.html)


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
export NAMESPACE=jx

export GH_USER=[...] # Replace `[...]` with your GitHub user
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

* Follow the [Getting Started](https://jenkins-x.io/docs/getting-started/) instructions


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx (GKE)

```bash
export CLUSTER_NAME=jx-workshop

open "https://console.cloud.google.com/cloud-resource-manager"

export PROJECT=[...] # GCP Project ID (e.g., devops26)

# Use default answers

jx create cluster gke -n $CLUSTER_NAME -p $PROJECT -r us-east1 \
    -m e2-standard-4 --min-num-nodes 1 --max-num-nodes 2 \
    --default-admin-password=admin \
    --default-environment-prefix $CLUSTER_NAME --git-provider-kind github \
    --namespace $NAMESPACE --prow --tekton
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx (AKS)

```bash
# Please replace [...] with a unique name (e.g., your GitHub user and a day and month).
# Otherwise, it might fail to create a registry.
# The name of the cluster must conform to the following pattern: '^[a-zA-Z0-9]*$'.
export CLUSTER_NAME=[...]

# Use default answers

jx create cluster aks -c $CLUSTER_NAME -n jxrocks-group -l eastus \
    -s Standard_D4s_v3 --nodes 3 --default-admin-password=admin \
    --default-environment-prefix $CLUSTER_NAME --git-provider-kind github \
    --namespace $NAMESPACE --prow --tekton
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx (EKS)

```bash
export AWS_ACCESS_KEY_ID=[...] # Replace [...] with the AWS Access Key ID

export AWS_SECRET_ACCESS_KEY=[...] # Replace [...] with the AWS Secret Access Key

export AWS_DEFAULT_REGION=us-west-2
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx (EKS)

```bash
# Use default answers except in the case specified below.
# Answer with `n` to `Would you like to register a wildcard DNS ALIAS to point at this ELB address?`

jx create cluster eks -n $CLUSTER_NAME -r $AWS_DEFAULT_REGION \
    --node-type t2.xlarge --nodes 3 --nodes-min 3 --nodes-max 6 \
    --default-admin-password=admin \
    --default-environment-prefix $CLUSTER_NAME --git-provider-kind github \
    --namespace $NAMESPACE --prow --tekton

# If you get stuck with the `waiting for external loadbalancer to be created and update the nginx-ingress-controller service in kube-system namespace`, you probably encountered a bug.
# To fix it, open the AWS console and remove the `kubernetes.io/cluster/$CLUSTER_NAME` tag from the security group `eks-cluster-sg-*`.
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Verifying The Installation

```bash
kubectl get pods
```
