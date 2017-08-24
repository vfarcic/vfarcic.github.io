export CLUSTER_DNS=[...]

export CLUSTER_IP=[...]

ssh -i workshop.pem docker@$CLUSTER_IP

curl -L -o proxy.yml https://goo.gl/2XcNEK

docker network create -d overlay proxy

docker stack deploy -c proxy.yml proxy

curl -L -o jenkins.yml https://goo.gl/PDVJDb

echo "admin" | docker secret create jenkins-user -

echo "admin" | docker secret create jenkins-pass -

TAG=workshop docker stack deploy -c jenkins.yml jenkins

docker service logs -f jenkins_jenkins-master

exit

open "http://$CLUSTER_DNS/jenkins"
