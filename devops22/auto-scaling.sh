# Cluster Setup

for i in 1 2 3; do
  docker-machine create -d virtualbox swarm-$i
done

eval $(docker-machine env swarm-1)

docker swarm init --advertise-addr $(docker-machine ip swarm-1)

TOKEN=$(docker swarm join-token -q manager)

for i in 2 3; do
  eval $(docker-machine env swarm-$i)

  docker swarm join --advertise-addr $(docker-machine ip swarm-$i) \
        --token $TOKEN $(docker-machine ip swarm-1):2377
done

docker node ls

curl -L -o visualizer.yml https://goo.gl/xT5u9P

cat visualizer.yml

docker stack deploy -c visualizer.yml visualizer

open "http://$(docker-machine ip swarm-1):8080"

# Docker Flow Proxy Deployment

curl -L -o proxy.yml https://goo.gl/NRJa95

cat proxy.yml

docker network create -d overlay proxy

docker stack deploy -c proxy.yml proxy

docker stack ps proxy