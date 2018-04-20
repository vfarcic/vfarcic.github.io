## Hands-On Time

---

# Persisting State


## Without Persisting State

---

```bash
cat pv/jenkins-no-pv.yml

kubectl create -f pv/jenkins-no-pv.yml --record --save-config

kubectl -n jenkins get events

kubectl -n jenkins create secret generic jenkins-creds \
    --from-literal=jenkins-user=jdoe \
    --from-literal=jenkins-pass=incognito

kubectl -n jenkins rollout status deployment jenkins

open "http://$CLUSTER_DNS/jenkins"

# Create a job
```


## Without Persisting State

---

```bash
kubectl -n jenkins get pods --selector=app=jenkins -o json

POD_NAME=$(kubectl -n jenkins get pods --selector=app=jenkins \
    -o jsonpath="{.items[*].metadata.name}")

echo $POD_NAME

kubectl -n jenkins exec -it $POD_NAME pkill java

open "http://$CLUSTER_DNS/jenkins"
```


## Creating AWS Volumes

---

```bash
aws ec2 describe-instances

aws ec2 describe-instances | jq -r ".Reservations[].Instances[] \
    | select(.SecurityGroups[].GroupName==\"nodes.$NAME\")\
    .Placement.AvailabilityZone"

aws ec2 describe-instances | jq -r ".Reservations[].Instances[] \
    | select(.SecurityGroups[].GroupName==\"nodes.$NAME\")\
    .Placement.AvailabilityZone" | tee zones

AZ_1=$(cat zones | head -n 1)

AZ_2=$(cat zones | tail -n 1)
```


## Creating AWS Volumes

---

```bash
VOLUME_ID_1=$(aws ec2 create-volume --availability-zone $AZ_1 \
    --tag-specifications "ResourceType=volume,Tags=[{Key=KubernetesCluster,Value=$NAME}]" \
    --size 10 --volume-type gp2 | jq -r '.VolumeId')

VOLUME_ID_2=$(aws ec2 create-volume --availability-zone $AZ_1 \
    --tag-specifications "ResourceType=volume,Tags=[{Key=KubernetesCluster,Value=$NAME}]" \
    --size 10 --volume-type gp2 | jq -r '.VolumeId')

VOLUME_ID_3=$(aws ec2 create-volume --availability-zone $AZ_2 \
    --tag-specifications "ResourceType=volume,Tags=[{Key=KubernetesCluster,Value=$NAME}]" \
    --size 10 --volume-type gp2 | jq -r '.VolumeId')

echo $VOLUME_ID_1

aws ec2 describe-volumes --volume-ids $VOLUME_ID_1
```


<!-- .slide: data-background="img/persistent-volume-ebs.png" data-background-size="contain" -->


## k8s Persistent Volumes

---

```bash
cat pv/pv.yml

cat pv/pv.yml | sed -e "s@REPLACE_ME_1@$VOLUME_ID_1@g" \
    | sed -e "s@REPLACE_ME_2@$VOLUME_ID_2@g" \
    | sed -e "s@REPLACE_ME_3@$VOLUME_ID_3@g" \
    | kubectl create -f - --save-config --record

kubectl get pv
```


<!-- .slide: data-background="img/persistent-volume-pv.png" data-background-size="contain" -->


## Claiming Persistent Volumes

---

```bash
cat pv/pvc.yml

kubectl create -f pv/pvc.yml --save-config --record

kubectl -n jenkins get pvc

kubectl get pv
```


<!-- .slide: data-background="img/persistent-volume-pvc.png" data-background-size="contain" -->


## Attaching Claimed Volumes

---

```bash
cat pv/jenkins-pv.yml

kubectl apply -f pv/jenkins-pv.yml --record

kubectl -n jenkins rollout status deployment jenkins
```


<!-- .slide: data-background="img/persistent-volume-pod.png" data-background-size="contain" -->


## Attaching Claimed Volumes

---

```bash
open "http://$CLUSTER_DNS/jenkins"

# Create a job

POD_NAME=$(kubectl -n jenkins get pod --selector=app=jenkins \
    -o jsonpath="{.items[*].metadata.name}")

kubectl -n jenkins exec -it $POD_NAME pkill java

open "http://$CLUSTER_DNS/jenkins"

kubectl -n jenkins delete deploy jenkins

kubectl -n jenkins get pvc

kubectl get pv
```


## Attaching Claimed Volumes

---

```bash
kubectl -n jenkins delete pvc jenkins

kubectl get pv

kubectl delete -f pv/pv.yml

aws ec2 delete-volume --volume-id $VOLUME_ID_1

aws ec2 delete-volume --volume-id $VOLUME_ID_2

aws ec2 delete-volume --volume-id $VOLUME_ID_3
```


## Using Storage Classes

---

```bash
kubectl get sc

cat pv/jenkins-dynamic.yml

kubectl apply -f pv/jenkins-dynamic.yml --record

kubectl -n jenkins rollout status deployment jenkins

kubectl -n jenkins get events

kubectl -n jenkins get pvc

kubectl get pv

aws ec2 describe-volumes \
    --filters 'Name=tag-key,Values="kubernetes.io/created-for/pvc/name"'
```


## Using Storage Classes

---

```bash
kubectl -n jenkins delete deploy,pvc jenkins

kubectl get pv

aws ec2 describe-volumes \
    --filters 'Name=tag-key,Values="kubernetes.io/created-for/pvc/name"'
```


## Default Storage Classes

---

```bash
kubectl get sc

kubectl describe sc gp2

cat pv/jenkins-default.yml

diff pv/jenkins-dynamic.yml pv/jenkins-default.yml

kubectl apply -f pv/jenkins-default.yml --record

kubectl get pv

kubectl -n jenkins delete deploy,pvc jenkins
```


## Creating Storage Classes

---

```bash
cat pv/sc.yml

kubectl create -f pv/sc.yml

kubectl get sc

cat pv/jenkins-sc.yml

kubectl apply -f pv/jenkins-sc.yml --record

aws ec2 describe-volumes \
    --filters 'Name=tag-key,Values="kubernetes.io/created-for/pvc/name"'
```


<!-- .slide: data-background="img/persistent-volume-sc.png" data-background-size="contain" -->


## What Now?

---

```bash
kubectl delete ns jenkins

kubectl delete sc fast
```
