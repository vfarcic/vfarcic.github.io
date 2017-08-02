# Managing Docker Images

* Build
* Store
* Pull
* Run

Note:
Throughout the previous exercises, we created a few containers. They were all based on public images pulled from Docker Hub. We will continue using those public images since they provide a solution for most third-part services we might need. However, third-party services are only a part of what should run in our cluster. We need to dockerize our own services as well. If, for a moment, we switch conversation to, let's say, Java, we'd need to build a JAR or WAR file, store it to, let's say Nexus, allow other teams to pull them from Nexus, and, finally, deploy them.
Docker is not different except that we are now dealing with images and contain everything a service needs. We need to build them, store them somewhere, pull them to any of the nodes of our cluster, and, finally, run them.


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
docker container run -it --rm -v $PWD:/tmp -w /tmp golang:1.7 \
  sh -c "go get -d -v -t && go build -v -o go-demo"

ls -l

docker image build -t go-demo .

docker image ls
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

docker login

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
