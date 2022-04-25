<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Setup

<div class="label">Hands-on Time</div>


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
# Replace `[...]` with your access key ID`
export AWS_ACCESS_KEY_ID=[...]

# Replace `[...]` with your secret access key
export AWS_SECRET_ACCESS_KEY=[...]

echo "[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >aws-creds.conf

kubectl --namespace crossplane-system create secret generic aws-creds \
    --from-file creds=./aws-creds.conf
```


## Setup Equinix Metal

```bash
# Replace `[...]` with your Equinix API token
export EQUINIX_API_TOKEN=[...]

echo "{
  \"auth_token\": \"$EQUINIX_API_TOKEN\",
  \"max_retries\": \"10\",
  \"max_retry_wait_seconds\": \"30\"
}" >equinix-creds.conf

kubectl --namespace crossplane-system create secret \
    generic equinix-creds --from-file creds=./equinix-creds.conf
```


## Install Providers

```bash
kubectl apply --filename crossplane-config/provider-aws.yaml

kubectl apply --filename crossplane-config/config-k8s.yaml

kubectl apply --filename crossplane-config/config-app.yaml

kubectl apply --filename crossplane-config/provider-equinix.yaml

kubectl get pkgrev

# Wait until all the packages are healthy
```


## Install Providers

```bash
kubectl apply --filename crossplane-config/provider-config-aws.yaml

kubectl apply --filename crossplane-config/provider-config-equinix.yaml

kubectl create namespace a-team
```