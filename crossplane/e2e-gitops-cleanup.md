## Cleanup

```bash
rm -rf delete dev-apps/*.yaml

touch dev-apps/dummy

rm -rf delete prod-apps/*.yaml

touch prod-apps/dummy
```


## Cleanup

```bash
git add .

git commit -m "Remove apps"

git push

kubectl --kubeconfig kubeconfig.yaml get managed

# Repeat the previous command until all the `aws` resources 
#   are deleted
```


## Cleanup

```bash
kubectl --kubeconfig kubeconfig.yaml --namespace ingress-nginx \
    delete service production-ingress-ingress-nginx-controller

# TODO: Remove only the clusters
rm -rf infra/*.yaml

git add .

git commit -m "Destroy"

git push

kubectl get managed

# Repeat the previous command until all the `aws` resources 
#   are deleted
```


## Cleanup

```bash
# Destroy or reset the management cluster

gh repo view --web

# Delete the repo

cd ..

rm -rf devops-toolkit-crossplane
```
