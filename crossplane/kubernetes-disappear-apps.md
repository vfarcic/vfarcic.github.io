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

cat orig/devops-toolkit-kubevela.yaml

cp orig/devops-toolkit-kubevela.yaml apps/

git add .

git commit -m "Adding dot"

git push
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Apps For Ops

```bash
cat crossplane-config/composition-eks.yaml

kubectl --namespace crossplane-system get secret \
    a-team-eks-no-claim-ekscluster --output jsonpath="{.data.kubeconfig}" \
    | base64 -d >kubeconfig.yaml

export KUBECONFIG=$PWD/kubeconfig.yaml

kubectl --namespace production get all,hpa,ingresses
```
