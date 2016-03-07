```bash
# VMs

docker-machine create \
    -d virtualbox \
    swarm-master

docker-machine create \
    -d virtualbox \
    swarm-node-1

docker-machine create \
    -d virtualbox \
    swarm-node-2

docker-machine ls

SWARM_MASTER_IP=$(docker-machine ip swarm-master)
SWARM_NODE_1_IP=$(docker-machine ip swarm-node-1)
SWARM_NODE_2_IP=$(docker-machine ip swarm-node-2)

# Consul

docker $(docker-machine config swarm-master) run -d \
    --name consul \
    -h swarm-master \
    -p 8300:8300 \
    -p 8301:8301 \
    -p 8301:8301/udp \
    -p 8302:8302 \
    -p 8302:8302/udp \
    -p 8400:8400 \
    -p 8500:8500 \
    -p 53:53/udp \
    progrium/consul -server -advertise $SWARM_MASTER_IP -bootstrap-expect 3

docker $(docker-machine config swarm-node-1) run -d \
    --name consul \
    -h swarm-node-1 \
    -p 8300:8300 \
    -p 8301:8301 \
    -p 8301:8301/udp \
    -p 8302:8302 \
    -p 8302:8302/udp \
    -p 8400:8400 \
    -p 8500:8500 \
    -p 53:53/udp \
    progrium/consul -server -join $SWARM_MASTER_IP

docker $(docker-machine config swarm-node-2) run -d \
    --name consul \
    -h swarm-node-2 \
    -p 8300:8300 \
    -p 8301:8301 \
    -p 8301:8301/udp \
    -p 8302:8302 \
    -p 8302:8302/udp \
    -p 8400:8400 \
    -p 8500:8500 \
    -p 53:53/udp \
    progrium/consul -server -join $SWARM_MASTER_IP

docker $(docker-machine config swarm-master) logs -f consul
```