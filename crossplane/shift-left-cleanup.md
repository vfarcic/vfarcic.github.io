## Cleanup

```bash
cd ../devops-toolkit-crossplane

kubectl --namespace dev delete --filename examples/sql/aws.yaml

kubectl get vpc.ec2.aws.upbound.io,subnet.ec2.aws.upbound.io,subnetgroup.rds.aws.upbound.io,internetgateway.ec2.aws.upbound.io,routetable.ec2.aws.upbound.io,route.ec2.aws.upbound.io,mainroutetableassociation.ec2.aws.upbound.io,routetableassociation.ec2.aws.upbound.io,securitygroup.ec2.aws.upbound.io,securitygrouprule.ec2.aws.upbound.io,instance.rds.aws.upbound.io,database.postgresql.sql.crossplane.io,object.kubernetes.crossplane.io

# Wait until all the resources are deleted
#   (ignore `database` resource)
```


## Cleanup

```bash
unset KUBECONFIG

kubectl --namespace a-team delete \
    --filename examples/k8s/aws-eks-1-22.yaml

kubectl get cluster.eks.aws.upbound.io,clusterauths.eks.aws.upbound.io,nodegroup.eks.aws.upbound.io,role.iam.aws.upbound.io,rolepolicyattachment.iam.aws.upbound.io,vpc.ec2.aws.upbound.io,securitygroup.ec2.aws.upbound.io,securitygrouprule.ec2.aws.upbound.io,subnet.ec2.aws.upbound.io,internetgateway.ec2.aws.upbound.io,routetable.ec2.aws.upbound.io,route.ec2.aws.upbound.io,mainroutetableassociation.ec2.aws.upbound.io,routetableassociation.ec2.aws.upbound.io

# Wait until all the resources are deleted

# Destroy or reset the management cluster
```
