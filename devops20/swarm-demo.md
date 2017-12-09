## Hands-On Time

---

# Managing Swarm Services


## Deploying Stacks

---

```bash
curl -o go-demo-2.yml \
    https://raw.githubusercontent.com/vfarcic/go-demo-2/master/stack.yml

cat go-demo-2.yml

docker stack deploy -c go-demo-2.yml go-demo-2

docker stack ps -f desired-state=running go-demo-2

exit

curl "http://$CLUSTER_DNS/demo/hello"

open "http://$CLUSTER_DNS:8083"

ssh -i workshop.pem docker@$CLUSTER_IP
```


## Scaling

---

```bash
docker service scale go-demo-2_main=5

docker stack ps -f desired-state=running go-demo-2
```


## Failover

---

```bash
docker container rm -f $(docker container ps | grep go-demo-2_main \
  | tail -1 | awk '{print $1}')

docker stack ps -f desired-state=running go-demo-2
```


## Rolling Updates

---

```bash
TAG=2.0 docker stack deploy -c go-demo-2.yml go-demo-2

docker stack ps -f desired-state=running go-demo-2
```


## Rolling Back

---

```bash
docker service update --rollback go-demo-2_main

docker stack ps -f desired-state=running go-demo-2
```