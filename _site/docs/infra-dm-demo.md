## Hands-On Time

---

# Swarm Cluster


## Prerequisites

---

* [Git](https://git-scm.com/)
* [Docker](https://docs.docker.com/engine/installation/)
* [Docker Machine](https://docs.docker.com/machine/install-machine/)
* GitBash (if Windows)


## A Swarm Cluster

---

```bash
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
```


## Verifying The Cluster

---

```bash
docker node ls
```
