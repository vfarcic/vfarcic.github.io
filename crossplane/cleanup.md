## Cleanup

```bash
pkill kubectl

rm apps/*.yaml

rm apps-dev/*.yaml

git add . && git commit -m "Destroy apps" && git push

kubectl --kubeconfig kubeconfig-eks.yaml get managed

# Repeat the previous command until all the managed resources
#   are removed (except `object` and `release` resources)
```


## Cleanup

```bash
kubectl --namespace crossplane-system \
    get secret a-team-eks-cluster \
    --output jsonpath="{.data.kubeconfig}" \
    | base64 -d >kubeconfig-eks.yaml

kubectl --kubeconfig kubeconfig-eks.yaml \
    --namespace ingress-nginx delete service \
    a-team-eks-ingress-ingress-nginx-controller

rm infra/civo.yaml infra/aws-eks.yaml

git add . && git commit -m "Destroy everything" && git push

kubectl get managed

# Repeat the previous command until all the managed resources
#   are removed (except `object` and `release` resources)
```


## Cleanup

```bash
rm crossplane-definitions/*.yaml

rm crossplane-provider-configs/*.yaml

rm infra/*.yaml

git add . && git commit -m "Destroy everything" && git push

# Destroy or reset the management cluster

# Destroy the GitOps repo
```
