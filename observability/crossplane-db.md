# Database

![](../img/products/crossplane.png)


# Database

```sh
cat db/aws-2.yaml

kubectl --namespace a-team apply --filename db/aws-2.yaml

crossplane beta trace sqlclaim my-db-2 --namespace a-team
```
