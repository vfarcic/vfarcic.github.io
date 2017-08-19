echo $CLUSTER_DNS

ssh -i workshop.pem docker@$CLUSTER_IP

curl -o jenkins-agent.yml https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/jenkins/vfarcic-jenkins-agent.yml

docker node ls

PRIVATE_IP=[...]

export JENKINS_URL="http://$PRIVATE_IP/jenkins"

LABEL=prod docker stack deploy -c jenkins-agent.yml jenkins-agent-prod

PUBLIC_IP=[...]

export JENKINS_URL="http://$PUBLIC_IP/jenkins"

LABEL=test EXECUTORS=3 docker stack deploy -c jenkins-agent.yml jenkins-agent-test

exit

open "http://$CLUSTER_DNS/jenkins/computer"
