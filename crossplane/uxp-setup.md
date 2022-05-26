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

kubectl --namespace crossplane-system create secret generic \
    aws-creds --from-file creds=./aws-creds.conf
```


## Setup Digital Ocean

```bash
# Replace `[...]` with the DigitalOcean token
export DO_TOKEN=[...]

export DO_TOKEN_ENCODED=$(echo $DO_TOKEN | base64)
```


## Install Providers

```bash
kubectl apply --filename crossplane-config/provider-aws.yaml

kubectl apply --filename crossplane-config/config-k8s.yaml

kubectl apply --filename crossplane-config/config-gitops.yaml

kubectl apply --filename crossplane-config/config-sql.yaml

kubectl apply --filename crossplane-config/config-app.yaml

kubectl apply --filename crossplane-config/provider-do.yaml

kubectl get pkgrev

# Wait until all the packages are healthy
```


## Install Providers

```bash
kubectl apply --filename \
    crossplane-config/provider-config-aws.yaml

cat crossplane-config/provider-config-do.yaml \
    | sed -e "s@token: .*@token: $DO_TOKEN_ENCODED@g" \
    | kubectl apply --filename -

kubectl create namespace a-team
```