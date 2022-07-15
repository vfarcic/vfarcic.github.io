## Cleanup

```bash
pkill kubectl

rm apps/*.yaml

git add . && git commit -m "Destroy apps" && git push

kubectl --namespace upbound-system get secret \
    a-team-eks --output jsonpath="{.data.kubeconfig}" \
    | base64 -d >kubeconfig.yaml

kubectl --kubeconfig kubeconfig.yaml get managed
```


## Cleanup

```bash
kubectl --kubeconfig kubeconfig.yaml \
    --namespace ingress-nginx delete service \
    a-team-eks-ingress-ingress-nginx-controller

# Delete `ClusterClaim` and `GitOpsClaim` resources
#   from the Upbound console

kubectl get managed

# Repeat the previous command until all the managed resources
#   are removed (except `object` and `release` resources)
```
