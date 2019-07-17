## Hands-On Time

---

# Instrumenting Services


## Counters

---

```bash
exit

open "https://github.com/vfarcic/docker-flow-swarm-listener/blob/master/metrics/prometheus.go"

open "https://github.com/vfarcic/docker-flow-swarm-listener/blob/master/main.go"

ssh -i workshop.pem docker@$CLUSTER_IP

docker service create --name util --mode global --network proxy \
    alpine sleep 1000000

ID=$(docker container ls -q \
    -f "label=com.docker.swarm.service.name=util")

docker container exec -it $ID apk add --update curl
```


# Counters

---

```bash
docker container exec -it $ID \
    curl "http://proxy_swarm-listener:8080/metrics"

docker service update --mount-rm /var/run/docker.sock \
    proxy_swarm-listener

docker service logs proxy_swarm-listener

docker container exec -it $ID \
    curl "http://swarm-listener:8080/metrics"

docker stack deploy -c proxy.yml proxy
```


## Gauges

---

```bash
exit

open "https://github.com/vfarcic/docker-flow-swarm-listener/blob/master/metrics/prometheus.go"

open "https://github.com/vfarcic/docker-flow-swarm-listener/blob/master/main.go"

ssh -i workshop.pem docker@$CLUSTER_IP

ID=$(docker container ls -q \
    -f "label=com.docker.swarm.service.name=util")
```


## Gauges

---

```bash
exit

open "https://github.com/vfarcic/docker-flow-swarm-listener/blob/master/metrics/prometheus.go"

open "https://github.com/vfarcic/docker-flow-swarm-listener/blob/master/main.go"

ssh -i workshop.pem docker@$CLUSTER_IP

ID=$(docker container ls -q \
    -f "label=com.docker.swarm.service.name=util")

docker container exec -it $ID \
    curl "http://swarm-listener:8080/metrics"

docker service rm go-demo_main

docker container exec -it $ID \
    curl "http://swarm-listener:8080/metrics"

docker stack deploy -c go-demo.yml go-demo
```


## Histograms And Summaries

---

```bash
exit

open "https://github.com/vfarcic/go-demo/blob/master/main.go"

for i in {1..100}; do
    curl "http://$CLUSTER_DNS/demo/hello"
done

ssh -i workshop.pem docker@$CLUSTER_IP

ID=$(docker container ls -q \
    -f "label=com.docker.swarm.service.name=util")

docker container exec -it $ID \
    curl "http://go-demo_main:8080/metrics"
```


## Histograms And Summaries

---

```bash
exit

for i in {1..100}; do
    curl "http://$CLUSTER_DNS/demo/random-error"
done

ssh -i workshop.pem docker@$CLUSTER_IP

ID=$(docker container ls -q \
    -f "label=com.docker.swarm.service.name=util")

docker container exec -it $ID \
    curl "http://go-demo_main:8080/metrics"

exit
```


## Histograms And Summaries

---

```bash
for i in {1..30}; do
    DELAY=$[ $RANDOM % 6000 ]
    curl "http://$CLUSTER_DNS/demo/hello?delay=$DELAY"
done

ssh -i workshop.pem docker@$CLUSTER_IP

ID=$(docker container ls -q \
    -f "label=com.docker.swarm.service.name=util")

docker container exec -it $ID \
    curl "http://go-demo_main:8080/metrics"
```
