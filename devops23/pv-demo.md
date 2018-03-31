## Hands-On Time

---

# Persisting State


## Gist

---

[15-pv.sh](https://gist.github.com/41c86eb385dfc5c881d910c5e98596f2) (http://bit.ly/2IiX8ZM)


## Creating A Kubernetes Cluster

---

```bash
cd k8s-specs

git pull

cd cluster

cat kops

source kops

export BUCKET_NAME=devops23-$(date +%s)

aws s3api create-bucket --bucket $BUCKET_NAME \
    --create-bucket-configuration \
    LocationConstraint=$AWS_DEFAULT_REGION
```


## Creating A Kubernetes Cluster

---

```bash
export KOPS_STATE_STORE=s3://$BUCKET_NAME

# Windows only
alias kops="docker run -it --rm -v $PWD/devops23.pub:/devops23.pub \
    -v $PWD/config:/config -e KUBECONFIG=/config/kubecfg.yaml \
    -e NAME=$NAME -e ZONES=$ZONES \
    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    -e KOPS_STATE_STORE=$KOPS_STATE_STORE vfarcic/kops"

kops create cluster --name $NAME --master-count 3 --node-count 2 \
    --master-size t2.small --node-size t2.medium --zones $ZONES \
    --master-zones $ZONES --ssh-public-key devops23.pub \
    --networking kubenet --authorization RBAC --yes

kops validate cluster
```


## Creating A Kubernetes Cluster

---

```bash
# Windows only
kops export kubecfg --name ${NAME}

# Windows only
export KUBECONFIG=$PWD/config/kubecfg.yaml

kubectl create \
    -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/ingress-nginx/v1.6.0.yaml

CLUSTER_DNS=$(aws elb describe-load-balancers | jq -r \
    ".LoadBalancerDescriptions[] | select(.DNSName \
    | contains (\"api-devops23\") | not).DNSName")

echo $CLUSTER_DNS

cd ..
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

open "http://$CLUSTER_DNS/jenkins"

kubectl -n jenkins get pods --selector=app=jenkins -o json
```


## Without Persisting State

---

```bash
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

POD_NAME=$(kubectl -n jenkins get pod --selector=app=jenkins \
    -o jsonpath="{.items[*].metadata.name}")

kubectl -n jenkins exec -it $POD_NAME pkill java

open "http://$CLUSTER_DNS/jenkins"

kubectl -n jenkins delete deploy jenkins

kubectl -n jenkins get pvc

kubectl get pv

kubectl -n jenkins delete pvc jenkins
```


## Attaching Claimed Volumes

---

```bash
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

```bash
kubectl delete ns jenkins

kops delete cluster --name $NAME --yes

aws s3api delete-bucket --bucket $BUCKET_NAME
```

* [PersistentVolume v1 core](https://v1-8.docs.kubernetes.io/docs/api-reference/v1.8/#persistentvolume-v1-core)
* [PersistentVolumeClaim v1 core](https://v1-8.docs.kubernetes.io/docs/api-reference/v1.8/#persistentvolumeclaim-v1-core)
* [StorageClass v1 storage](https://v1-8.docs.kubernetes.io/docs/api-reference/v1.8/#storageclass-v1-storage)
