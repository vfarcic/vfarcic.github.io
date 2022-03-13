<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Demo

<div class="label">Hands-on Time</div>


## What Happened?

```bash
cat infra/aws-eks.yaml

kubectl get managed
```


## Shift-Left Infra

```bash
cat packages/k8s/definition.yaml

cat packages/k8s/eks.yaml

cat crossplane-config/config-k8s.yaml
```


## Shift-Left GitOps

```bash
cat packages/gitops/definition.yaml

cat packages/gitops/argo-cd.yaml

cat crossplane-config/config-gitops.yaml

cat infra/aws-eks.yaml

kubectl get managed
```


## Upgrade

```bash
cat infra/aws-eks.yaml | sed -e "s@minNodeCount: .*@minNodeCount: 5@g" \
    | tee infra/aws-eks.yaml

git add .

git commit -m "My cluster"

git push

kubectl get managed
```


## Use

```bash
kubectl --namespace crossplane-system \
    get secret a-team-eks-no-claim-cluster \
    --output jsonpath="{.data.kubeconfig}" | base64 -d >kubeconfig.yaml

kubectl --kubeconfig kubeconfig.yaml --namespace crossplane-system \
    create secret generic aws-creds --from-file creds=./aws-creds.conf

kubectl --kubeconfig kubeconfig.yaml get namespaces

kubectl --kubeconfig kubeconfig.yaml --namespace argocd get applications
```


## Pretty Colors

```bash
kubectl --kubeconfig kubeconfig.yaml --namespace argocd port-forward \
    svc/a-team-gitops-no-claim-argocd-server 8080:443 &

# Open http://localhost:8080 in a browser
# User `admin`, password `admin123`
```


## Apps In Dev Env

```bash
cat examples/app/backend-local-k8s-postgresql-no-claim.yaml

cp examples/app/backend-local-k8s-postgresql-no-claim.yaml apps-dev/.

git add . && git commit -m "Adding apps to dev" && git push

kubectl --kubeconfig kubeconfig.yaml get apps,sqls
```


## Apps In Prod Env

```bash
cat examples/app/backend-aws-postgresql-no-claim.yaml

cp examples/app/backend-aws-postgresql-no-claim.yaml apps/.

git add . && git commit -m "Adding dot" && git push

kubectl --kubeconfig kubeconfig.yaml get apps,sqls
```


## Ops

```bash
kubectl --kubeconfig kubeconfig.yaml --namespace dev get all,ingresses

kubectl --kubeconfig kubeconfig.yaml --namespace production \
    get all,ingresses

kubectl --kubeconfig kubeconfig.yaml get managed
```


## Ops

```bash
cat packages/sql/definition.yaml

cat packages/sql/local-k8s.yaml

cat packages/sql/aws.yaml
```


## Monitoring

```bash
cat examples/monitoring/prom-loki-no-claim.yaml

cp examples/monitoring/prom-loki-no-claim.yaml apps/.

git add . && git commit -m "Monitoring" && git push

kubectl --kubeconfig kubeconfig.yaml get monitoring
```