<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Demo

<div class="label">Hands-on Time</div>


# Prod Cluster

```bash
cat infra/clusters/production.yaml

kubectl --namespace flux-system get clusterclaims

kubectl get managed

gh repo view vfarcic/devops-toolkit-crossplane --web
```


# Dev Environment

```bash
mkdir dev-apps

echo "apiVersion: devopstoolkitseries.com/v1alpha1
kind: AppClaim
metadata:
  name: silly-demo
  namespace: dev
spec:
  id: silly-demo-dev
  compositionSelector:
    matchLabels:
      type: backend-db
      location: local
  parameters:
    namespace: dev
    image: vfarcic/sql-demo:0.1.10
    port: 8080
    host: dev.backend.acme.com
    
---

apiVersion: devopstoolkitseries.com/v1alpha1
kind: SQLClaim
metadata:
  name: silly-demo
  namespace: dev
spec:
  id: silly-demo-dev
  compositionSelector:
    matchLabels:
      provider: local-k8s
      db: postgresql
  parameters:
    version: \"13.4\"
    size: small
    namespace: dev
  writeConnectionSecretToRef:
    name: silly-demo-dev" \
    | tee dev-apps/backend.yaml
```


# Dev Environment

```bash
git add .

git commit -m "Backend"

git push

flux create kustomization dev-apps \
    --source GitRepository/flux-system --path dev-apps \
    --prune true --interval 1m

kubectl --namespace dev get appclaims,sqlclaims

kubectl --namespace dev get all,ingresses,secrets
```


# Prod Cluster

```bash
kubectl get clusters

kubectl --namespace crossplane-system \
    get secret production-cluster \
    --output jsonpath="{.data.kubeconfig}" \
    | base64 -d >kubeconfig.yaml

# The credentials are temporary

kubectl --kubeconfig kubeconfig.yaml get nodes
```


# Prod Environment

```bash
mkdir prod-apps

echo "apiVersion: devopstoolkitseries.com/v1alpha1
kind: AppClaim
metadata:
  name: silly-demo
  namespace: production
spec:
  id: silly-demo
  compositionSelector:
    matchLabels:
      type: backend-db
      location: local
  parameters:
    namespace: production
    image: vfarcic/sql-demo:0.1.10
    port: 8080
    host: devops-toolkit.127.0.0.1.nip.io

---

apiVersion: devopstoolkitseries.com/v1alpha1
kind: SQLClaim
metadata:
  name: silly-demo
  namespace: production
spec:
  id: silly-demo
  compositionSelector:
    matchLabels:
      provider: aws
      db: postgresql
  parameters:
    version: \"13.4\"
    size: small
    namespace: production
  writeConnectionSecretToRef:
    name: silly-demo" \
    | tee prod-apps/backend.yaml
```


# Prod Environment

```bash
git add .

git commit -m "Backend"

git push

mkdir -p tmp

flux create kustomization prod-apps \
    --source GitRepository/flux-system --path prod-apps \
    --prune true --interval 1m --export \
    | tee tmp/prod-apps.yaml

# Edit the file and set `spec.kubeConfig.secretRef.name` 
#   to `production-cluster`
```


# Prod Environment

```bash
kubectl apply --filename tmp/prod-apps.yaml

kubectl --kubeconfig kubeconfig.yaml --namespace production \
    get appclaims,sqlclaims

kubectl --kubeconfig kubeconfig.yaml --namespace production \
    get all,ingresses,secrets

kubectl --kubeconfig kubeconfig.yaml get managed

kubectl --kubeconfig kubeconfig.yaml --namespace production \
    get pods
```