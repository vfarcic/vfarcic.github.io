# Cluster


# Cluster

* Not a group of servers
* A sum of resources of all the servers
* Do not deploy to a server
* Instruct a scheduler what the requirements are
* Scheduler decides where to deploy


# Docker Machine

* Lightweight VM
* Very simple
* Prepared for Docker
* Good for local simulation
* Bad for production usage


## Creating DM Servers

```bash
docker-machine create -d virtualbox swarm-1

docker-machine ls

docker-machine env swarm-1

eval $(docker-machine env swarm-1)

docker version

docker-machine create -d virtualbox swarm-2

docker-machine create -d virtualbox swarm-3

docker-machine ls
```


## Initializing A Swarm Cluster

```bash
docker swarm init --advertise-addr $(docker-machine ip swarm-1)

docker node ls
```


## Adding Managers

```bash
docker swarm join-token -q manager

TOKEN=$(docker swarm join-token -q manager)

eval $(docker-machine env swarm-2)

docker swarm join --advertise-addr $(docker-machine ip swarm-2) \
  --token $TOKEN $(docker-machine ip swarm-1):2377

eval $(docker-machine env swarm-3)

docker swarm join --advertise-addr $(docker-machine ip swarm-3) \
  --token $TOKEN $(docker-machine ip swarm-1):2377

docker node ls
```


## Adding Workers

```bash
docker-machine create -d virtualbox swarm-4

docker swarm join-token -q worker

TOKEN=$(docker swarm join-token -q worker)

eval $(docker-machine env swarm-4)

docker swarm join --token $TOKEN --advertise-addr $(docker-machine ip swarm-4) $(docker-machine ip swarm-1):2377

docker node ls

eval $(docker-machine env swarm-1)

docker node ls
```
