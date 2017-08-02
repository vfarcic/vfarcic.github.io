## Hands-On Time

---

# Setting Up

# a Swarm Cluster

# and

# Running Services


# Build Image

---

```bash
cat packer-ubuntu-docker-rexray.json

packer build -machine-readable packer-ubuntu-docker-rexray.json \
  | tee packer-ubuntu-docker-rexray.log
```


# Initialize

---

```bash
export TF_VAR_swarm_ami_id=$(grep 'artifact,0,id' \
  packer-ubuntu-docker-rexray.log | cut -d: -f2)

cat swarm.tf

terraform plan -target aws_instance.swarm-manager \
  -var swarm_init=true -var swarm_managers=1

terraform apply -target aws_instance.swarm-manager \
  -var swarm_init=true -var swarm_managers=1 -var rexray=true

terraform refresh

ssh -i devops21.pem ubuntu@$(terraform output \
  swarm_manager_1_public_ip) docker node ls
```


# Add Nodes

---

```bash
export TF_VAR_swarm_manager_token=$(ssh -i devops21.pem \
  ubuntu@$(terraform output swarm_manager_1_public_ip) \
  docker swarm join-token -q manager)

export TF_VAR_swarm_manager_ip=$(terraform \
  output swarm_manager_1_private_ip)

cat swarm.tf

terraform plan -target aws_instance.swarm-manager -var rexray=true

terraform apply -target aws_instance.swarm-manager -var rexray=true

terraform refresh

ssh -i devops21.pem ubuntu@$(terraform \
  output swarm_manager_1_public_ip) docker node ls
```


# Service

---

```bash
terraform output swarm_manager_1_public_ip

ssh -i devops21.pem ubuntu@$(terraform \
  output swarm_manager_1_public_ip)

docker service create --name=visualizer \
  --publish=9090:8080/tcp --constraint=node.role==manager \
  --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  dockersamples/visualizer

exit

open "http://$(terraform output swarm_manager_1_public_ip):9090"
```


# Networking

---

```bash
ssh -i devops21.pem ubuntu@$(terraform \
  output swarm_manager_1_public_ip)

docker network create --driver overlay proxy

docker network ls
```


# Stack

---

```bash
curl -o go-demo-stack.yml \
    https://raw.githubusercontent.com/\
vfarcic/go-demo/master/docker-compose-stack.yml

cat go-demo-stack.yml

docker stack deploy -c go-demo-stack.yml go-demo

docker stack services go-demo

docker stack ps go-demo

docker service inspect go-demo_main --pretty

docker service inspect go-demo_main
```


# Scaling

---

```bash
docker service scale go-demo_main=5

docker stack ps go-demo
```


# Global Service

---

```bash
docker service create --name util \
  --network go-demo_default --network proxy \
  --mode global alpine sleep 1000000000

docker service ps util

ID=$(docker ps -q \
  --filter label=com.docker.swarm.service.name=util)

docker exec -it $ID apk add --update drill

docker exec -it $ID drill go-demo_db

docker exec -it $ID drill go-demo_main

docker exec -it $ID drill tasks.go-demo_main
```


# Failover

---

```bash
docker container rm -f $(docker container ps | grep go-demo_main \
  | tail -1 | awk '{print $1}')

docker stack ps go-demo
```


# Reverse Proxy

---

```bash
curl -o proxy-stack.yml \
    https://raw.githubusercontent.com/\
vfarcic/docker-flow-proxy/master/docker-compose-stack.yml

cat proxy-stack.yml

docker stack deploy -c proxy-stack.yml proxy

docker stack ps proxy

exit

curl "http://$(terraform output \
    swarm_manager_1_public_ip)/demo/hello"
```

[Docker Flow Proxy: http://proxy.dockerflow.com/](http://proxy.dockerflow.com/)


# Networking

---

![Proxy scaled](../img/swarm/proxy-scaled.png)


# Networking

---

![DNS](../img/swarm/proxy-scaled-dns.png)


# Networking

---

![Routing Mesh](../img/swarm/proxy-scaled-routing-mesh.png)


# Networking

---

![Routing mesh to proxy](../img/swarm/proxy-scaled-routing-proxy.png)


# Networking

---

![Proxy to proxy network](../img/swarm/proxy-scaled-proxy-sdn.png)


# Networking

---

![Proxy network to service](../img/swarm/proxy-scaled-request-to-service.png)


# Service Updates

---

```bash
ssh -i devops21.pem ubuntu@$(terraform \
  output swarm_manager_1_public_ip)

cat go-demo-stack.yml

TAG=:1.1 docker stack deploy -c go-demo-stack.yml go-demo

docker stack ps go-demo
```


# Network Volumes

---

```bash
curl -o registry.yml \
    https://raw.githubusercontent.com/vfarcic/\
docker-flow-stacks/master/docker/registry-rexray-external.yml

docker volume create -d rexray registry

docker volume ls

docker stack deploy -c registry.yml registry

docker stack ps registry

docker pull vfarcic/go-demo

docker tag vfarcic/go-demo localhost:5000/go-demo

docker push localhost:5000/go-demo
```


# Failover With Network Volumes

---

```bash
docker stack ps registry

IP=[...]  # Registry node IP

docker -H tcp://$IP:2375 rm -f \
  $(docker -H tcp://$IP:2375 ps -q \
  -f label=com.docker.swarm.service.name=registry_main)

docker stack ps registry

docker pull localhost:5000/go-demo

exit
```