## Hands-On Time

---

# CDP with Docker


## Building Images

---

```bash
source creds

cd go-demo-2

docker container run --rm -it -v $PWD:/repos --user 1001 \
    vfarcic/git git pull

docker image build -t $DOCKER_HUB_USER/go-demo-2:beta-1 .

docker image push $DOCKER_HUB_USER/go-demo-2:beta-1
```


## Running Functional Tests

---

```bash
cat stack-test.yml

TAG=beta-1 SERVICE_PATH=/demo-beta-1 docker stack deploy \
    -c stack-test.yml go-demo-2-beta-1

cat Dockerfile.test

cat run-functional.sh

docker image build -f Dockerfile.test \
    -t $DOCKER_HUB_USER/go-demo-2-test .

docker image push $DOCKER_HUB_USER/go-demo-2-test

docker container run --rm -e HOST_IP=$CLUSTER_DNS \
    -e SERVICE_PATH=/demo-beta-1 $DOCKER_HUB_USER/go-demo-2-test
```


## Running Functional Tests

---

```bash
cat docker-compose.yml
```


## Creating A Release

---

```bash
docker image tag $DOCKER_HUB_USER/go-demo-2:beta-1 \
    $DOCKER_HUB_USER/go-demo-2:10.0

docker image push $DOCKER_HUB_USER/go-demo-2:10.0

docker image tag $DOCKER_HUB_USER/go-demo-2:beta-1 \
    $DOCKER_HUB_USER/go-demo-2:latest

docker image push $DOCKER_HUB_USER/go-demo-2:latest
```


## Deploying

---

```bash
docker service update --image $DOCKER_HUB_USER/go-demo-2:10.0 \
    go-demo-2_main

docker container run --rm -e HOST_IP=$CLUSTER_DNS -e DURATION=2 \
    $DOCKER_HUB_USER/go-demo-2-test bash -c \
    "go get -d -v -t && go test ./... -v --run ProductionTest"

cat docker-compose.yml

# docker service update --rollback go-demo-2_main"
```


## Cleaning Up

---

```bash
docker stack rm go-demo-2-beta-1

docker system prune -f

cd ..
```
