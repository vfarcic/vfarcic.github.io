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
* [Helm](https://helm.sh/)
* If Google: [gcloud CLI](https://cloud.google.com/sdk/docs/quickstarts) and GCP admin permissions
* If Azure: [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) and Azure admin permissions
* If AWS: [AWS CLI](https://aws.amazon.com/cli/) and AWS admin permissions


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
NAMESPACE=cd

echo "nexus:
  enabled: false
" | tee myvalues.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx (GCS)

```bash
open "https://console.cloud.google.com/cloud-resource-manager"
```

* Create a new project
* Open Google Cloud Shell

```bash
NAMESPACE=cd

echo "nexus:
  enabled: false
" | tee myvalues.yaml

export PROJECT=[...] # GCP Project ID (e.g., devops26)
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx (GCS)

```bash
# Use default answers

jx create cluster gke -n jx-rocks -p $PROJECT -r us-east1 \
    -m n1-standard-4 --min-num-nodes 1 --max-num-nodes 2 \
    --default-admin-password=admin \
    --default-environment-prefix jx-rocks --git-provider-kind github \
    --namespace $NAMESPACE --prow --tekton --skip-login
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx (GKE)

```bash
open "https://console.cloud.google.com/cloud-resource-manager"

export PROJECT=[...] # GCP Project ID (e.g., devops26)

# Use default answers

jx create cluster gke -n jx-rocks -p $PROJECT -r us-east1 \
    -m n1-standard-4 --min-num-nodes 1 --max-num-nodes 2 \
    --default-admin-password=admin \
    --default-environment-prefix jx-rocks --git-provider-kind github \
    --namespace $NAMESPACE --prow --tekton
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx (AKS)

```bash
CLUSTER_NAME=[...]

# Use default answers

jx create cluster aks -c $CLUSTER_NAME -n jxrocks-group -l eastus \
    -s Standard_D4s_v3 --nodes 3 --default-admin-password=admin \
    --default-environment-prefix jx-rocks --git-provider-kind github \
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

jx create cluster eks -n jx-rocks -r $AWS_DEFAULT_REGION \
    --node-type t2.xlarge --nodes 3 --nodes-min 3 --nodes-max 6 \
    --default-admin-password=admin \
    --default-environment-prefix jx-rocks --git-provider-kind github \
    --namespace $NAMESPACE --prow --tekton

# If you get stuck with the `waiting for external loadbalancer to be created and update the nginx-ingress-controller service in kube-system namespace`, you probably encountered a bug.
# To fix it, open the AWS console and remove the `kubernetes.io/cluster/jx-rocks` tag from the security group `eks-cluster-sg-*`.
```


<!--
PROJECT=[...] # e.g. devops-26

gcloud container clusters create jx-rocks --region us-east1 \
    --machine-type n1-standard-8 --enable-autoscaling \
    --num-nodes 1 --max-nodes 10 --min-nodes 1 --project $PROJECT

kubectl create clusterrolebinding cluster-admin-binding \
    --clusterrole cluster-admin --user $(gcloud config get-value account)

kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/1cd17cd12c98563407ad03812aebac46ca4442f2/deploy/mandatory.yaml

kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/1cd17cd12c98563407ad03812aebac46ca4442f2/deploy/provider/cloud-generic.yaml

curl -o get-kubeconfig.sh \
    https://raw.githubusercontent.com/gravitational/teleport/master/examples/gke-auth/get-kubeconfig.sh

chmod +x get-kubeconfig.sh

rm -rf build

./get-kubeconfig.sh

tar -czf kubeconfig.tar.gz build

mv kubeconfig.tar.gz ~/Amazon\ Drive/tmp/.
-->
<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

<!-- ## Using The Workshop Cluster

<!-- TODO: Change me -->
```bash
open "https://www.amazon.es/clouddrive/share/hJAF9Wi4Er6T966TlJjGCSC53CsWoTAomUK2eUCRs8I"

# Download the file

tar -xzvf kubeconfig.tar.gz

export KUBECONFIG=$PWD/build/kubeconfig

export LB_IP=$(kubectl -n ingress-nginx get svc \
    -o jsonpath="{.items[0].status.loadBalancer.ingress[0].ip}")

echo $LB_IP
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Using The Workshop Cluster

```bash
# Only letters, numbers, dash (`-`) and underscore (`_`) charters
NAMESPACE=[...] # Make it unique (e.g., your GitHub username)

jx install --provider kubernetes --external-ip $LB_IP \
    --domain $LB_IP.nip.io --default-admin-password=admin \
    --ingress-namespace ingress-nginx \
    --ingress-deployment nginx-ingress-controller \
    --default-environment-prefix jx-rocks --git-provider-kind github \
    --namespace $NAMESPACE --prow --tekton
``` -->


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Verifying The Installation

```bash
kubectl get pods
```
