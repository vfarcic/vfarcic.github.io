## Hands-On Time

---

# Persisting State


## Creating An EKS Cluster

---

```bash
# Follow the instructions from
# https://github.com/weaveworks/eksctl to intall eksctl.

export AWS_ACCESS_KEY_ID=[...] # Replace [...] with AWS access key ID

export AWS_SECRET_ACCESS_KEY=[...] # Replace [...] with AWS secret access key

export AWS_DEFAULT_REGION=us-west-2

mkdir -p cluster

eksctl create cluster -n devops23 -r $AWS_DEFAULT_REGION \
    --kubeconfig cluster/kubecfg-eks --node-type t2.small \
    --nodes 3 --nodes-max 9 --nodes-min 3

export KUBECONFIG=$PWD/cluster/kubecfg-eks
```


## Creating An EKS Cluster

---

```bash
kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml

kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/aws/service-l4.yaml

kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/aws/patch-configmap-l4.yaml
```


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
```


## Without Persisting State

---

* We installed Jenkins
* We retrieved the events and observed that it is failing because the `jenkins-creds` Secret is missing
* We created the missing Secret
* We waited until Jenkins rolled out and opened it in browser


## Without Persisting State

---

```bash
# If minikube
JENKINS_ADDR=$(minikube ip)

# If EKS
JENKINS_ADDR=$(kubectl -n jenkins get ing jenkins \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# If GKE
JENKINS_ADDR=$(kubectl -n jenkins get ing jenkins \
    -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

echo $JENKINS_ADDR

open "http://$JENKINS_ADDR/jenkins"
```

* Log in with user *jdoe* and the password *incognito*


## Without Persisting State

---

* We opened Jenkins in browser


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


## Creating Volumes (AWS)

---

```bash
aws ec2 describe-instances

# If EKS
GROUP_NAME=eksctl-devops23-nodegroup-0-SG

aws ec2 describe-instances | jq -r ".Reservations[].Instances[] \
    | select(.SecurityGroups[].GroupName | startswith(\"$GROUP_NAME\"))\
    .Placement.AvailabilityZone"

aws ec2 describe-instances | jq -r ".Reservations[].Instances[] \
    | select(.SecurityGroups[].GroupName | startswith(\"$GROUP_NAME\"))\
    .Placement.AvailabilityZone" | tee zones
```


## Creating Volumes (AWS)

---

* We retrieved the zones of our cluster


## Creating Volumes (AWS)

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


## Creating Volumes (AWS)

---

* We created three volumes spread in two zones


## Creating Volumes (AWS)

---

```bash
echo $VOLUME_ID_1

aws ec2 describe-volumes --volume-ids $VOLUME_ID_1
```


## Creating Volumes (AWS)

---

* We described one of the volumes as a way to confirm that it was created correctly


## Creating Volumes (GKE)

---

```bash
gcloud compute instances list --filter="name:('gke-devops23*')" \
    --format 'csv[no-heading](zone)' | tee zones

AZ_1=$(cat zones | head -n 1)

AZ_2=$(cat zones | tail -n 2 | head -n 1)

AZ_3=$(cat zones | tail -n 1)

gcloud compute disks create disk1 --zone $AZ_1

gcloud compute disks create disk2 --zone $AZ_2

gcloud compute disks create disk3 --zone $AZ_3
```


## Creating Volumes (GKE)

---

* We retrieved the zones of our cluster
* We created three volumes spread in three zones


## Creating Volumes (GKE)

---

```bash
VOLUME_ID_1=disk1

VOLUME_ID_2=disk2

VOLUME_ID_3=disk3

gcloud compute disks describe VOLUME_ID_1
```


## Creating Volumes (GKE)

---

* We described one of the volumes as a way to confirm that it was created correctly


<!-- .slide: data-background="img/persistent-volume-ebs.png" data-background-size="contain" -->


## k8s Persistent Volumes

---

```bash
# If EKS
YAML=pv/pv.yml

# If GKE
YAML=pv/pv-gke.yml

cat $YAML

cat $YAML \
    | sed -e "s@REPLACE_ME_1@$VOLUME_ID_1@g" \
    | sed -e "s@REPLACE_ME_2@$VOLUME_ID_2@g" \
    | sed -e "s@REPLACE_ME_3@$VOLUME_ID_3@g" \
    | kubectl create -f - --save-config --record

kubectl get pv
```


## k8s Persistent Volumes

---

* We created three PersistentVolumes matching the three external drives


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

# If EKS
aws ec2 delete-volume --volume-id $VOLUME_ID_1
aws ec2 delete-volume --volume-id $VOLUME_ID_2
aws ec2 delete-volume --volume-id $VOLUME_ID_3

# If GKE
gcloud compute disks delete $VOLUME_ID_1 --zone $AZ_1 --quiet
gcloud compute disks delete $VOLUME_ID_2 --zone $AZ_2 --quiet
gcloud compute disks delete $VOLUME_ID_3 --zone $AZ_3 --quiet
```


## Attaching Claimed Volumes

---

* We removed the PersistentVolumeClaim and observed that the PV was released
* We deleted the PVs and the external drives


## Using Storage Classes (EKS)

---

```bash
kubectl get sc

# If EKS
cat pv/jenkins-dynamic.yml

# If GKE
cat pv/jenkins-dynamic-gke.yml

# If EKS
kubectl apply -f pv/jenkins-dynamic.yml --record

# If GKE
kubectl apply -f pv/jenkins-dynamic-gke.yml --record

kubectl -n jenkins rollout status deployment jenkins
```


## Using Storage Classes

---

* We output a new Jenkins definition with a PersistentVolumeClaim that uses the StorageClass
* We updated Jenkins


## Using Storage Classes

---

```bash
kubectl -n jenkins get events

kubectl -n jenkins get pvc

kubectl get pv

# If EKS
aws ec2 describe-volumes \
    --filters 'Name=tag-key,Values="kubernetes.io/created-for/pvc/name"'

# If GKE
PV_NAME=$(kubectl get pv -o jsonpath="{.items[0].metadata.name}")

# If GKE
gcloud compute disks list --filter="name:('$PV_NAME')"
```


## Using Storage Classes

---

* We retrieved the events and observed that it provisioned a new volume
* We retrieved PersistentVolumeClaims and observed that it is bound to a new volume
* We retrieved Volumes and observed that a new one was created with the reclaim policy set to `DELETE`
* We observed that a new external drive was created


## Using Storage Classes

---

```bash
kubectl -n jenkins delete deploy,pvc jenkins

kubectl get pv

# If EKS
aws ec2 describe-volumes \
    --filters 'Name=tag-key,Values="kubernetes.io/created-for/pvc/name"'

# If GKE
gcloud compute disks list --filter="name:('$PV_NAME')"
```


## Using Storage Classes

---

* We deleted Jenkins Deployment and PersistentVolumeClaim
* We retrieved PersistentVolumes and observed that the one we used before was automatically removed with the removal of the PersistentVolumeClaim
* We retrieved external drives and observed that the one created by the PersitentVolume was removed


## Default Storage Classes

---

```bash
kubectl get sc

kubectl describe sc

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

# If EKS
YAML=sc.yml

# If GKE
YAML=sc-gke.yml

cat pv/$YAML

kubectl create -f pv/$YAML

kubectl get sc
```


## Creating Storage Classes

---

* We deleted Jenkins Deployment and PersistentVolumeClaim
* We created a new StorageClass based on a different EBS type


## Creating Storage Classes

---

```bash
cat pv/jenkins-sc.yml

kubectl apply -f pv/jenkins-sc.yml --record

# If EKS
aws ec2 describe-volumes \
    --filters 'Name=tag-key,Values="kubernetes.io/created-for/pvc/name"'

# If GKE
PV_NAME=$(kubectl get pv -o jsonpath="{.items[0].metadata.name}")

# If GKE
gcloud compute disks list --filter="name:('$PV_NAME')"
```


## Creating Storage Classes

---

* We Updated Jenkins to use the new StorageClass
* We retrieved external disks and observed that the newly created one is based on the `fast` type


<!-- .slide: data-background="img/persistent-volume-sc.png" data-background-size="contain" -->


## What Now?

---

```bash
kubectl delete ns jenkins

kubectl delete sc fast
```
