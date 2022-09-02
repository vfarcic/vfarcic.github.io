<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Workshop

<div class="label">Hands-on Time</div>


## GitOps

```bash
echo http://argo-cd.$INGRESS_HOST.nip.io

# Open it in a browser
# User `admin`, password `admin123`
```


## Create Clusters

```bash
cp examples/k8s/civo-no-claim.yaml infra/civo.yaml

# Modify `spec.parameters.gitOpsRepo` in `infra/aws-eks.yaml`

git add .

git commit -m "My cluster"

git push
```


## Create Clusters

```bash
cat examples/k8s/civo-no-claim.yaml

cat examples/k8s/aws-eks-gitops-no-claim.yaml

kubectl get managed
```


## Use

```bash
kubectl get civokubernetes

kubectl get clusters.eks.aws.crossplane.io

kubectl --namespace crossplane-system \
    get secret a-team-eks-no-claim-cluster \
    --output jsonpath="{.data.kubeconfig}" \
    | base64 -d >kubeconfig-eks.yaml

kubectl --kubeconfig kubeconfig-eks.yaml get nodes
```


## Shift-Left Infra

```bash
cat packages/k8s/definition.yaml

cat packages/k8s/eks.yaml

ls -1 packages/k8s

cat crossplane-config/config-k8s.yaml
```


## Shift-Left GitOps

```bash
cat packages/gitops/definition.yaml

cat packages/gitops/argo-cd.yaml

cat crossplane-config/config-gitops.yaml
```


## What Happened?

```bash
cat infra/civo.yaml

cat infra/aws-eks.yaml

kubectl get managed
```


## Secrets

```bash
kubectl --kubeconfig kubeconfig-eks.yaml \
    --namespace crossplane-system \
    create secret generic aws-creds \
    --from-file creds=./aws-creds.conf
```


## Production-Ready

```bash
kubectl --kubeconfig kubeconfig-eks.yaml get namespaces

kubectl --kubeconfig kubeconfig-eks.yaml --namespace argocd \
    get applications
```


## Pretty Colors

```bash
kubectl --kubeconfig kubeconfig-eks.yaml --namespace argocd \
    port-forward svc/a-team-gitops-no-claim-argocd-server \
    8080:443 &

# Open http://localhost:8080 in a browser
# User `admin`, password `admin123`
```


## Apps In Prod Env

```bash
cat examples/app/backend-aws-postgresql-no-claim.yaml

cp examples/app/backend-aws-postgresql-no-claim.yaml apps/.

git add . && git commit -m "Adding dot" && git push

kubectl --kubeconfig kubeconfig-eks.yaml get apps,sqls
```


## Ops

```bash
kubectl --kubeconfig kubeconfig-eks.yaml \
    --namespace production get all,ingresses

kubectl --kubeconfig kubeconfig-eks.yaml get managed
```


## Ops

```bash
cat packages/sql/definition.yaml

cat packages/sql/aws.yaml
```
