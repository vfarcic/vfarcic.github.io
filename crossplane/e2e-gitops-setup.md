<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Setup

<div class="label">Hands-on Time</div>


## Setup Cluster

```bash
gh repo fork vfarcic/devops-toolkit-crossplane --clone

cd devops-toolkit-crossplane

# If not using Rancher Desktop, replace `127.0.0.1`
#   with the base host accessible through NGINX Ingress
export INGRESS_HOST=127.0.0.1
```


## Setup Cluster

```bash
export GIT_URL=$(git remote get-url origin)

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


## Setup Cluster

```bash
cat examples/crossplane-definitions.yaml \
    | sed -e "s@repoURL: .*@repoURL: $GIT_URL@g" \
    | tee examples/crossplane-definitions.yaml

cat examples/crossplane-provider-configs.yaml \
    | sed -e "s@repoURL: .*@repoURL: $GIT_URL@g" \
    | tee examples/crossplane-provider-configs.yaml
```


## Sealed Secrets

```bash
kubectl apply \
    --filename https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.17.5/controller.yaml

# Install `kubeseal` from
#   https://github.com/bitnami-labs/sealed-secrets/releases
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

kubectl --namespace crossplane-system create secret \
    generic aws-creds --from-file creds=./aws-creds.conf \
    --output json --dry-run=client \
    | kubeseal --format yaml \
    | tee crossplane-provider-configs/aws-creds.yaml
```


## Setup Civo

```bash
# Replace `[...]` with your Civo token
export CIVO_TOKEN=[...]

kubectl --namespace crossplane-system create secret \
    generic civo-creds --from-literal credentials=$CIVO_TOKEN \
    --output json --dry-run=client \
    | kubeseal --format yaml \
    | tee crossplane-provider-configs/civo-creds.yaml
```


## Setup Argo CD

```bash
helm repo add argo https://argoproj.github.io/argo-helm

helm repo update

# Replace `nginx` with the Ingress class
export INGRESS_CLASS=nginx

helm upgrade --install argocd argo/argo-cd \
    --namespace argocd --create-namespace \
    --set server.ingress.hosts="{argo-cd.$INGRESS_HOST.nip.io}" \
    --set server.ingress.ingressClassName=$INGRESS_CLASS \
    --values argocd/helm-values.yaml --wait
```


## Setup Argo CD

```bash
kubectl apply --filename argocd/project.yaml

kubectl apply --filename argocd/infra.yaml
```


## Setup Infra

```bash
cp examples/namespaces.yaml examples/crossplane.yaml infra/.

git add .

git commit -m "Infra"

git push
```


## Setup Providers

```bash
cp crossplane-config/config-k8s.yaml \
    crossplane-config/config-gitops.yaml \
    crossplane-config/provider-aws.yaml \
    crossplane-config/provider-civo.yaml \
    crossplane-definitions/.

cp crossplane-config/provider-config-aws.yaml \
    crossplane-config/provider-config-civo.yaml \
    crossplane-provider-configs/.

cp examples/crossplane-definitions.yaml \
    examples/crossplane-provider-configs.yaml infra/.
```


## Setup Providers

```bash
git add .

git commit -m "Infra"

git push
```


## Setup Cluster

```bash
cp examples/k8s/aws-eks-gitops-no-claim.yaml infra/aws-eks.yaml

git add .

git commit -m "Infra"

git push
```
