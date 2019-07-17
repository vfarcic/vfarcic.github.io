## Hands-On Time

---

# Creating A Production-Ready Kubernetes Cluster


## Prerequisites

* [Git](https://git-scm.com/downloads)
* [AWS account](https://aws.amazon.com)
* [AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
* [jq](https://stedolan.github.io/jq/)
* [kops](https://github.com/kubernetes/kops#installing)
* GitBash (if Windows)


## Getting The Code

---

```bash
git clone https://github.com/vfarcic/k8s-specs.git

cd k8s-specs
```


## Exporting AWS keys

---

```bash
# Generate AWS credentials through 
# https://console.aws.amazon.com/iam/home#/security_credential
# if you do NOT have them already

# Replace [...] with the AWS Access Key ID
export AWS_ACCESS_KEY_ID=[...]

# Replace [...] with the AWS Secret Access Key
export AWS_SECRET_ACCESS_KEY=[...]

export AWS_DEFAULT_REGION=us-east-2
```


## Choosing Availability Zones

---

```bash
# If Windows, use `tr '\r\n' ', '` instead of `tr '\n' ','`
export ZONES=$(aws ec2 describe-availability-zones \
    --region $AWS_DEFAULT_REGION | jq -r \
    '.AvailabilityZones[].ZoneName' | tr '\n' ',' | tr -d ' ')

ZONES=${ZONES%?}

echo $ZONES
```


## Generating SSH Keys

---

```bash
mkdir -p cluster/keys

aws ec2 create-key-pair --key-name devops24 \
    | jq -r '.KeyMaterial' >cluster/keys/devops24.pem

chmod 400 cluster/keys/devops24.pem

ssh-keygen -y -f cluster/keys/devops24.pem \
    >cluster/keys/devops24.pub
```


## Creating Cluster State Storage

---

```bash
export NAME=devops24.k8s.local

export BUCKET_NAME=devops24-$(date +%s)

aws s3api create-bucket --bucket $BUCKET_NAME \
    --create-bucket-configuration \
    LocationConstraint=$AWS_DEFAULT_REGION

export KOPS_STATE_STORE=s3://$BUCKET_NAME
```


## Creating A Cluster

---

```bash
kops create cluster --name $NAME --master-count 3 --node-count 3 \
    --master-size t2.small --node-size t2.small --zones $ZONES \
    --master-zones $ZONES --networking kubenet --yes \
    --ssh-public-key cluster/keys/devops24.pub

# Repeat until `Your cluster devops24.k8s.local is ready` is output
kops validate cluster
    
kubectl create -f \
    https://raw.githubusercontent.com/kubernetes/kops/master/addons/ingress-nginx/v1.6.0.yaml
```
