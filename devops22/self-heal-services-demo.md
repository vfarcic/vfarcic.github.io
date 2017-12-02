## Hands-On Time

---

# Self-Healing Services With Docker Swarm


<!-- .slide: data-background="img/swarm-services.png" data-background-size="contain" -->


# Service Failure

---

```bash
docker service scale go-demo_main=5

CONTAINER_ID=$(docker container ls -q \
    -f "label=com.docker.swarm.service.name=go-demo_main" \
    | tail -n 1)

docker container exec -it $CONTAINER_ID pkill go-demo

docker stack ps -f desired-state=Running go-demo

docker stack ps go-demo
```


<!-- .slide: data-background="img/swarm-services-failure.png" data-background-size="contain" -->
