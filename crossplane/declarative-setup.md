<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Setup

<div class="label">Hands-on Time</div>


## Setup Terraform

```bash
git clone https://github.com/vfarcic/devops-catalog-code

cd devops-catalog-code/terraform-eks/simple

# Replace `[...]` with your access key ID`
export AWS_ACCESS_KEY_ID=[...]

# Replace `[...]` with your secret access key
export AWS_SECRET_ACCESS_KEY=[...]

terraform init

terraform apply

cd ../../../
```


## Setup Crossplane

```bash
# Create a management Kubernetes cluster
# A local cluster like Rancher Desktop should do

git clone https://github.com/vfarcic/devops-toolkit-crossplane

cd devops-toolkit-crossplane

helm repo add crossplane-stable \
    https://charts.crossplane.io/stable

helm repo update

helm upgrade --install crossplane crossplane-stable/crossplane \
    --namespace crossplane-system --create-namespace --wait
```


## Setup Crossplane

```bash
echo "[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >aws-creds.conf

kubectl --namespace crossplane-system create secret generic \
    aws-creds --from-file creds=./aws-creds.conf

kubectl apply --filename crossplane-config/config-k8s.yaml

kubectl get pkgrev

# Wait until all the packages are healthy
```


## Setup Crossplane

```bash
kubectl apply \
    --filename crossplane-config/provider-config-aws-official.yaml

kubectl create namespace a-team

cd ..
```