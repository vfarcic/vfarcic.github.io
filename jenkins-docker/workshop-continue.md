# Cluster Setup

```bash
export AWS_ACCESS_KEY_ID=[...]

export AWS_SECRET_ACCESS_KEY=[...]

export AWS_DEFAULT_REGION=us-east-2

aws cloudformation create-stack \
    --template-url https://editions-us-east-1.s3.amazonaws.com/aws/stable/Docker.tmpl \
    --capabilities CAPABILITY_IAM \
    --stack-name devops22 \
    --parameters \
    ParameterKey=ManagerSize,ParameterValue=3 \
    ParameterKey=ClusterSize,ParameterValue=0 \
    ParameterKey=KeyName,ParameterValue=workshop \
    ParameterKey=EnableSystemPrune,ParameterValue=yes \
    ParameterKey=EnableCloudWatchLogs,ParameterValue=no \
    ParameterKey=EnableCloudStorEfs,ParameterValue=yes \
    ParameterKey=ManagerInstanceType,ParameterValue=t2.small \
    ParameterKey=InstanceType,ParameterValue=t2.small

aws cloudformation describe-stacks --stack-name devops22 | \
  jq -r ".Stacks[0].StackStatus"

CLUSTER_DNS=$(aws cloudformation describe-stacks \
  --stack-name devops22 | jq -r ".Stacks[0].Outputs[] | \
  select(.OutputKey==\"DefaultDNSTarget\").OutputValue")

CLUSTER_IP=$(aws ec2 describe-instances | jq -r ".Reservations[] \
  .Instances[] | select(.SecurityGroups[].GroupName | \
  contains(\"devops22-ManagerVpcSG\")).PublicIpAddress" | tail -n 1)

echo $CLUSTER_DNS && echo $CLUSTER_IP

ssh -i workshop.pem docker@$CLUSTER_IP

echo "export CLUSTER_DNS=[...]
export CLUSTER_IP=[...]
export DOCKER_HUB_USER=[...]
">creds

docker node ls

curl -o visualizer.yml https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/web/docker-visualizer.yml

HTTP_PORT=8083 docker stack deploy -c visualizer.yml visualizer

curl -o proxy.yml \
  https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/proxy/docker-flow-proxy.yml

cat proxy.yml

docker network create -d overlay proxy

docker stack deploy -c proxy.yml proxy
```

# Jenkins Master


```bash
docker container run --rm -it -v $PWD:/repos vfarcic/git \
    git clone https://github.com/vfarcic/docker-flow-stacks
    
docker container run --rm -it -v $PWD:/repos vfarcic/git \
    git clone https://github.com/vfarcic/go-demo-2

cd docker-flow-stacks/jenkins

cat vfarcic-jenkins-df-proxy.yml

echo "admin" | docker secret create jenkins-user -

echo "admin" | docker secret create jenkins-pass -

source creds

TAG=workshop docker stack deploy \
    -c vfarcic-jenkins-df-proxy-aws.yml jenkins

docker node ls

PRIVATE_IP=[...]

export JENKINS_URL="http://$PRIVATE_IP/jenkins"

LABEL=prod EXECUTORS=2 docker stack deploy -c vfarcic-jenkins-agent.yml \
    jenkins-agent-prod

export JENKINS_URL="http://$CLUSTER_DNS/jenkins"

LABEL=test EXECUTORS=3 docker stack deploy -c vfarcic-jenkins-agent.yml \
    jenkins-agent-test

exit

open "http://$CLUSTER_DNS/jenkins/computer"
```
