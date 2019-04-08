## Hands-On Time

---

### Creating A
# Jenkins-X
## Cluster


## Prerequisites

---

* [Git](https://git-scm.com/)
* GitBash (if using Windows)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [Helm](https://helm.sh/)
* [AWS CLI](https://aws.amazon.com/cli/) and AWS admin permissions


## Creating A Cluster With jx

---

```bash
GH_USER=[...]

export AWS_ACCESS_KEY_ID=[...]

export AWS_SECRET_ACCESS_KEY=[...]

export AWS_DEFAULT_REGION=[...]

NAME=jx-rocks && MACHINE=t2.large

MIN_NODES=3 && MAX_NODES=5 && PASS=admin

jx create cluster eks -n $NAME -r $AWS_DEFAULT_REGION --node-type $MACHINE \
    -o $MIN_NODES --nodes-min $MIN_NODES --nodes-max $MAX_NODES \
    --default-admin-password=$PASS --git-username $GH_USER --environment-git-owner $GH_USER --default-environment-prefix jx-rocks --no-tiller
```

* Answer with `n` to `Would you like to register a wildcard DNS ALIAS to point at this ELB address?`
* Answer with `Y` to `Would you like wait and resolve this address to an IP address and use it for the domain?`

```bash
jx console
```

* Use `admin` as the username and password

```bash
kubectl -n jx get pods
```

Note:
```
NAME                                 READY STATUS  RESTARTS AGE
jenkins-...                          1/1   Running 0        7m
jenkins-x-chartmuseum-...            1/1   Running 0        7m
jenkins-x-controllercommitstatus-... 1/1   Running 0        7m
jenkins-x-controllerrole-...         1/1   Running 0        7m
jenkins-x-controllerteam-...         1/1   Running 0        7m
jenkins-x-controllerworkflow-...     1/1   Running 0        7m
jenkins-x-docker-registry-...        1/1   Running 0        7m
jenkins-x-heapster-...               2/2   Running 0        7m
jenkins-x-mongodb-...                1/1   Running 1        7m
jenkins-x-monocular-api-...          1/1   Running 3        7m
jenkins-x-monocular-prerender-...    1/1   Running 0        7m
jenkins-x-monocular-ui-...           1/1   Running 0        7m
jenkins-x-nexus-...                  1/1   Running 0        7m
maven-...                            2/2   Running 0        1m
```

```bash
ASG_NAME=$(aws autoscaling \
    describe-auto-scaling-groups \
    | jq -r ".AutoScalingGroups[] \
    | select(.AutoScalingGroupName \
    | startswith(\"eksctl-$NAME-nodegroup\")) \
    .AutoScalingGroupName")

echo $ASG_NAME

aws autoscaling \
    create-or-update-tags \
    --tags \
    ResourceId=$ASG_NAME,ResourceType=auto-scaling-group,Key=k8s.io/cluster-autoscaler/enabled,Value=true,PropagateAtLaunch=true \
    ResourceId=$ASG_NAME,ResourceType=auto-scaling-group,Key=kubernetes.io/cluster/$NAME,Value=true,PropagateAtLaunch=true

IAM_ROLE=$(aws iam list-roles \
    | jq -r ".Roles[] \
    | select(.RoleName \
    | startswith(\"eksctl-$NAME-nodegroup-0-NodeInstanceRole\")) \
    .RoleName")

echo $IAM_ROLE

aws iam put-role-policy \
    --role-name $IAM_ROLE \
    --policy-name $NAME-AutoScaling \
    --policy-document file://scaling/eks-autoscaling-policy.json

helm install stable/cluster-autoscaler \
    --name aws-cluster-autoscaler \
    --namespace kube-system \
    --set autoDiscovery.clusterName=$NAME \
    --set awsRegion=$AWS_DEFAULT_REGION \
    --set sslCertPath=/etc/kubernetes/pki/ca.crt \
    --set rbac.create=true --wait
```