## Hands-On Time

---

# Kubernetes Cluster
# In AWS
# With kops


## Gist

---

<!-- TODO: Recreate the gist -->
[14-aws.sh](https://gist.github.com/04af9efcd1c972e8199fc014b030b134) (https://goo.gl/E99QL1)
<!-- TODO: Prerequisites: Git -->
<!-- TODO: Prerequisites: AWS account -->
<!-- TODO: Prerequisites: AWS CLI (http://docs.aws.amazon.com/cli/latest/userguide/installing.html) -->
<!-- TODO: Prerequisites: jq (https://stedolan.github.io/jq/) -->
<!-- TODO: Prerequisites: kops (https://github.com/kubernetes/kops#installing) or Docker for Windows (https://www.docker.com/docker-windows) -->
<!-- TODO: Prerequisites: GitBash if Windows -->


## Getting The Code

---

```bash
git clone https://github.com/vfarcic/k8s-specs.git

cd k8s-specs

git pull
```


## Access Keys

---

```bash
export AWS_ACCESS_KEY_ID=[...]

export AWS_SECRET_ACCESS_KEY=[...]

aws --version

export AWS_DEFAULT_REGION=us-east-2
```


## Creating A Group

---

```bash
aws iam create-group --group-name kops

aws iam attach-group-policy --group-name kops \
    --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess

aws iam attach-group-policy --group-name kops \
    --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess

aws iam attach-group-policy --group-name kops \
    --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess

aws iam attach-group-policy --group-name kops \
    --policy-arn arn:aws:iam::aws:policy/IAMFullAccess
```


## Creating A User

---

```bash
aws iam create-user --user-name kops

aws iam add-user-to-group --user-name kops --group-name kops

aws iam create-access-key --user-name kops >creds

cat creds

export AWS_ACCESS_KEY_ID=$(cat creds | jq -r \
    '.AccessKey.AccessKeyId')

export AWS_SECRET_ACCESS_KEY=$(cat creds | jq -r \
    '.AccessKey.SecretAccessKey')
```


## Defining Availability Zones

---

```bash
aws ec2 describe-availability-zones --region $AWS_DEFAULT_REGION

export ZONES=$(aws ec2 describe-availability-zones \
    --region $AWS_DEFAULT_REGION \
    | jq -r '.AvailabilityZones[].ZoneName' | tr '\n' ',')

ZONES=${ZONES%?}

echo $ZONES
```


## Creating SSH Key Pair

---

```bash
mkdir cluster

cd cluster

aws ec2 create-key-pair --key-name devops23 \
    | jq -r '.KeyMaterial' >devops23.pem

chmod 400 devops23.pem

ssh-keygen -y -f devops23.pem >devops23.pub
```


## Creating A Cluster

---

```bash
export NAME=devops23.k8s.local

export KOPS_STATE_STORE=s3://devops23-store

aws s3api create-bucket --bucket devops23-store \
    --create-bucket-configuration \
    LocationConstraint=$AWS_DEFAULT_REGION

mkdir config
```


## Creating A Cluster (Win Only)

---

```bash
alias kops="docker run -it --rm \
    -v $PWD/devops23.pub:/devops23.pub \
    -v $PWD/config:/config \
    -e KUBECONFIG=/config/kubecfg.yaml \
    -e NAME=$NAME -e ZONES=$ZONES \
    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    -e KOPS_STATE_STORE=$KOPS_STATE_STORE \
    vfarcic/kops"
```


## Creating A Cluster

---

```bash
kops create cluster --name $NAME --master-count 3 --node-count 1 \
    --node-size t2.small --master-size t2.small --zones $ZONES \
    --master-zones $ZONES --ssh-public-key devops23.pub \
    --networking kubenet --yes
```


## Exploring The Cluster
## (Win Only)

---

```bash
kops export kubecfg --name ${NAME}

export KUBECONFIG=$PWD/config/kubecfg.yaml
```


## Exploring The Cluster

---

```bash
kops get cluster

kubectl cluster-info

kops validate cluster

kubectl get nodes

kubectl --namespace kube-system get all
```


## Updating The Cluster

---

```bash
kops edit ig --name $NAME nodes

# Change `maxSize` to `2`
# Change `minSize` to `2`

kops update cluster --name $NAME --yes

kops validate cluster

kubectl get nodes
```


## Upgrading The Cluster

---

```bash
kops upgrade cluster $NAME --yes

kops edit cluster $NAME

kops update cluster $NAME --yes

kops rolling-update cluster $NAME --yes
```


## Deploying kops Addons

---

```bash
kubectl create \
    -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/ingress-nginx/v1.6.0.yaml

kubectl --namespace kube-ingress get all

kubectl --namespace kube-ingress get svc ingress-nginx -o json

export HOSTNAME=$(kubectl --namespace kube-ingress \
    get svc ingress-nginx \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")
```


## Deploying Applications

---

```bash
cd ..

kubectl create -f aws/go-demo-2.yml --record --save-config

kubectl rollout status deployment go-demo-2-api

kubectl get ing -o wide

curl -i "http://$HOSTNAME/demo/hello"
```


## Exporting Cluster Config

---

```bash
export AWS_ACCESS_KEY_ID=[...]

export AWS_SECRET_ACCESS_KEY=[...]

export NAME=devops23.k8s.local

export KOPS_STATE_STORE=s3://devops23-store

cd cluster

export KUBECONFIG=$PWD/config/kubecfg.yaml

kops export kubecfg --name ${NAME}

cat $KUBECONFIG

export AWS_ACCESS_KEY_ID=[...]

export AWS_SECRET_ACCESS_KEY=[...]

kops delete cluster \
    --name $NAME \
    --yes

aws s3api delete-bucket \
    --bucket devops23-store

aws iam remove-user-from-group \
    --user-name kops \
    --group-name kops

aws iam delete-access-key \
    --access-key-id $(\
    cat creds | jq -r \
    '.AccessKey.AccessKeyId')

aws iam delete-user \
    --user-name kops

aws iam create-group \
    --group-name kops
```


## What Now?

TODO: Next section
