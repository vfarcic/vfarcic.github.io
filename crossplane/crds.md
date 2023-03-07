# Custom
# Resource
# Definitions


```yaml
apiVersion: devopstoolkitseries.com/v1alpha1
kind: AppClaim
metadata:
  name: silly-demo
spec:
  id: silly-demo
  compositionSelector:
    matchLabels:
      type: backend-db
      location: local
  parameters:
    namespace: production
    image: vfarcic/sql-demo:0.1.10
    port: 8080
    host: sillydemo.com
```


<!-- .slide: data-background="img/crds/02.jpg" data-background-size="cover" -->


![](../img/products/crossplane.png)


```bash
cat examples/sql/aws-official.yaml

kubectl --namespace production apply \
    --filename examples/sql/aws-official.yaml

kubectl get vpcs.ec2.aws.upbound.io,subnets.ec2.aws.upbound.io,subnetgroups.rds.aws.upbound.io,internetgateways.ec2.aws.upbound.io,routetables.ec2.aws.upbound.io,routes.ec2.aws.upbound.io,mainroutetableassociations.ec2.aws.upbound.io,routetableassociations.ec2.aws.upbound.io,securitygroups.ec2.aws.upbound.io,securitygrouprules.ec2.aws.upbound.io,instances.rds.aws.upbound.io,databases.postgresql.sql.crossplane.io,objects.kubernetes.crossplane.io
```


# Policies For All Those?


# Planning Retirement?


<!-- .slide: data-background="img/crds/03.jpg" data-background-size="cover" -->


* https://marketplace.upbound.io

```bash
cat examples/sql/aws-official.yaml

cat examples/sql/aws-official-vap.yaml

kubectl apply --filename examples/sql/aws-official-vap.yaml

kubectl --namespace production2 apply \
    --filename examples/sql/aws-official.yaml
```
