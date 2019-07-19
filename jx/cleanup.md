<!--
doctl kubernetes cluster delete jx-rocks -f

# TODO: Remove the volumes
# doctl compute volume list -o json

# TODO: Remove the LB
-->
## Cleanup (GKE)

---

```bash
gcloud container clusters delete jx-rocks --region us-east1 --quiet

gcloud compute disks delete --zone us-east1-b $(gcloud compute disks \
    list --filter="zone:us-east1-b AND -users:*" \
    --format="value(id)") --quiet
gcloud compute disks delete --zone us-east1-c $(gcloud compute disks \
    list --filter="zone:us-east1-c AND -users:*" \
    --format="value(id)") --quiet
gcloud compute disks delete --zone us-east1-d $(gcloud compute disks \
    list --filter="zone:us-east1-d AND -users:*" \
    --format="value(id)") --quiet
```


## Cleanup (EKS)

---

```bash
# Only if there are no other ELBs in that region
LB_NAME=$(aws elbv2 describe-load-balancers | jq -r \
    ".LoadBalancers[0].LoadBalancerName")

echo $LB_NAME

aws elb delete-load-balancer --load-balancer-name $LB_NAME

eksctl delete cluster -n $NAME

for volume in `aws ec2 describe-volumes --output text| grep available | awk '{print $8}'`; do 
    echo "Deleting volume $volume"
    aws ec2 delete-volume --volume-id $volume
done
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
cd ..

hub delete -y $GH_USER/environment-$NAMESPACE-staging

hub delete -y $GH_USER/environment-$NAMESPACE-production

hub delete -y $GH_USER/jx-go

hub delete -y $GH_USER/jx-serverless

hub delete -y $GH_USER/jx-prow

hub delete -y $GH_USER/jx-knative

rm -rf ~/.jx/environments/$GH_USER/environment-$NAMESPACE-*
```


## Cleanup

---

```bash
rm -rf jx-go

rm -rf jx-serverless

rm -rf jx-prow

rm -rf jx-knative

rm -rf environment-$NAMESPACE-*
```
