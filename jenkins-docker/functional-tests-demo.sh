ssh -i workshop.pem docker@$CLUSTER_IP

curl -o go-demo-2.yml https://raw.githubusercontent.com/vfarcic/go-demo-2/master/stack.yml

docker stack deploy -c go-demo-2.yml go-demo-2

docker stack ps go-demo-2