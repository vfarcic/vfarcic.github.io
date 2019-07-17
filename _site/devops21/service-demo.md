## Hands-On Time

---

# Running Services


## Running Replicated Services

---

```bash
curl -o go-demo-2.yml \
  https://raw.githubusercontent.com/vfarcic/go-demo-2/master/stack.yml

cat go-demo-2.yml

docker stack deploy -c go-demo-2.yml go-demo-2

docker stack ps go-demo-2

exit

open "http://$CLUSTER_DNS:8083"

curl "http://$CLUSTER_DNS/demo/hello"

ssh -i workshop.pem docker@$CLUSTER_IP
```


## Running Global Services

---

```bash
docker service create --name util --network go-demo-2_default \
  --network proxy --mode global alpine sleep 1000000000

docker service ps util

exit

open "http://$CLUSTER_DNS:8083"

ssh -i workshop.pem docker@$CLUSTER_IP
```


## Networking

---

```bash
ID=$(docker ps -q --filter label=com.docker.swarm.service.name=util)

docker exec -it $ID apk add --update drill

docker exec -it $ID drill go-demo-2_db

docker exec -it $ID drill go-demo-2_main

docker exec -it $ID drill tasks.go-demo-2_main
```


## Scaling

---

```bash
docker service scale go-demo-2_main=10

docker stack ps -f desired-state=running go-demo-2

exit

open "http://$CLUSTER_DNS:8083"

ssh -i workshop.pem docker@$CLUSTER_IP
```


## Building Images

---

```bash
docker container run --rm -it -v $PWD:/repos vfarcic/git \
    git clone https://github.com/vfarcic/go-demo-2.git

cd go-demo-2

ls -l

cat Dockerfile

docker image build -t vfarcic/go-demo-2 .

cd ..
```


## Pushing Images

---

```bash
docker login

docker image push vfarcic/go-demo-2:latest

docker image tag vfarcic/go-demo-2 vfarcic/go-demo-2:2.0

docker image push vfarcic/go-demo-2:2.0
```


## Rolling Updates

---

```bash
docker service update --image vfarcic/go-demo-2:2.0 go-demo-2_main

docker stack ps -f desired-state=running go-demo-2
```