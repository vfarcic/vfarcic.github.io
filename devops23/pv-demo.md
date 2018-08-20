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

JENKINS_ADDR=$(kubectl -n jenkins get ing jenkins \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

open "http://$JENKINS_ADDR/jenkins"
```

* Log in with user *jdoe* and the password *incognito*


## Without Persisting State

---

* We installed Jenkins
* We retrieved the events and observed that it is failing because the `jenkins-creds` Secret is missing
* We created the missing Secret
* We waited until Jenkins rolled out and opened it in browser


## Without Persisting State

---

* Create a job

```bash
kubectl -n jenkins get pods --selector=app=jenkins -o json

POD_NAME=$(kubectl -n jenkins get pods --selector=app=jenkins \
    -o jsonpath="{.items[*].metadata.name}")

echo $POD_NAME

kubectl -n jenkins exec -it $POD_NAME pkill java

open "http://$JENKINS_ADDR/jenkins"
```


## Without Persisting State

---

* We created a new job
* We simulated failure by killing the `java` process
* We observed that Jenkins recuperated from the failure, but it lost its state (the job)


## Creating AWS Volumes

---

```bash
aws ec2 describe-instances

# If kops
GROUP_NAME=nodes.$NAME

# If EKS
GROUP_NAME=EKS-devops24-DefaultNodeGroup-NodeSecurityGroup

aws ec2 describe-instances | jq -r ".Reservations[].Instances[] \
    | select(.SecurityGroups[].GroupName | startswith(\"$GROUP_NAME\"))\
    .Placement.AvailabilityZone"

aws ec2 describe-instances | jq -r ".Reservations[].Instances[] \
    | select(.SecurityGroups[].GroupName | startswith(\"$GROUP_NAME\"))\
    .Placement.AvailabilityZone" | tee zones
```


## Creating AWS Volumes

---

* We retrieved the zones of our cluster


## Creating AWS Volumes

---

```bash
AZ_1=$(cat zones | head -n 1)

AZ_2=$(cat zones | tail -n 1)

VOLUME_ID_1=$(aws ec2 create-volume --availability-zone $AZ_1 \
    --tag-specifications "ResourceType=volume,Tags=[{Key=KubernetesCluster,Value=devops23}]" \
    --size 10 --volume-type gp2 | jq -r '.VolumeId')

VOLUME_ID_2=$(aws ec2 create-volume --availability-zone $AZ_2 \
    --tag-specifications "ResourceType=volume,Tags=[{Key=KubernetesCluster,Value=devops23}]" \
    --size 10 --volume-type gp2 | jq -r '.VolumeId')

VOLUME_ID_3=$(aws ec2 create-volume --availability-zone $AZ_1 \
    --tag-specifications "ResourceType=volume,Tags=[{Key=KubernetesCluster,Value=devops23}]" \
    --size 10 --volume-type gp2 | jq -r '.VolumeId')
```


## Creating AWS Volumes

---

* We created three volumes spread in two zones


## Creating AWS Volumes

---

```bash
echo $VOLUME_ID_1

aws ec2 describe-volumes --volume-ids $VOLUME_ID_1
```


## Creating AWS Volumes

---

* We described one of the volumes as a way to confirm that it was created correctly


<!-- .slide: data-background="img/persistent-volume-ebs.png" data-background-size="contain" -->


## k8s Persistent Volumes

---

```bash
cat pv/pv.yml

cat pv/pv.yml \
    | sed -e "s@REPLACE_ME_1@$VOLUME_ID_1@g" \
    | sed -e "s@REPLACE_ME_2@$VOLUME_ID_2@g" \
    | sed -e "s@REPLACE_ME_3@$VOLUME_ID_3@g" \
    | kubectl create -f - --save-config --record

kubectl get pv
```


## k8s Persistent Volumes

---

* We created three PersistentVolumes matching the three EBS volumes


<!-- .slide: data-background="img/persistent-volume-pv.png" data-background-size="contain" -->


## Claiming Persistent Volumes

---

```bash
cat pv/pvc.yml

kubectl create -f pv/pvc.yml --save-config --record

kubectl -n jenkins get pvc

kubectl get pv
```


## Claiming Persistent Volumes

---

* We created a PersistentVolumeClaim that uses the StorageClass `manual-ebs`
* We retrieved the PersistentVolumes and observed that one of them is `Bound` to the claim


<!-- .slide: data-background="img/persistent-volume-pvc.png" data-background-size="contain" -->


## Attaching Claimed Volumes

---

```bash
cat pv/jenkins-pv.yml

kubectl apply -f pv/jenkins-pv.yml --record

kubectl -n jenkins rollout status deployment jenkins
```


## Attaching Claimed Volumes

---

* We updated Jenkins by adding a mount that uses the PersistentVolumeClaim


<!-- .slide: data-background="img/persistent-volume-pod.png" data-background-size="contain" -->


## Attaching Claimed Volumes

---

```bash
open "http://$JENKINS_ADDR/jenkins"
```

* Create a job

```bash
POD_NAME=$(kubectl -n jenkins get pod --selector=app=jenkins \
    -o jsonpath="{.items[*].metadata.name}")

kubectl -n jenkins exec -it $POD_NAME pkill java

open "http://$JENKINS_ADDR/jenkins"

kubectl -n jenkins delete deploy jenkins

kubectl -n jenkins get pvc

kubectl get pv
```


## Attaching Claimed Volumes

---

* We created a new Job
* We simulated failure
* We confirmed that Jenkins recuperated from the failure and that the state (the job) is preserved
* We deleted Jenkins
* We observed that the PVC and PV are still bound


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


## Attaching Claimed Volumes

---

* We removed the PersistentVolumeClaim and observed that the PV was released
* We deleted the PVs and the EBS volumes


## Using Storage Classes

---

```bash
# If EKS
echo 'kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: gp2
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
  encrypted: "true"' | kubectl create -f -

kubectl get sc

cat pv/jenkins-dynamic.yml
```


## Using Storage Classes

---

* In case of EKS, we created a new StorageClass (most other flavors have it out-of-the-box)
* We output a new Jenkins definition with a PersistentVolumeClaim that uses the newly created StorageClass


## Using Storage Classes

---

```bash
kubectl apply -f pv/jenkins-dynamic.yml --record

kubectl -n jenkins rollout status deployment jenkins

kubectl -n jenkins get events

kubectl -n jenkins get pvc

kubectl get pv

aws ec2 describe-volumes \
    --filters 'Name=tag-key,Values="kubernetes.io/created-for/pvc/name"'

kubectl -n jenkins delete deploy,pvc jenkins
```


## Using Storage Classes

---

* We updated Jenkins
* We retrieved the events and observed that it provisioner a new volume
* We retrieved PersistentVolumeClaims and observed that it is bound to a new volume
* We retrieved Volumes and observed that a new one was created with the reclaim policy set to `DELETE`
* We described AWS volumes and observed that a new one was created
* We deleted Jenkins Deployment and PersistentVolumeClaim


## Using Storage Classes

---

```bash
kubectl get pv

aws ec2 describe-volumes \
    --filters 'Name=tag-key,Values="kubernetes.io/created-for/pvc/name"'
```


## Using Storage Classes

---

* We retrieved PersistentVolumes and observed that the one we used before was automatically removed with the removal of the PersistentVolumeClaim
* We retrieved AWS volumes and observed that the one created by the PersitentVolume was removed


## Default Storage Classes

---

```bash
# If EKS
kubectl patch storageclass gp2 \
    -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

kubectl get sc

kubectl describe sc gp2

cat pv/jenkins-default.yml

diff pv/jenkins-dynamic.yml pv/jenkins-default.yml

kubectl apply -f pv/jenkins-default.yml --record

kubectl get pv
```


## Default Storage Classes

---

* In case of EKS, we patched the StorageClass to make it default (most of the other flavors have it out-of-the-box)
* We confirmed that the StorageClass is set to be `default`
* We updated Jenkins to use a StorageClass that does not specify `storageClassName`
* We retrieved PersistentVolumes and observed that a new one was created


## Creating Storage Classes

---

```bash
kubectl -n jenkins delete deploy,pvc jenkins

cat pv/sc.yml

kubectl create -f pv/sc.yml

kubectl get sc

cat pv/jenkins-sc.yml

kubectl apply -f pv/jenkins-sc.yml --record

aws ec2 describe-volumes \
    --filters 'Name=tag-key,Values="kubernetes.io/created-for/pvc/name"'
```


## Creating Storage Classes

---

* We deleted Jenkins Deployment and PersistentVolumeClaim
* We created a new StorageClass based on a different EBS type
* We Updated Jenkins to use the new StorageClass
* We retrieved EBS volumes and observed that the newly created one is based on `io1`


<!-- .slide: data-background="img/persistent-volume-sc.png" data-background-size="contain" -->


## What Now?

---

```bash
kubectl delete ns jenkins

kubectl delete sc fast
```
