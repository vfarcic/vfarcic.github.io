<!-- .slide: data-background="../img/background/hands-on.jpg" -->
## Hands-on Time

# Setup


## Repo

```bash
# Create a Kubernetes cluster

git clone https://github.com/vfarcic/kubernetes-what-demo

cd kubernetes-what-demo

kubectl create namespace production

yq --inplace \
    ".spec.template.spec.containers[0].image = \"vfarcic/silly-demo:1.0.5\"" \
    silly-demo/deployment.yaml
```


## Crossplane

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


## Install Providers

```bash
kubectl apply --filename crossplane-config/provider-aws.yaml

kubectl apply --filename crossplane-config/config-k8s.yaml

kubectl apply --filename crossplane-config/config-sql.yaml

kubectl get pkgrev

# Wait until all the packages are healthy

kubectl apply --filename \
    crossplane-config/provider-config-aws.yaml
```