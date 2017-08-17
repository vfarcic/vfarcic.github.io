## Hands-On Time

---

# Instrumenting Services


## Counters

---

```bash
open "https://github.com/vfarcic/docker-flow-swarm-listener/blob/master/metrics/prometheus.go"

open "https://github.com/vfarcic/docker-flow-swarm-listener/blob/master/main.go"

docker service create --name util --mode global --network proxy \
    alpine sleep 1000000

ID=$(docker container ls -q \
    -f "label=com.docker.swarm.service.name=util")

docker container exec -it $ID apk add --update curl

docker container exec -it $ID \
    curl "http://proxy_swarm-listener:8080/metrics"
```


# Counters

---

```bash
docker service update --mount-rm /var/run/docker.sock \
    proxy_swarm-listener

docker service logs proxy_swarm-listener

docker container exec -it $ID \
    curl "http://swarm-listener:8080/metrics"

docker stack deploy -c stacks/docker-flow-proxy-mem.yml proxy

docker service rm proxy_proxy

docker stack deploy -c stacks/go-demo-scale.yml go-demo

docker service logs proxy_swarm-listener
```


## Counters

---

```bash
docker container exec -it $ID \
    curl "http://swarm-listener:8080/metrics"

docker stack deploy -c stacks/docker-flow-proxy-mem.yml proxy
```


## Gauges

---

```bash
open "https://github.com/vfarcic/docker-flow-swarm-listener/blob/master/metrics/prometheus.go"

open "https://github.com/vfarcic/docker-flow-swarm-listener/blob/master/main.go"

docker container exec -it $ID \
    curl "http://swarm-listener:8080/metrics"

docker service rm go-demo_main

docker container exec -it $ID \
    curl "http://swarm-listener:8080/metrics"

docker stack deploy -c stacks/go-demo-scale.yml go-demo
```


## Histograms And Summaries

---

```bash
open "https://github.com/vfarcic/go-demo/blob/master/main.go"

for i in {1..100}; do
    curl "http://$(docker-machine ip $NODE)/demo/hello"
done

docker container exec -it $ID \
    curl "http://go-demo_main:8080/metrics"

for i in {1..100}; do
    curl "http://$(docker-machine ip $NODE)/demo/random-error"
done

docker container exec -it $ID \
    curl "http://go-demo_main:8080/metrics"
```


## Histograms And Summaries

---

```bash
for i in {1..30}; do
    DELAY=$[ $RANDOM % 6000 ]
    curl "http://$(docker-machine ip $NODE)/demo/hello?delay=$DELAY"
done

docker container exec -it $ID \
    curl "http://go-demo_main:8080/metrics"
```
