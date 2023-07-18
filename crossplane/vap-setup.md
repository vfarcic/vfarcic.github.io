<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Setup

<div class="label">Hands-on Time</div>


## Setup Kubernetes

```bash
# Create a Kuberentes cluster v1.26+ with
#   `ValidatingAdmissionPolicy` enabled through feature gates
#   or use the command that follows to create a cluster with
#   Minikube
minikube start --kubernetes-version v1.26.0 \
    --memory max --cpus max \
    --feature-gates ValidatingAdmissionPolicy=true \
    --extra-config apiserver.runtime-config=admissionregistration.k8s.io/v1alpha1
```


## Setup Kubernetes

```bash
kubectl create namespace production

echo "apiVersion: v1
kind: Namespace
metadata:
  labels:
    environment: production
  name: production2" | kubectl apply --filename -
```


## Setup Crossplane

```bash
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
kubectl apply \
    --filename crossplane-config/provider-kubernetes-incluster.yaml

kubectl apply --filename crossplane-config/config-sql-family.yaml

# Replace `[...]` with your access key ID`
export AWS_ACCESS_KEY_ID=[...]

# Replace `[...]` with your secret access key
export AWS_SECRET_ACCESS_KEY=[...]
```


## Setup Crossplane

```bash
echo "[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >aws-creds.conf

kubectl --namespace crossplane-system \
    create secret generic aws-creds \
    --from-file creds=./aws-creds.conf

kubectl get pkgrev

# Wait until all the packages are healthy

kubectl apply \
    --filename crossplane-config/provider-config-aws-official.yaml
```