## Hands-On Time

---

# Auto-Scaling Nodes


### Setting Up Cluster Autoscaler

---

## Follow the instructions for your flavor


### Setting Up Cluster Autoscaler In GKE

---

* Baked in


### Setting Up Cluster Autoscaler In EKS

---

```bash
export NAME=devops25

ASG_NAME=$(aws autoscaling describe-auto-scaling-groups \
    | jq -r ".AutoScalingGroups[] | select(.AutoScalingGroupName \
    | startswith(\"eksctl-$NAME-nodegroup\")).AutoScalingGroupName")

echo $ASG_NAME

aws autoscaling create-or-update-tags --tags \
    ResourceId=$ASG_NAME,ResourceType=auto-scaling-group,Key=k8s.io/cluster-autoscaler/enabled,Value=true,PropagateAtLaunch=true \
    ResourceId=$ASG_NAME,ResourceType=auto-scaling-group,Key=kubernetes.io/cluster/$NAME,Value=true,PropagateAtLaunch=true
```


### Setting Up Cluster Autoscaler In EKS

---

```bash
IAM_ROLE=$(aws iam list-roles | jq -r ".Roles[] | select(.RoleName \
    | startswith(\"eksctl-$NAME-nodegroup-0-NodeInstanceRole\")) \
    .RoleName")

echo $IAM_ROLE

cat scaling/eks-autoscaling-policy.json

aws iam put-role-policy --role-name $IAM_ROLE \
    --policy-name $NAME-AutoScaling \
    --policy-document file://cluster/eks-autoscaling-policy.json
```


### Setting Up Cluster Autoscaler In EKS

---

```bash
helm install stable/cluster-autoscaler \
    --name aws-cluster-autoscaler --namespace kube-system \
    --set autoDiscovery.clusterName=$NAME \
    --set awsRegion=$AWS_DEFAULT_REGION \
    --set sslCertPath=/etc/kubernetes/pki/ca.crt \
    --set rbac.create=true

kubectl -n kube-system rollout status deployment \
    aws-cluster-autoscaler
```


### Setting Up Cluster Autoscaler In AKS

---

* Follow the instructions from the [Cluster Autoscaler on Azure Kubernetes Service (AKS) - Preview](https://docs.microsoft.com/en-us/azure/aks/autoscaler) article.


## Scaling Up The Cluster

---

```bash
kubectl get nodes

cat scaling/go-demo-5-many.yml

kubectl apply -f scaling/go-demo-5-many.yml --record

kubectl -n go-demo-5 get hpa

kubectl -n go-demo-5 get pods
```


<!-- .slide: data-background="img/ca-pending.png" data-background-size="contain" -->


```bash
kubectl -n kube-system get cm cluster-autoscaler-status -o yaml

kubectl -n go-demo-5 describe pods -l app=api \
    | grep cluster-autoscaler

kubectl get nodes
```


<!-- .slide: data-background="img/ca-scale-up.png" data-background-size="contain" -->


## Scaling Up The Cluster

---

```bash
kubectl -n go-demo-5 get pods
```


<!-- .slide: data-background="img/ca-reschedule.png" data-background-size="contain" -->


## Scaling Down The Cluster

---

```bash
kubectl apply -f scaling/go-demo-5.yml --record

kubectl -n go-demo-5 get hpa

kubectl -n go-demo-5 rollout status deployment api

kubectl -n go-demo-5 get pods

kubectl get nodes

kubectl -n kube-system get configmap cluster-autoscaler-status \
    -o yaml
```


<!-- .slide: data-background="img/ca-scale-down.png" data-background-size="contain" -->


## Scaling Down The Cluster

---

```bash
kubectl -n kube-system get configmap cluster-autoscaler-status \
    -o yaml

kubectl get nodes
```


## Scale-Down Rules

---

* The sum of CPU and memory requests of all Pods running on a node is less than 50% of the node's allocatable resources
* All Pods running on the node can be moved to other nodes (those that run on all the nodes are the exception)

---

* A Pod with affinity or anti-affinity rules
* A Pod that uses local storage
* A Pod created directly


## What Now?

---

```bash
kubectl delete ns go-demo-5
```