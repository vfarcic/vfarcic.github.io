# Managing Docker Images


# Building Images


## Building Images

```bash
git clone https://github.com/vfarcic/go-demo.git

cd go-demo

cat Dockerfile

docker image build -t go-demo .
```


## Building Images

```bash
cat Dockerfile.big

docker image build -f Dockerfile.big -t go-demo .

docker image ls
```


## Building Images

```bash
cat Dockerfile.multistage

docker image build -f Dockerfile.multistage -t go-demo .

docker image ls
```


## Building Images

* Dockerfile reference ([https://docs.docker.com/engine/reference/builder/](https://docs.docker.com/engine/reference/builder/))


# Storing Images


## Storing Images

```bash
docker image tag go-demo vfarcic/go-demo

docker image push vfarcic/go-demo
```


## Storing Images

```bash
docker container run -d --name registry -p 5000:5000 registry

docker image tag go-demo localhost:5000/registry

docker image push localhost:5000/registry

docker image rm localhost:5000/registry

docker image pull localhost:5000/registry

docker container rm -f registry
```

