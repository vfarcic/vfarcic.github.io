export CLUSTER_DNS=[...]

export CLUSTER_IP=[...]

ssh -i workshop.pem docker@$CLUSTER_IP

curl -o proxy.yml https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/proxy/docker-flow-proxy.yml

docker network create -d overlay proxy

docker stack deploy -c proxy.yml proxy

curl -o jenkins.yml https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/jenkins/vfarcic-jenkins-df-proxy-aws.yml

echo "admin" | docker secret create jenkins-user -

echo "admin" | docker secret create jenkins-pass -

TAG=workshop docker stack deploy -c jenkins.yml jenkins

docker service logs -f jenkins_jenkins-master

exit

open "http://$CLUSTER_DNS/jenkins"
