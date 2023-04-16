## Cleanup

```bash
kubectl delete --filename examples/sql/aws-official-vap.yaml

kubectl --namespace production delete \
    --filename examples/sql/aws-official.yaml

kubectl get vpcs.ec2.aws.upbound.io,subnets.ec2.aws.upbound.io,subnetgroups.rds.aws.upbound.io,internetgateways.ec2.aws.upbound.io,routetables.ec2.aws.upbound.io,routes.ec2.aws.upbound.io,mainroutetableassociations.ec2.aws.upbound.io,routetableassociations.ec2.aws.upbound.io,securitygroups.ec2.aws.upbound.io,securitygrouprules.ec2.aws.upbound.io,instances.rds.aws.upbound.io

# Wait until all the resources are removeds

minikube delete
```
