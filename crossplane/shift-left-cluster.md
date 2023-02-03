<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Apps Need A Cluster

<div class="label">Hands-on Time</div>


## Apps Need A Cluster

```bash
cat examples/k8s/gcp-gke-official.yaml

# Open https://marketplace.upbound.io/configurations/devops-toolkit/dot-kubernetes

kubectl --namespace a-team apply \
    --filename examples/k8s/gcp-gke-official.yaml

kubectl --namespace a-team get clusterclaims
```


## A Cluster Needs To Be Accessible

```bash
kubectl --namespace a-team get secrets

export KUBECONFIG=$PWD/kubeconfig.yaml

kubectl get nodes
```
