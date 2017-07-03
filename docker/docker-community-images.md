# Running Docker Containers Based On Community Images


# Docker Hub


## Docker Hub

* Navigate through Docker Hub
* Search for `mongo` image
* Walk through documentation
* Navigate to tags
* Walk through available tags


# Getting Help


## Getting Help

```bash
docker help

docker container --help

docker container run --help
```


# Operating Containers

Going through basic container operations like running, listing, stopping, removing, and inspecting


## Operating Containers

```bash
docker container run --rm mongo

# Press ctrl+C

docker container ls -a

docker container run -d --name mongo mongo

docker container ls

docker container logs mongo

docker container stop mongo

docker container ls -a
```


## Operating Containers

```bash
docker container rm mongo

docker container ls -a

docker container run -d --name mongo -p 8081:27017 mongo

docker container rm -f mongo

docker container run -d --name mongo -p 27017 mongo

docker container ls
```


## Operating Containers

```bash
docker container rm -f mongo

mkdir -p /tmp/mongo

docker container run -d --name mongo -p 27017 \
    -v /Users/vfarcic/mongo:/data/db mongo

ls -l $PWD/mongo

docker container inspect mongo

docker container rm -f mongo
```


# Using Docker Compose

Defining Docker services in YAML format and executing Docker commands through Docker Compose.


## Using Docker Compose

```bash
docker-compose up --help

git clone https://github.com/vfarcic/go-demo.git

cd go-demo

cat docker-compose.yml

docker-compose up -d

docker-compose ps
```


## Using Docker Compose

```bash
docker container inspect godemo_app_1 | jq '.'

PORT=$(docker container inspect godemo_app_1 \
    | jq -r '.[0].NetworkSettings.Ports."8080/tcp"[0].HostPort')

curl localhost:$PORT/demo/hello
```


## Using Docker Compose

```bash
docker-compose ps

docker-compose down

docker-compose ps
```


## Using Docker Compose

```bash
docker-compose --help
```

* Compose file reference ([https://docs.docker.com/compose/compose-file/](https://docs.docker.com/compose/compose-file/))
