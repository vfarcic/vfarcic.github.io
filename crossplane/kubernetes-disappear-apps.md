<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Apps For Devs

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Apps For Devs

```bash
mkdir -p apps

cat examples/app-frontend-no-claim.yaml

cp examples/app-frontend-no-claim.yaml apps/

cat examples/app-backend-no-claim.yaml

cp examples/app-backend-no-claim.yaml apps/
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Apps For Ops

```bash
git add .

git commit -m "Adding dot"

git push
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Apps For Ops

```bash
kubectl --namespace crossplane-system get secret \
    a-team-eks-no-claim-cluster --output jsonpath="{.data.kubeconfig}" \
    | base64 -d >kubeconfig.yaml

kubectl --kubeconfig kubeconfig.yaml --namespace production get all,hpa,ingresses
```
