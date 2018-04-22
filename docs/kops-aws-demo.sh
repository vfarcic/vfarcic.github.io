git clone https://github.com/vfarcic/k8s-specs.git

cd k8s-specs

git pull

open "https://console.aws.amazon.com/iam/home#/security_credential"

export AWS_ACCESS_KEY_ID=[...]

export AWS_SECRET_ACCESS_KEY=[...]

export AWS_DEFAULT_REGION=us-east-2

aws iam create-group --group-name kops

aws iam attach-group-policy --group-name kops \
    --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess

aws iam attach-group-policy --group-name kops \
    --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess

aws iam attach-group-policy --group-name kops \
    --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess

aws iam attach-group-policy --group-name kops \
    --policy-arn arn:aws:iam::aws:policy/IAMFullAccess

aws iam create-user --user-name kops

aws iam add-user-to-group --user-name kops --group-name kops

aws iam create-access-key --user-name kops >kops-creds

cat kops-creds

export AWS_ACCESS_KEY_ID=$(cat kops-creds | \
    jq -r '.AccessKey.AccessKeyId')

export AWS_SECRET_ACCESS_KEY=$(cat kops-creds | \
    jq -r '.AccessKey.SecretAccessKey')

aws ec2 describe-availability-zones --region $AWS_DEFAULT_REGION

# If Windows, use `'\r'` instead `'\n'`
export ZONES=$(aws ec2 describe-availability-zones \
    --region $AWS_DEFAULT_REGION | jq -r \
    '.AvailabilityZones[].ZoneName' | tr '\n' ',' | tr -d ' ')

ZONES=${ZONES%?}

echo $ZONES

mkdir -p cluster

cd cluster

aws ec2 create-key-pair --key-name devops23 \
    | jq -r '.KeyMaterial' >devops23.pem

chmod 400 devops23.pem

ssh-keygen -y -f devops23.pem >devops23.pub

export NAME=devops23.k8s.local

export BUCKET_NAME=devops23-$(date +%s)

aws s3api create-bucket --bucket $BUCKET_NAME \
    --create-bucket-configuration \
    LocationConstraint=$AWS_DEFAULT_REGION

export KOPS_STATE_STORE=s3://$BUCKET_NAME

mkdir config

# Windows only
alias kops="docker run -it --rm \
    -v $PWD/devops23.pub:/devops23.pub \
    -v $PWD/config:/config \
    -e KUBECONFIG=/config/kubecfg.yaml \
    -e NAME=$NAME -e ZONES=$ZONES \
    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    -e KOPS_STATE_STORE=$KOPS_STATE_STORE \
    vfarcic/kops"

kops create cluster --name $NAME --master-count 3 --node-count 3 \
    --node-size t2.small --master-size t2.medium --zones $ZONES \
    --master-zones $ZONES --ssh-public-key devops23.pub \
    --networking kubenet --kubernetes-version v1.8.4 --yes

# Windows only
kops export kubecfg --name ${NAME}

# Windows only
export KUBECONFIG=$PWD/config/kubecfg.yaml

kops get cluster

kubectl cluster-info

kops validate cluster
