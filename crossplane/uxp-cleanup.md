<!-- .slide: class="center" -->
<!-- .slide: data-background="data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/cleanup.jpg) center / cover" -->
## Cleanup

```bash
kubectl delete --filename examples/vm/equinix.yaml

kubectl --namespace a-team delete --filename examples/k8s/aws-eks.yaml

kubectl get managed

# Wait until all the resources are removed

# Destroy the management cluster
```
