# Docker Services


## Docker Services

* A group of containers
* Fault tolerant
* Scalable


## Deploying Services


```bash
docker service create --name=visualizer \
  --publish=9090:8080/tcp --constraint=node.role==manager \
  --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  dockersamples/visualizer

docker service ls

docker service ps visualizer

open "http://$(docker-machine ip swarm-1):9090"
```


## Ingress Network

* Forwards requests from any node to a service that published the same port


## Ingress Network

```bash
open "http://$(docker-machine ip swarm-2):9090"

open "http://$(docker-machine ip swarm-4):9090"
```

```bash
docker-machine rm -f swarm-1 swarm-2 swarm-3 swarm-4
```