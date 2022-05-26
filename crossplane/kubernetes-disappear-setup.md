<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Setup

<div class="label">Hands-on Time</div>


## Setup Cluster

```bash
gh repo fork vfarcic/devops-toolkit-crossplane \
    --clone

cd devops-toolkit-crossplane

kind create cluster --config kind.yaml

kubectl apply --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

# Replace `[...]` with your Ingress host
export INGRESS_HOST=[...]
```


## Setup Cluster

```bash
kubectl create namespace crossplane-system

kubectl create namespace a-team

kubectl create namespace production

export GIT_URL=$(git remote get-url origin)
```


## Setup Cluster

```bash
cat examples/k8s/aws-eks-gitops.yaml \
    | sed -e "s@gitOpsRepo: .*@gitOpsRepo: $GIT_URL@g" \
    | tee examples/k8s/aws-eks-gitops.yaml

cat argocd/apps.yaml \
    | sed -e "s@repoURL: .*@repoURL: $GIT_URL@g" \
    | tee argocd/apps.yaml

cat argocd/infra.yaml \
    | sed -e "s@repoURL: .*@repoURL: $GIT_URL@g" \
    | tee argocd/infra.yaml
```


## Setup AWS

```bash
# Replace `[...]` with access key ID
export AWS_ACCESS_KEY_ID=[...]

# Replace `[...]` with secret access key
export AWS_SECRET_ACCESS_KEY=[...]

echo "[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
" >aws-creds.conf

kubectl --namespace crossplane-system create secret \
    generic aws-creds --from-file creds=./aws-creds.conf
```


## Setup Crossplane

```bash
helm repo add crossplane-stable \
    https://charts.crossplane.io/stable

helm repo update

helm upgrade --install crossplane crossplane-stable/crossplane \
    --namespace crossplane-system --create-namespace --wait

kubectl apply --filename crossplane-config/provider-aws.yaml

kubectl apply \
    --filename crossplane-config/provider-config-aws.yaml

# Re-run the previous command if the output is
#   `unable to recognize ...`
```


## Setup Crossplane

```bash
kubectl apply --filename crossplane-config/provider-helm.yaml

kubectl apply \
    --filename crossplane-config/provider-kubernetes.yaml

kubectl apply --filename crossplane-config/config-k8s.yaml

kubectl apply --filename crossplane-config/config-gitops.yaml

kubectl get pkgrev

# Wait until all the packages are healthy
```


## Setup Argo CD

```bash
helm repo add argo https://argoproj.github.io/argo-helm

helm repo update

helm upgrade --install argocd argo/argo-cd --namespace argocd \
    --create-namespace --values argocd/helm-values.yaml \
    --set server.ingress.hosts="{argo-cd.$INGRESS_HOST.nip.io}" \
    --wait

kubectl apply --filename argocd/project.yaml

kubectl apply --filename argocd/infra.yaml
```


## Setup Argo CD

```bash
echo http://argo-cd.$INGRESS_HOST.nip.io

# Open it in a browser

# User `admin`, password `admin123`

# Modify `spec.parameters.gitOpsRepo` 
#   in `examples/aws-eks-gitops-no-claim.yaml`
```
