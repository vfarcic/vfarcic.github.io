<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Setup

<div class="label">Hands-on Time</div>


## Cluster

* Create a Kubernetes cluster
* A local cluster like Rancher Desktop should do for the demo
* That cluster will serve as a management cluster

*In the "real world" situation, you should have a "real" cluster instead.*


## CLI & Repos

* Install `okteto` CLI from https://www.okteto.com/docs/getting-started/#installing-okteto-cli

```bash
git clone https://github.com/vfarcic/silly-demo

git clone https://github.com/vfarcic/devops-toolkit-crossplane

cd devops-toolkit-crossplane
```


## Crossplane

```bash
helm repo add crossplane-stable \
    https://charts.crossplane.io/stable

helm repo update

helm upgrade --install \
    crossplane crossplane-stable/crossplane \
    --namespace crossplane-system --create-namespace --wait
```


## Crossplane

```bash
# The demo is using AWS.
# Using a different provider might require changes to some
#   of the commands and manifests.

# Replace `[...]` with your access key ID`
export AWS_ACCESS_KEY_ID=[...]

# Replace `[...]` with your secret access key
export AWS_SECRET_ACCESS_KEY=[...]

echo "[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
" >aws-creds.conf
```


## Crossplane

```bash
kubectl --namespace crossplane-system create secret generic \
    aws-creds --from-file creds=./aws-creds.conf

kubectl apply \
    --filename crossplane-config/provider-aws-official.yaml

kubectl apply \
    --filename crossplane-config/config-k8s.yaml

kubectl apply \
    --filename crossplane-config/config-sql.yaml

kubectl get pkgrev

# Wait until all the packages are healthy
```


## Cluster

```bash
kubectl apply \
    --filename crossplane-config/provider-config-aws-official.yaml

kubectl create namespace a-team

kubectl --namespace a-team apply \
    --filename examples/k8s/aws-eks-official.yaml

kubectl --namespace a-team get clusterclaims

./examples/k8s/get-kubeconfig-aws.sh a-team-eks

export KUBECONFIG=$PWD/kubeconfig.yaml
```


## Cluster

```bash
./examples/k8s/create-secret-aws.sh

kubectl --namespace dev apply \
    --filename examples/sql/aws-official.yaml

# kubectl get vpc.ec2.aws.upbound.io,subnet.ec2.aws.upbound.io,subnetgroup.rds.aws.upbound.io,internetgateway.ec2.aws.upbound.io,routetable.ec2.aws.upbound.io,route.ec2.aws.upbound.io,mainroutetableassociation.ec2.aws.upbound.io,routetableassociation.ec2.aws.upbound.io,securitygroup.ec2.aws.upbound.io,securitygrouprule.ec2.aws.upbound.io,instance.rds.aws.upbound.io,database.postgresql.sql.crossplane.io,object.kubernetes.crossplane.io

kubectl --namespace dev get sqlclaims
```

## SchemaHero

```bash
kubectl krew install schemahero

export PATH="${PATH}:${HOME}/.krew/bin"

kubectl schemahero install
```

## Almost Done

```
unset KUBECONFIG
```
