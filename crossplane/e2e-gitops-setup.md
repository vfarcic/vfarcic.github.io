<!-- .slide: class="center dark" -->
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

cp examples/namespaces.yaml infra/.
```


## Setup Cluster

```bash
export GIT_URL=$(git remote get-url origin)

cat examples/k8s/aws-eks-gitops.yaml \
    | sed -e "s@gitOpsRepo: .*@gitOpsRepo: $GIT_URL@g" \
    | tee examples/k8s/aws-eks-gitops.yaml

cat argocd/apps.yaml | sed -e "s@repoURL: .*@repoURL: $GIT_URL@g" \
    | tee argocd/apps.yaml

cat argocd/infra.yaml | sed -e "s@repoURL: .*@repoURL: $GIT_URL@g" \
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
    --filename https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.17.2/controller.yaml
```


## Setup AWS

```bash
export AWS_ACCESS_KEY_ID=[...] # Replace `[...]` with your access key ID`

export AWS_SECRET_ACCESS_KEY=[...] # Replace `[...]` with your secret access key

echo "[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >aws-creds.conf

kubectl --namespace crossplane-system create secret generic aws-creds \
    --from-file creds=./aws-creds.conf --output json --dry-run=client \
    | kubeseal --format yaml \
    | tee crossplane-provider-configs/aws-creds.yaml
```


## Setup Crossplane

```bash
cp crossplane-config/config-k8s.yaml \
    crossplane-config/config-gitops.yaml \
    crossplane-config/provider-aws.yaml crossplane-definitions/.

cp crossplane-config/provider-config-aws.yaml \
    crossplane-provider-configs/.

cp examples/crossplane.yaml examples/crossplane-definitions.yaml \
    examples/crossplane-provider-configs.yaml infra/.
```


## Setup Crossplane

```bash
git add .

git commit -m "Infra"

git push
```


## Setup Argo CD

```bash
helm repo add argo https://argoproj.github.io/argo-helm

helm repo update

helm upgrade --install argocd argo/argo-cd \
    --namespace argocd --create-namespace \
    --set server.ingress.hosts="{argo-cd.$INGRESS_HOST.nip.io}" \
    --values argocd/helm-values.yaml --wait

kubectl apply --filename argocd/project.yaml

kubectl apply --filename argocd/infra.yaml
```


## Create A Cluster

```bash
echo http://argo-cd.$INGRESS_HOST.nip.io

# Open it in a browser
# User `admin`, password `admin123`

cp examples/k8s/aws-eks-gitops-no-claim.yaml infra/aws-eks.yaml

# Modify `spec.parameters.gitOpsRepo` in `infra/aws-eks.yaml`
```


## Create A Cluster
```bash
git add .

git commit -m "My cluster"

git push
```


## Create A Cluster

```bash
kubectl get releases

# Wait until all releases are synced
```


## Get LB IP

```bash
kubectl --namespace crossplane-system \
    get secret a-team-eks-no-claim-cluster \
    --output jsonpath="{.data.kubeconfig}" | base64 -d >kubeconfig.yaml
```


## Get LB IP

```bash
export INGRESS_HOSTNAME=$(kubectl --kubeconfig kubeconfig.yaml \
    --namespace ingress-nginx \
    get svc a-team-eks-no-claim-ingress-ingress-nginx-controller \
    --output jsonpath="{.status.loadBalancer.ingress[0].hostname}")

export INGRESS_HOST=$(dig +short $INGRESS_HOSTNAME)

echo $INGRESS_HOST

# Repeat the `export` commands if the output is empty
# If the output contains more than one IP, wait for a while longer, and repeat the `export` commands.
# If the output continues having more than one IP, choose one of them and execute `export INGRESS_HOST=[...]` with `[...]` being the selected IP.
```


## Set Hosts

```bash
mkdir -p tmp

cat examples/monitoring/prom-loki-no-claim.yaml | sed -e "s@127.0.0.1@$INGRESS_HOST@g" \
    | tee tmp/prom-loki-no-claim.yaml
```
