ssh -i workshop.pem docker@$CLUSTER_IP

curl -o go-demo-2.yml https://raw.githubusercontent.com/vfarcic/go-demo-2/master/stack.yml

export DOCKER_HUB_USER=[...]

docker stack deploy -c go-demo-2.yml go-demo-2
