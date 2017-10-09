## Hands-On Time

---

# Rolling Updates


## Deployment

---

```bash
curl https://raw.githubusercontent.com/vfarcic/go-demo-2/master/Dockerfile

curl -o go-demo-2.yml \
    https://raw.githubusercontent.com/vfarcic/go-demo-2/master/stack.yml

cat go-demo-2.yml

TAG=1.0 docker stack deploy -c go-demo-2.yml go-demo-2

watch "docker stack ps -f desired-state=running go-demo-2"

exit

curl -i "http://$CLUSTER_DNS/demo/hello"

ssh -i workshop.pem docker@$CLUSTER_IP
```


## Updating Service

---

```bash
docker service update --image vfarcic/go-demo-2:2.0 go-demo-2_main

watch "docker stack ps -f desired-state=running go-demo-2"
```


## Updating Stack

---

```bash
TAG=3.0 docker stack deploy -c go-demo-2.yml go-demo-2

watch "docker stack ps -f desired-state=running go-demo-2"
```


## Zero-Downtime

---

```bash
docker service update --image vfarcic/go-demo-2:4.0 go-demo-2_main

exit

watch "curl -i 'http://$CLUSTER_DNS/demo/hello'"
```


## Rolling Back

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP

docker stack ps -f desired-state=running go-demo-2

docker service update --rollback go-demo-2_main

docker stack ps -f desired-state=running go-demo-2
```
