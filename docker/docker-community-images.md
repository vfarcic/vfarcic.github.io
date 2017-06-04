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


# Running Containers


## Running Containers

```bash
docker container run --rm mongo

# Press ctrl+C

docker container run -d --rm --name mongo \
    mongo

docker container stop mongo

docker container ls -a

docker container rm mongo

docker container ls -a
```


## Running Containers

```bash
mkdir -p /tmp/mongo

docker container run -d --name mongo \
    -p 27017:27017 \
    -v /tmp/mongo:/data/db \
    mongo

docker container ls

ls -l /tmp/mongo

docker container inspect mongo

docker container rm -f mongo

docker container ls -a
```


# Using Docker Compose


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
