<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Setup

<div class="label">Hands-on Time</div>


## Setup

```bash
# Replace `[...]` with the GitHub organization or user
export GITHUB_ORG=[...]

# Replace `[...]` with the GitHub token
export GITHUB_TOKEN=[...]

# Replace `[...]` with `true` if it is a personal account,
#   or with `false` if it is an GitHub organization
export GITHUB_PERSONAL=[...]

# Replace `[...]` with your access key ID`
export AWS_ACCESS_KEY_ID=[...]

# Replace `[...]` with your secret access key
export AWS_SECRET_ACCESS_KEY=[...]
```


# Setup MGMNT Cluster

* The demo is using Rancher Desktop with 8 GB RAM and 4 CPUs as the management cluster.
* Any other cluster should do.

```bash
kubectl create namespace crossplane-system

kubectl create namespace dev

kubectl create namespace clusters
```


# Setup AWS

```bash
echo "[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
" >aws-creds.conf

kubectl --namespace crossplane-system create secret \
    generic aws-creds --from-file creds=./aws-creds.conf
```


# Setup Flux

```bash
flux bootstrap github --owner $GITHUB_ORG \
    --repository crossplane-flux --branch main \
    --path infra --personal $GITHUB_PERSONAL

git clone https://github.com/$GITHUB_ORG/crossplane-flux

cd crossplane-flux

echo "/kubeconfig.yaml
/aws-creds.conf" | tee .gitignore
```


# Setup Crossplane

```bash
mkdir infra/crossplane-system

flux create source helm crossplane --interval 1h \
    --url https://charts.crossplane.io/stable --export \
    | tee infra/crossplane-system/source.yaml

flux create helmrelease crossplane --interval 1h \
    --release-name crossplane \
    --target-namespace crossplane-system \
    --create-target-namespace \
    --source HelmRepository/crossplane \
    --chart crossplane --chart-version 1.11.2 \
    --crds CreateReplace --export \
    | tee infra/crossplane-system/release.yaml
```


# Setup Crossplane

```bash
git add .

git commit -m "Crossplane"

git push

kubectl --namespace flux-system get helmreleases,kustomizations

# Wait for a few moments for everything to sync

curl -o infra/crossplane-system/providers.yaml \
    https://gist.githubusercontent.com/vfarcic/477536cd79893a06cf805427fa6d6b7c/raw/9e9e6bd524c65f3108e9d8c87d7ef7e0208e807d/providers.yaml
```


# Setup Crossplane

```bash
git add .

git commit -m "Crossplane"

git push

kubectl --namespace flux-system get helmreleases,kustomizations

kubectl get pkgrev

# Wait until all the packages are healthy

curl -o infra/crossplane-system/provider-config-aws.yaml \
    https://raw.githubusercontent.com/vfarcic/devops-toolkit-crossplane/master/crossplane-config/provider-config-aws-official.yaml
```


# Setup Crossplane

```bash
git add .

git commit -m "Crossplane"

git push

kubectl --namespace flux-system get helmreleases,kustomizations

export SA=$(kubectl --namespace crossplane-system \
    get serviceaccount --output name \
    | grep provider-helm \
    | sed -e 's|serviceaccount\/|crossplane-system:|g')

kubectl create clusterrolebinding provider-helm-admin-binding \
    --clusterrole cluster-admin --serviceaccount="${SA}"
```


# Setup Prod Cluster

```bash
mkdir infra/clusters

echo "apiVersion: devopstoolkitseries.com/v1alpha1
kind: ClusterClaim
metadata:
  name: production
  namespace: flux-system
spec:
  id: production
  compositionSelector:
    matchLabels:
      provider: aws-official
      cluster: eks
  parameters:
    nodeSize: medium
    minNodeCount: 3
    version: \"1.25\"
  writeConnectionSecretToRef:
    name: production-cluster" \
    | tee infra/clusters/production.yaml
```


# Setup Prod Cluster

```bash
git add .

git commit -m "Cluster"

git push

kubectl --namespace flux-system get clusterclaims

# Wait until it is `READY`
```


# Setup Prod Cluster

```bash
kubectl --namespace flux-system get secret production-cluster \
    --output jsonpath="{.data.kubeconfig}" \
    | base64 -d >kubeconfig.yaml

echo "[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
" >aws-creds.conf

kubectl --kubeconfig kubeconfig.yaml \
    --namespace crossplane-system \
    create secret generic aws-creds \
    --from-file creds=./aws-creds.conf
```
