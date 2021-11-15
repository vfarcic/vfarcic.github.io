<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Infra For Devs

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Infra For Devs

```bash
cat examples/aws-eks-gitops-no-claim.yaml

cp examples/aws-eks-gitops-no-claim.yaml infra/aws-eks.yaml

git add .

git commit -m "My cluster"

git push
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Infra For Ops

```bash
kubectl get managed,releases,objects.kubernetes.crossplane.io

cat crossplane-config/definition-k8s.yaml

cat crossplane-config/composition-eks.yaml

cat infra/aws-eks.yaml

kubectl get managed,releases,objects.kubernetes.crossplane.io
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Infra For Ops

```bash
kubectl --namespace crossplane-system get secret \
    a-team-eks-no-claim-ekscluster --output jsonpath="{.data.kubeconfig}" \
    | base64 -d >kubeconfig.yaml

export KUBECONFIG=$PWD/kubeconfig.yaml

kubectl get namespaces

kubectl --namespace argocd get applications

kubectl --namespace argocd port-forward \
    svc/a-team-eks-no-claim-argocd-server 8080:443 &
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Infra For Devs

```bash
# Open http://localhost:8080 in a browser

# User `admin`, password `admin123`

unset KUBECONFIG
```


<!-- .slide: data-background="../img/products/crossplane.png" data-background-size="contain" -->