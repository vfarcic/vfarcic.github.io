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
cp examples/k8s/civo.yaml infra/civo.yaml

git add .

git commit -m "My cluster"

git push
```


## Create Clusters

```bash
cat examples/k8s/civo.yaml

cat examples/k8s/aws-eks-gitops.yaml

kubectl --namespace production get clusterclaims
```


## Use

```bash
kubectl get managed

kubectl --namespace production get clusterclaims

./examples/k8s/get-kubeconfig-eks.sh \
    production a-team-eks-cluster

kubectl --kubeconfig kubeconfig.yaml get nodes
```


## Shift-Left Infra

```bash
cat packages/k8s/definition.yaml

more packages/k8s/eks.yaml

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


## Update

```bash
cat infra/aws-eks.yaml \
    | sed -e "s@minNodeCount: .*@minNodeCount: 4@g" \
    | tee infra/aws-eks.yaml

git add .

git commit -m "My cluster"

git push
```


## Production-Ready

```bash
kubectl --kubeconfig kubeconfig.yaml get namespaces

kubectl --kubeconfig kubeconfig.yaml --namespace argocd \
    get applications
```


## Pretty Colors

```bash
kubectl --kubeconfig kubeconfig.yaml --namespace argocd \
    port-forward \
    svc/a-team-gitops-argocd-server 8081:80 &

# Open http://localhost:8081 in a browser
# User `admin`, password `admin123`
```


## Apps In Dev Env

```bash
cat examples/app/backend-local-k8s-postgresql-no-claim.yaml

cp examples/app/backend-local-k8s-postgresql-no-claim.yaml \
    apps-dev/.

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
kubectl --kubeconfig kubeconfig.yaml --namespace dev get \
    all,ingresses

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


## Monitoring

```bash
cat tmp/prom-loki-no-claim.yaml

cp tmp/prom-loki-no-claim.yaml apps/.

git add . && git commit -m "Monitoring" && git push

kubectl --kubeconfig kubeconfig.yaml get monitoring

kubectl --kubeconfig kubeconfig.yaml --namespace monitoring get all,ingresses,configmaps,secrets
```


## Get LB IP

```bash
export EKS_INGRESS_HOSTNAME=$(kubectl --kubeconfig kubeconfig-eks.yaml \
    --namespace ingress-nginx \
    get svc a-team-eks-no-claim-ingress-ingress-nginx-controller \
    --output jsonpath="{.status.loadBalancer.ingress[0].hostname}")

export EKS_INGRESS_HOST=$(dig +short $EKS_INGRESS_HOSTNAME)

echo $EKS_INGRESS_HOST

# Repeat the `export` commands if the output is empty
# If the output contains more than one IP, wait for a while longer, and repeat the `export` commands.
# If the output continues having more than one IP, choose one of them and execute `export EKS_INGRESS_HOST=[...]` with `[...]` being the selected IP.
```


## Set Hosts

```bash
mkdir -p tmp

cat examples/monitoring/prom-loki-no-claim.yaml | sed -e "s@127.0.0.1@$EKS_INGRESS_HOST@g" \
    | tee tmp/prom-loki-no-claim.yaml
```


## Monitoring

```bash
echo "http://dashboard.$EKS_INGRESS_HOST.nip.io"

kubectl --kubeconfig kubeconfig.yaml --namespace monitoring \
    get secret monitoring-grafana --output jsonpath="{.data.admin-password}" \
    | base64 --decode
```