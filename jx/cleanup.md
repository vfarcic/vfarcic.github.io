## Cleanup (GKE)

---

```bash
gcloud container clusters delete jx-rocks --zone us-east1-b --quiet

gcloud container clusters delete jx-rocks --region us-east1-b --quiet

gcloud compute disks delete $(gcloud compute disks list \
    --filter="-users:*" --format="value(id)")
```


## Cleanup (EKS)

---

```bash
# Only if there are no other ELBs in that region
LB_NAME=$(aws elbv2 describe-load-balancers | jq -r \
    ".LoadBalancers[0].LoadBalancerName")

echo $LB_NAME

aws elb delete-load-balancer --load-balancer-name $LB_NAME

IAM_ROLE=$(aws iam list-roles | jq -r ".Roles[] | select(.RoleName \
    | startswith(\"eksctl-$NAME-nodegroup-0-NodeInstanceRole\")) \
    .RoleName")

aws iam delete-role-policy --role-name $IAM_ROLE \
    --policy-name $NAME-AutoScaling

eksctl delete cluster -n $NAME
```


## Cleanup (AKS)

---

```bash
az aks delete -n $NAME -g $NAME-group --yes

kubectl config delete-cluster jx-rocks

kubectl config delete-context jx-rocks

kubectl config unset users.clusterUser_jx-rocks-group_jx-rocks

az group delete --name $NAME-group --yes
```


## Cleanup

---

```bash
hub delete -y $GH_USER/environment-jx-rocks-staging

hub delete -y $GH_USER/environment-jx-rocks-production

hub delete -y $GH_USER/jx-go

rm -rf ~/.jx/environments/$GH_USER/environment-jx-rocks-*

cd ..

rm -rf jx-go

rm -rf environment-jx-rocks-staging

rm -rf environment-jx-rocks-production

rm -f ~/.jx/jenkinsAuth.yaml
```
