if [[ "$(uname -s )" == "Linux" ]]; then
  export VIRTUALBOX_SHARE_FOLDER="$PWD:$PWD"
fi

for i in 1 2 3 4; do
    docker-machine create -d virtualbox swarm-$i
done

eval $(docker-machine env swarm-1)

docker swarm init --advertise-addr $(docker-machine ip swarm-1)

TOKEN=$(docker swarm join-token -q manager)

for i in 2 3; do
    eval $(docker-machine env swarm-$i)

    docker swarm join --token $TOKEN --advertise-addr $(docker-machine ip swarm-$i) $(docker-machine ip swarm-1):2377
done

TOKEN=$(docker swarm join-token -q worker)

eval $(docker-machine env swarm-4)

docker swarm join --token $TOKEN --advertise-addr $(docker-machine ip swarm-4) $(docker-machine ip swarm-1):2377

eval $(docker-machine env swarm-1)

docker node ls