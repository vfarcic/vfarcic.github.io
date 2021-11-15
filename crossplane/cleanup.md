<!-- .slide: class="center" -->
<!-- .slide: data-background="data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/cleanup.jpg) center / cover" -->
## Cleanup

```bash
unset KUBECONFIG

cd ../devops-toolkit-crossplane

pkill kubectl

rm infra/*.yaml

git add . && git commit -m "Removing dot" && git push
```


<!-- .slide: class="center" -->
<!-- .slide: data-background="data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/cleanup.jpg) center / cover" -->
## Cleanup

```bash
kubectl get managed

# Repeat the previous command until all the managed resources are removed

# Destroy or reset the management cluster

# Destroy the GitOps repo
```
