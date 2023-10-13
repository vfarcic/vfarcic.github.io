<!-- .slide: data-background="../img/background/hands-on.jpg" -->
## Hands-on Time

# Setup


## Setup

* The demo is based on AWS.
* Some commands and manifests might need to be modified to make it work in other providers.
* Create a Kubernetes cluster with an Ingress controller.
* Do NOT use a local Kubernetes cluster (e.g., Minikube, Docker Desktop, KinD, Rancher Desktop, etc.).


## Setup

```bash
# Watch https://youtu.be/BII6ZY2Rnlc if you are not familiar
#   with GitHub CLI.
gh repo fork vfarcic/db-schema-git-demo --clone --remote

cd db-schema-git-demo

gh repo set-default

# Select the fork as the default repository
```


## Setup

```bash
helm repo add crossplane-stable \
    https://charts.crossplane.io/stable

helm repo update

helm upgrade --install crossplane crossplane-stable/crossplane \
    --namespace crossplane-system --create-namespace --wait
```


## Setup

```bash
# Replace `[...]` with your access key ID`
export AWS_ACCESS_KEY_ID=[...]

# Replace `[...]` with your secret access key
export AWS_SECRET_ACCESS_KEY=[...]

echo "[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
" >aws-creds.conf

kubectl --namespace crossplane-system \
    create secret generic aws-creds \
    --from-file creds=./aws-creds.conf
```


## Setup

```bash
kubectl apply \
    --filename crossplane/provider-kubernetes-incluster.yaml

kubectl apply --filename crossplane/config-sql.yaml

sleep 10

kubectl wait --for=condition=healthy provider.pkg.crossplane.io \
    --all --timeout=600s

kubectl apply --filename crossplane/provider-config-aws.yaml
```


## Setup

```bash
kubectl create namespace production

export INGRESS_CLASS=$(kubectl get ingressclasses \
    --output jsonpath="{.items[0].metadata.name}")

# Replace `127.0.0.1` with the IP through which the Ingress
#   Service is accessible.
# You can get the IP by observing the `EXTERNAL-IP` column
#   from the output of `kubectl get services --all-namespaces`.
export INGRESS_HOST=127.0.0.1

yq --inplace \
    ".server.ingress.ingressClassName = \"$INGRESS_CLASS\"" \
    argocd/helm-values.yaml
```


## Setup

```bash
yq --inplace ".server.ingress.hosts[0] = \"argocd.$INGRESS_HOST.nip.io\"" \
    argocd/helm-values.yaml

helm upgrade --install argocd argo-cd \
    --repo https://argoproj.github.io/argo-helm \
    --namespace argocd --create-namespace \
    --values argocd/helm-values.yaml --wait

# Replace `[...]` with your GitHub organization or user where
#   the repo was forked.
export GITHUB_ORG=[...]
```


## Setup

```bash
# Install `yq` from https://github.com/mikefarah/yq if you do not
#   have it already
yq --inplace \
    ".spec.source.repoURL = \"https://github.com/$GITHUB_ORG/db-schema-git-demo\"" \
    argocd/apps.yaml

kubectl apply --filename argocd/apps.yaml

helm upgrade --install atlas-operator \
    oci://ghcr.io/ariga/charts/atlas-operator \
    --namespace atlas-operator --create-namespace --wait
```