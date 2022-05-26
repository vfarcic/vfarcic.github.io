<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Apps For Devs

## Hands-on Time


## Apps For Devs

```bash
mkdir -p apps

cat examples/app-frontend-no-claim.yaml

cp examples/app-frontend-no-claim.yaml apps/

cat examples/app-backend-no-claim.yaml

cp examples/app-backend-no-claim.yaml apps/
```


## Apps For Ops

```bash
git add .

git commit -m "Adding dot"

git push
```


## Apps For Ops

```bash
kubectl --namespace crossplane-system get secret \
    a-team-eks-no-claim-cluster \
    --output jsonpath="{.data.kubeconfig}" \
    | base64 -d >kubeconfig.yaml

kubectl --kubeconfig kubeconfig.yaml --namespace production \
    get all,hpa,ingresses
```
