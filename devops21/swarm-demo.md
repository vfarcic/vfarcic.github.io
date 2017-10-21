## Hands-On Time

---

# Managing Swarm Services


## Creating Services

---

```bash
source creds

docker network create -d overlay go-demo-2

docker service create --name go-demo-2-db --network go-demo-2 mongo

docker service ps go-demo-2-db

docker service create --name go-demo-2 --env DB=go-demo-2-db \
    --network go-demo-2 -p 1234:8080 $DOCKER_HUB_USER/go-demo-2:beta

docker service ps go-demo-2

exit

curl "http://$CLUSTER_DNS:1234/demo/hello"
```


## Removing Services

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP

docker service rm go-demo-2

docker service rm go-demo-2-db

docker system prune -f
```


## Deploying Stacks

---

```bash
cd go-demo-2

cat stack.yml

docker stack deploy -c stack.yml go-demo-2

docker stack services go-demo-2

docker stack ps go-demo-2

docker service inspect go-demo-2_main --pretty

docker service inspect go-demo-2_main
```


## Scaling

---

```bash
docker service scale go-demo-2_main=5

docker stack ps go-demo-2
```


## Deploying Global Services

---

```bash
docker service create --name util \
  --network go-demo-2_default --network proxy \
  --mode global alpine sleep 1000000000

docker service ps util
```


## Exploring Networking

---

```bash
docker network ls

ID=$(docker ps -q \
  --filter label=com.docker.swarm.service.name=util)

docker exec -it $ID apk add --update drill

docker exec -it $ID drill go-demo-2_db

docker exec -it $ID drill go-demo-2_main

docker exec -it $ID drill tasks.go-demo-2_main
```


## Failover

---

```bash
docker container rm -f $(docker container ps | grep go-demo-2_main \
  | tail -1 | awk '{print $1}')

docker stack ps go-demo-2

cd ..
```


## Reverse Proxy

---

```bash
cat proxy.yml

cat go-demo-2/stack.yml

docker stack ps proxy

exit

curl "http://$CLUSTER_DNS/demo/hello"

ssh -i workshop.pem docker@$CLUSTER_IP
```

## [proxy.dockerflow.com](http://proxy.dockerflow.com)


## Rolling Updates

---

```bash
source creds

cd go-demo-2

cat Dockerfile

cat stack.yml

docker image tag go-demo-2 $DOCKER_HUB_USER/go-demo-2:2.0

docker image push $DOCKER_HUB_USER/go-demo-2:2.0

TAG=2.0 docker stack deploy -c stack.yml go-demo-2

docker stack ps -f desired-state=running go-demo-2
```


## Rolling Updates

---

```bash
docker image tag go-demo-2 $DOCKER_HUB_USER/go-demo-2:3.0

docker image push $DOCKER_HUB_USER/go-demo-2:3.0

docker service update --image $DOCKER_HUB_USER/go-demo-2:3.0 \
    go-demo-2_main

docker stack ps -f desired-state=running go-demo-2
```


## Testing Rolling Updates

---

```bash
docker image tag go-demo-2 $DOCKER_HUB_USER/go-demo-2:4.0

docker image push $DOCKER_HUB_USER/go-demo-2:4.0

docker service update --image $DOCKER_HUB_USER/go-demo-2:4.0 \
  go-demo-2_main

watch "curl -i 'http://$CLUSTER_DNS/demo/hello' \
    && docker stack ps -f desired-state=running go-demo-2"
```


## Rolling Back

---

```bash
docker stack ps -f desired-state=running go-demo-2

docker service update --rollback go-demo-2_main

docker stack ps -f desired-state=running go-demo-2

cd ..
```