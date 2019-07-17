## Hands-On Time

---

# CI with Docker


## Building Images

---

```bash
id docker

docker container run --rm -it -v $PWD:/repos --user 1001 \
    vfarcic/git git clone https://github.com/vfarcic/go-demo-2.git

cd go-demo-2

cat old/Dockerfile

docker image build -f old/Dockerfile -t go-demo-2 .
```


## Building Images

---

```bash
docker container run -it --rm \
  -v $PWD:/tmp -w /tmp golang:1.7 \
  sh -c "go get -d -v -t && \
  go test --cover -v ./... --run UnitTest && \
  go build -v -o go-demo"

ls -lt

docker image build -f old/Dockerfile -t go-demo-2 .

docker image ls
```


## Building Images

---

```bash
cat old/Dockerfile.big

docker image build -f old/Dockerfile.big -t go-demo-2 .

docker image ls
```


## Building Images

---

```bash
cat Dockerfile

sudo rm go-demo

docker image build -t go-demo-2 .

docker image ls

docker system prune -f

docker image ls

cd ..
```


## Pushing Images

---

```bash
source creds

docker image tag go-demo-2 $DOCKER_HUB_USER/go-demo-2:beta

docker login -u $DOCKER_HUB_USER

docker image push $DOCKER_HUB_USER/go-demo-2:beta

exit

export DOCKER_HUB_USER=[...]

open "https://hub.docker.com/r/$DOCKER_HUB_USER/go-demo-2/tags"

ssh -i workshop.pem docker@$CLUSTER_IP
```
