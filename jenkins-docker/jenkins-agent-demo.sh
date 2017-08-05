echo $CLUSTER_DNS

ssh -i workshop.pem docker@$CLUSTER_IP

curl -o jenkins-agent.yml https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/jenkins/vfarcic-jenkins-agent.yml

docker node ls

export JENKINS_URL=[...] # e.g. http://[INTERNAL_IP]/jenkins

LABEL=prod docker stack deploy -c jenkins-agent.yml jenkins-agent-prod

export JENKINS_URL=[...] # e.g. http://[PUBLIC_DNS]/jenkins

LABEL=test docker stack deploy -c jenkins-agent.yml jenkins-agent-test

docker service logs -f jenkins-agent-prod_main

docker service logs -f jenkins-agent-test_main

exit

open "http://$CLUSTER_DNS/jenkins/computer"
