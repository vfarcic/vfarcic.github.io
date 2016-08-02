```bash
eval $(docker-machine env node-1)

docker service create --name test \
  -e DB=go-demo-db \
  --network go-demo \
  --network proxy \
  --constraint node.hostname=="node-1" \
  alpine sleep 1000000000

docker service ls # Wait until all services are running

docker exec -it $(docker ps -q --filter label=com.docker.swarm.service.name=test) apk add --update curl apache2-utils drill

docker exec -it $(docker ps -q --filter label=com.docker.swarm.service.name=test) drill go-demo-db
```