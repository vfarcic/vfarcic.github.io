## Hands-On Time

---

# Docker Images


## Building Images

---

```bash
git clone https://github.com/vfarcic/go-demo-2.git

cd go-demo-2

cat Dockerfile

docker image build -t go-demo-2 .

docker image ls
```


## Pushing Images

---

```bash
DOCKER_HUB_USER=[...]

docker login -u $DOCKER_HUB_USER

docker image tag go-demo-2 $DOCKER_HUB_USER/go-demo-2:beta

docker image push $DOCKER_HUB_USER/go-demo-2:beta

open "https://hub.docker.com/r/$DOCKER_HUB_USER/go-demo-2/tags/"

cd ..
```
