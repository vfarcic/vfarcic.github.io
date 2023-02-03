<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Setup

<div class="label">Hands-on Time</div>


## Cluster

* Create a Kubernetes cluster
* A local cluster like Rancher Desktop should do for the demo
* That cluster will serve as a management cluster

*In the "real world" situation, you should have a "real" cluster instead.*


## CLI & Repos

* Install `okteto` CLI from https://www.okteto.com/docs/getting-started/#installing-okteto-cli

```bash
git clone https://github.com/vfarcic/silly-demo

git clone https://github.com/vfarcic/devops-toolkit-crossplane

cd devops-toolkit-crossplane
```


## Crossplane

```bash
helm repo add crossplane-stable \
    https://charts.crossplane.io/stable

helm repo update

helm upgrade --install \
    crossplane crossplane-stable/crossplane \
    --namespace crossplane-system --create-namespace --wait
```


## Google Cloud

```bash
# The demo is using Google Cloud.
# Using a different provider might require changes to some
#   of the commands and manifests.

export PROJECT_ID=dot-$(date +%Y%m%d%H%M%S)

gcloud projects create $PROJECT_ID

echo "https://console.cloud.google.com/marketplace/product/google/container.googleapis.com?project=$PROJECT_ID"

# Open the URL and *ENABLE* the API
```


## Google Cloud

```bash
export SA_NAME=devops-toolkit

export SA="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

gcloud iam service-accounts create $SA_NAME \
    --project $PROJECT_ID

export ROLE=roles/admin

gcloud projects add-iam-policy-binding \
    --role $ROLE $PROJECT_ID --member serviceAccount:$SA

gcloud iam service-accounts keys create gcp-creds.json \
    --project $PROJECT_ID --iam-account $SA
```


## Crossplane

```bash
kubectl --namespace crossplane-system \
    create secret generic gcp-creds \
    --from-file creds=./gcp-creds.json

kubectl apply \
    --filename crossplane-config/provider-gcp-official.yaml

kubectl apply --filename crossplane-config/config-k8s.yaml

kubectl apply --filename crossplane-config/config-sql.yaml

kubectl get pkgrev

# Wait until all the packages are healthy
```


## Cluster

```bash
echo "apiVersion: gcp.upbound.io/v1beta1
kind: ProviderConfig
metadata:
  name: default
spec:
  projectID: $PROJECT_ID
  credentials:
    source: Secret
    secretRef:
      namespace: crossplane-system
      name: gcp-creds
      key: creds" \
    | kubectl apply --filename -
```


## Cluster

```bash
kubectl create namespace a-team

kubectl --namespace a-team apply \
    --filename examples/k8s/gcp-gke-official.yaml

# kubectl get cluster.container.gcp.upbound.io,nodepool.container.gcp.upbound.io,release.helm.crossplane.io,object.kubernetes.crossplane.io

kubectl --namespace a-team get clusterclaim

./examples/k8s/get-kubeconfig-google.sh \
    a-team-gke kubeconfig.yaml $PROJECT_ID

export KUBECONFIG=$PWD/kubeconfig.yaml
```


## PostgreSQL

```bash
echo "https://console.cloud.google.com/apis/library/sqladmin.googleapis.com?project=$PROJECT_ID"

# Open the URL and *ENABLE* the API

./examples/k8s/create-secret-google.sh $PROJECT_ID

kubectl --namespace dev apply \
    --filename examples/sql/gcp-official.yaml

# kubectl get databaseinstance.sql.gcp.upbound.io,user.sql.gcp.upbound.io,database.postgresql.sql.crossplane.io,object.kubernetes.crossplane.io

kubectl --namespace dev get sqlclaims
```


## SchemaHero

```bash
kubectl krew install schemahero

export PATH="${PATH}:${HOME}/.krew/bin"

kubectl schemahero install
```


## Almost Done

```
unset KUBECONFIG
```
