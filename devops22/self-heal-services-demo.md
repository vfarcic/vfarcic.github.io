## Hands-On Time

---

# Self-Healing Services With Docker Swarm


# Service Failure

---

```bash
NODE=$(docker service ps -f desired-state=Running \
    go-demo_main | tail -n 1 | awk '{print $4}')

eval $(docker-machine env $NODE)

CONTAINER_ID=$(docker container ls -q \
    -f "label=com.docker.swarm.service.name=go-demo_main" \
    | tail -n 1)

docker container exec -it $CONTAINER_ID pkill go-demo

docker stack ps -f desired-state=Running go-demo

docker stack ps go-demo
```


# Node Failure

---

```bash
FAILED_NODE=$(docker service ps -f desired-state=Running \
    go-demo_main | tail -n 1 | awk '{print $4}')

docker-machine rm -f $FAILED_NODE

docker-machine ls

NODE=$(docker-machine ls -q | tail -n 1)

eval $(docker-machine env $NODE)

docker stack ps -f desired-state=Running go-demo

docker stack ps go-demo
```


# Restoring Nodes

---

```bash
docker-machine create -d virtualbox swarm-4

TOKEN=$(docker swarm join-token -q manager)

eval $(docker-machine env swarm-4)

docker swarm join --advertise-addr $(docker-machine ip swarm-4) \
    --token $TOKEN $(docker-machine ip $NODE):2377

docker node ls

docker node demote $FAILED_NODE

docker node rm $FAILED_NODE

docker node ls
```