<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Apps Need A Cluster

<div class="label">Hands-on Time</div>


## Apps Need A Cluster

```bash
cat examples/k8s/aws-eks.yaml

# Open https://marketplace.upbound.io/configurations/devops-toolkit/dot-kubernetes

kubectl --namespace a-team apply \
    --filename examples/k8s/aws-eks-1-22.yaml

kubectl --namespace a-team get clusterclaims
```


## A Cluster Needs To Be Accessible

```bash
kubectl --namespace a-team get secrets

./examples/k8s/get-kubeconfig-eks.sh a-team a-team-eks

export KUBECONFIG=$PWD/kubeconfig.yaml

kubectl get nodes
```
