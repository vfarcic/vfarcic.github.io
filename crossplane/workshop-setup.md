<!-- .slide: data-background="../img/background/hands-on.jpg" -->
## Hands-on Time

# Setup


## Setup Cluster

```bash
# Create a management Kubernetes cluster

# The demo is using Rancher Desktop,
# but any other cluster (local or remote) should do

git clone https://github.com/vfarcic/devops-toolkit-crossplane

cd devops-toolkit-crossplane
```


## Install Crossplane

```bash
helm repo add crossplane-stable \
    https://charts.crossplane.io/stable

helm repo update

helm upgrade --install crossplane crossplane-stable/crossplane \
    --namespace crossplane-system --create-namespace --wait
```


## Setup AWS

```bash
# Run the commands in this section only if you are using AWS

export PROVIDER=aws

# Replace `[...]` with your access key ID
export AWS_ACCESS_KEY_ID=[...]

# Replace `[...]` with your secret access key
export AWS_SECRET_ACCESS_KEY=[...]

echo "[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >aws-creds.conf
```


## Setup AWS

```bash
# Run the commands in this section only if you are using AWS

kubectl --namespace crossplane-system create secret generic \
    aws-creds --from-file creds=./aws-creds.conf

kubectl apply --filename crossplane-config/provider-aws.yaml

kubectl get pkgrev

# Wait until the provider is healthy

kubectl apply --filename \
    crossplane-config/provider-config-aws.yaml
```


## Setup Google Cloud

```bash
# Run the commands in this section only if you are using
# Google Cloud

export PROVIDER=gcp

export PROJECT_ID=dot-$(date +%Y%m%d%H%M%S)

gcloud projects create $PROJECT_ID

echo "https://console.cloud.google.com/marketplace/product/google/container.googleapis.com?project=$PROJECT_ID"

# Open the URL and *ENABLE* the API
```


## Setup Google Cloud

```bash
# Run the commands in this section only if you are using
# Google Cloud

echo "https://console.developers.google.com/apis/api/sqladmin.googleapis.com/overview?project=$PROJECT_ID"

# Open the URL and *ENABLE* the API

export SA_NAME=devops-toolkit
```


## Setup Google Cloud

```bash
# Run the commands in this section only if you are using
# Google Cloud

export SA="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

gcloud iam service-accounts create $SA_NAME --project $PROJECT_ID

export ROLE=roles/admin

gcloud projects add-iam-policy-binding \
    --role $ROLE $PROJECT_ID --member serviceAccount:$SA

gcloud iam service-accounts keys create gcp-creds.json \
    --project $PROJECT_ID --iam-account $SA
```


## Setup Google Cloud

```bash
# Run the commands in this section only if you are using
# Google Cloud

kubectl --namespace crossplane-system create secret generic \
    gcp-creds --from-file creds=./gcp-creds.json

kubectl apply --filename crossplane-config/provider-gcp.yaml

kubectl get pkgrev

# Wait until the provider is healthy
```


## Setup Google Cloud

```bash
# Run the commands in this section only if you are using
# Google Cloud

yq --inplace ".spec.projectID = \"$PROJECT_ID\"" \
    crossplane-config/provider-config-gcp.yaml

kubectl apply --filename \
    crossplane-config/provider-config-gcp.yaml
```


## Setup Azure

```bash
# Run the commands in this section only if you are using Azure

export PROVIDER=azure

az ad sp create-for-rbac --sdk-auth --role Owner \
    | tee azure-creds.json

export AZURE_CLIENT_ID=$(cat azure-creds.json | grep clientId \
    | cut -c 16-51)

export AAD_GRAPH_API=00000003-0000-0000-c000-000000000000
```


## Setup Azure

```bash
# Run the commands in this section only if you are using Azure

az ad app permission add --id "${AZURE_CLIENT_ID}" \
    --api ${AAD_GRAPH_API} --api-permissions \
    e1fe6dd8-ba31-4d61-89e7-88639da4683d=Scope \
    06da0dbc-49e2-44d2-8312-53f166ab848a=Scope \
    7ab1d382-f21e-4acd-a863-ba3e13f7da61=Role

az ad app permission grant --id $AZURE_CLIENT_ID \
    --api $AAD_GRAPH_API --expires never

az ad app permission admin-consent --id "${AZURE_CLIENT_ID}"

kubectl --namespace crossplane-system create secret generic azure-creds \
    --from-file creds=./azure-creds.json
```


## Setup Azure

```bash
# Run the commands in this section only if you are using Azure

kubectl apply \
    --filename crossplane-config/provider-azure.yaml

kubectl get pkgrev

# Wait until the provider is healthy

kubectl apply \
    --filename crossplane-config/provider-config-azure.yaml
```


## Install Providers

```bash
# TODO: Uncomment if needed
# kubectl apply --filename crossplane-config/config-k8s.yaml

# TODO: Uncomment if needed
# kubectl apply --filename crossplane-config/config-gitops.yaml

# TODO: Uncomment if needed
# kubectl apply --filename crossplane-config/config-sql.yaml

# TODO: Uncomment if needed
# kubectl apply --filename crossplane-config/config-app.yaml

# TODO: Uncomment if needed
# kubectl apply --filename crossplane-config/provider-do.yaml
```


## Almost Done

```bash
kubectl create namespace a-team
```