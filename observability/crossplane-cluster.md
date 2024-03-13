# App Cluster

![](../img/products/crossplane.png)


# App Cluster

```sh
cat cluster/aws-2.yaml

kubectl --namespace a-team apply --filename cluster/aws-2.yaml

crossplane beta trace clusterclaim cluster-2 --namespace a-team
```
