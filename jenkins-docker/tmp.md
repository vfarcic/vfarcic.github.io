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

curl -o proxy.yml \
  https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/proxy/docker-flow-proxy.yml

docker network create -d overlay proxy

docker stack deploy -c proxy.yml proxy

source creds

echo "admin" | docker secret create jenkins-user -

echo "admin" | docker secret create jenkins-pass -

curl -o jenkins.yaml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/jenkins/vfarcic-jenkins-df-proxy-aws.yml

TAG=workshop docker stack deploy \
    -c jenkins.yaml jenkins

curl -o jenkins-agent.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/jenkins/vfarcic-jenkins-agent.yml

docker node ls

PRIVATE_IP=[...]

export JENKINS_URL="http://$PRIVATE_IP/jenkins"

LABEL=prod EXECUTORS=2 docker stack deploy -c jenkins-agent.yml \
    jenkins-agent-prod

export JENKINS_URL="http://$CLUSTER_DNS/jenkins"

LABEL=test EXECUTORS=3 docker stack deploy -c jenkins-agent.yml \
    jenkins-agent-test

docker container run --rm -it -v $PWD:/repos vfarcic/git \
    git clone https://github.com/vfarcic/go-demo-2.git

docker image pull vfarcic/go-demo-2

docker image tag vfarcic/go-demo-2 go-demo-2

docker service logs jenkins_jenkins-master

# Confirm that it says that "Jenkins is fully up and running"

exit

open "http://$CLUSTER_DNS/jenkins/credentials/store/system/domain/_/"

# Login with *admin*/*admin*
# Click the *Add Credentials* link
# Type your Docker Hub username and password
# Type *docker* as the *ID*
# Click the *OK* button
```