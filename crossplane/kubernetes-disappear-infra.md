<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Infra For Devs

## Hands-on Time


## Infra For Devs

```bash
cat examples/aws-eks-gitops-no-claim.yaml

cp examples/aws-eks-gitops-no-claim.yaml infra/aws-eks.yaml

git add .

git commit -m "My cluster"

git push
```


## Infra For Ops

```bash
kubectl get managed,releases

cat packages/k8s/definition.yaml

cat packages/k8s/eks.yaml

cat packages/gitops/definition.yaml

cat packages/gitops/argo-cd.yaml
```


## Infra For Ops

```bash
cat infra/aws-eks.yaml

kubectl get managed,releases
```


## Infra For Ops

```bash
kubectl --namespace crossplane-system get secret \
    a-team-eks-no-claim-cluster \
    --output jsonpath="{.data.kubeconfig}" \
    | base64 -d >kubeconfig.yaml

kubectl --kubeconfig kubeconfig.yaml get namespaces

kubectl --kubeconfig kubeconfig.yaml --namespace argocd \
    get applications

kubectl --kubeconfig kubeconfig.yaml --namespace argocd \
    port-forward svc/a-team-gitops-no-claim-argocd-server \
    8080:443 &
```


## Infra For Devs

```bash
# Open http://localhost:8080 in a browser

# User `admin`, password `admin123`
```


<!-- .slide: data-background="../img/products/crossplane.png" data-background-size="contain" -->