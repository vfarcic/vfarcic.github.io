# Docker Services


## Docker Services

---

* A group of containers
* Fault tolerant
* Scalable
* Service discovery & networking
* Resource based allocation
* And much more


## Deploying Services

---

```bash
eval $(docker-machine env swarm-1)

docker service create --name=visualizer \
  --publish=9090:8080/tcp --constraint=node.role==manager \
  --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  dockersamples/visualizer

docker service ls

docker service ps visualizer

open "http://$(docker-machine ip swarm-1):9090"
```


## Ingress Network

---

* Forwards requests from any node to a service that published the same port

```bash
open "http://$(docker-machine ip swarm-2):9090"

open "http://$(docker-machine ip swarm-4):9090"
```


## Overlay Network

---

```bash
docker network create -d overlay go-demo

docker network ls

docker service create --name db --network go-demo mongo

docker service ps db

docker service create --name go-demo --network go-demo -e DB=db \
  --replicas 3 vfarcic/go-demo

docker service ps go-demo

docker service rm db go-demo

docker network rm go-demo
```


## Deploying Stacks

---

```bash
curl -o go-demo.yml \
  https://raw.githubusercontent.com/vfarcic/go-demo/master/docker-compose-stack.yml

cat go-demo.yml

docker stack deploy -c go-demo.yml go-demo

docker network create -d overlay proxy

docker stack deploy -c go-demo.yml go-demo

docker stack ps go-demo

open "http://$(docker-machine ip swarm-1):9090"
```


## Deploying Global Services

---

```bash
docker service create --name util --mode global --network proxy \
  alpine sleep 1000000

docker service ps util

docker container ls

docker container ls -f label="com.docker.swarm.service.name=util"

docker container ls -q -f label="com.docker.swarm.service.name=util"

ID=$(docker container ls -q \
  -f label="com.docker.swarm.service.name=util")

open "http://$(docker-machine ip swarm-1):9090"
```


## Service Discovery

---

```bash
docker container exec -it $ID sh

apk add --update drill

drill go-demo_main

drill tasks.go-demo_main

exit
```


## Rolling Updates

---

```bash
docker service update --image vfarcic/go-demo:1.6 \
  go-demo_main

watch "docker service ps -f desired-state=running go-demo_main"

cat go-demo.yml

docker service ps -f desired-state=running go-demo_main

docker service update --replicas 15 go-demo_main

docker service ps -f desired-state=running go-demo_main

docker service scale go-demo_main=12

docker service ps -f desired-state=running go-demo_main
```


## Failover

---

```bash
ID=$(docker container ls -q \
  -f label="com.docker.swarm.service.name=go-demo_main" | tail -n 1)

docker container rm -f $ID

docker stack ps -f desired-state=running go-demo

docker-machine rm -f swarm-4

docker stack ps -f desired-state=running go-demo

open "http://$(docker-machine ip swarm-1):9090"
```


## Integrating Services With A Proxy

---

```bash
docker service ls

curl -o proxy.yml \
  https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/proxy/docker-flow-proxy.yml

cat proxy.yml

docker stack deploy -c proxy.yml proxy

docker stack ps proxy

curl "http://$(docker-machine ip swarm-1)/demo/hello"

cat go-demo.yml
```


## Destroying The Cluster

---

```bash
docker-machine rm -f swarm-1 swarm-2 swarm-3
```
