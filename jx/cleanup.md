## Cleanup (GKE)

```bash
gcloud container clusters delete $CLUSTER_NAME --region us-east1 --quiet

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

```bash
eksctl delete cluster -n $CLUSTER_NAME

for volume in `aws ec2 describe-volumes --output text| grep available | awk '{print $8}'`; do
    echo "Deleting volume $volume"
    aws ec2 delete-volume --volume-id $volume
done
```


## Cleanup (AKS)

```bash
az aks delete -n $CLUSTER_NAME -g jxrocks-group --yes

kubectl config delete-cluster $CLUSTER_NAME

kubectl config delete-context $CLUSTER_NAME

kubectl config unset users.clusterUser_jxrocks-group_$CLUSTER_NAME

az group delete --name jxrocks-group --yes
```


## Cleanup

```bash
cd ..

hub delete -y $GH_USER/environment-$CLUSTER_NAME-staging

hub delete -y $GH_USER/environment-$CLUSTER_NAME-production

hub delete -y $GH_USER/jx-go

hub delete -y $GH_USER/jx-serverless

hub delete -y $GH_USER/jx-prow
```


## Cleanup

```bash
hub delete -y $GH_USER/jx-knative

rm -rf ~/.jx/environments/$GH_USER/environment-$CLUSTER_NAME-*

rm -rf jx-go

rm -rf jx-serverless

rm -rf jx-prow

rm -rf jx-knative

rm -rf environment-$CLUSTER_NAME-*
```
