# Control Planes


## Desired State

```bash
cat examples/vm/aws.yaml

kubectl --namespace a-team apply \
    --filename examples/vm/aws.yaml
```

* It's declarative
* Both humans and machines can find out what the desired state is


# Drift-Detection & Reconciliation


# Discovery

```bash
kubectl get crds

kubectl explain instances.ec2.aws.upbound.io --recursive
```


# Shift-left

```bash
cat examples/k8s/aws-eks.yaml

kubectl --namespace a-team apply \
    --filename examples/k8s/aws-eks.yaml

kubectl --namespace a-team get clusterclaims
```


# Actual State

```bash
kubectl get managed

kubectl get subnets
```


# What Else?


# The Whole CNCF Ecosystem


![](../img/products/crossplane.png)
