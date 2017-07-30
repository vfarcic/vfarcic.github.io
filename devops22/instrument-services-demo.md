## Hands-On Time

---

# Instrumenting Services


# Counters

---

```bash
open "https://github.com/vfarcic/docker-flow-swarm-listener"

docker service create --name util --mode global --network proxy alpine sleep 1000000

ID=$(docker container ls -q -f "label=com.docker.swarm.service.name=util")

docker container exec -it $ID sh

apk add --update curl

curl "http://swarm-listener:8080/metrics"

exit

docker service update --mount-rm /var/run/docker.sock proxy_swarm-listener

docker service logs proxy_swarm-listener

docker container exec -it $ID sh

curl "http://swarm-listener:8080/metrics"

exit

docker service rm proxy_proxy

docker stack deploy -c stacks/go-demo-scale.yml go-demo

docker service logs proxy_swarm-listener

docker container exec -it $ID sh

curl "http://swarm-listener:8080/metrics"

exit

docker stack deploy -c stacks/docker-flow-proxy-mem.yml proxy
```


# Gauges

---

```bash
docker container exec -it $ID sh

curl "http://swarm-listener:8080/metrics"

exit

docker service rm go-demo_main

docker container exec -it $ID sh

curl "http://swarm-listener:8080/metrics"

exit

docker stack deploy -c stacks/go-demo-scale.yml go-demo
```


# Histograms And Summaries

---

```bash
for i in {1..100}; do
    curl "http://$(docker-machine ip swarm-1)/demo/hello"
done

docker container exec -it $ID sh

curl "http://go-demo_main:8080/metrics"

exit

for i in {1..100}; do
    curl "http://$(docker-machine ip swarm-1)/demo/random-error"
done

docker container exec -it $ID sh

curl "http://go-demo_main:8080/metrics"

exit

for i in {1..30}; do
    DELAY=$[ $RANDOM % 6000 ]
    curl "http://$(docker-machine ip swarm-1)/demo/hello?delay=$DELAY"
done

docker container exec -it $ID sh

curl "http://go-demo_main:8080/metrics"

exit
```
