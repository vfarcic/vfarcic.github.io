# Docker

---

### Docker Engine
### Docker Machine
### Docker Compose
### Docker Registry
### Docker Swarm


### Docker Swarm

# Prerequisites

---

* [Git](https://git-scm.com/)
* [AWS account](https://aws.amazon.com/)
* [AWS CLI](https://aws.amazon.com/cli/)
* [Packer](https://www.packer.io/)
* [Terraform](https://www.terraform.io/downloads.html)
* [jq](https://stedolan.github.io/jq/)
* GitBash (if Windows)


### Docker Swarm

# Image (AMI)

---

```bash
git clone https://github.com/vfarcic/cloud-provisioning.git

cd cloud-provisioning/terraform/aws-full

export AWS_ACCESS_KEY_ID=[...]

export AWS_SECRET_ACCESS_KEY=[...]

export AWS_DEFAULT_REGION=us-east-1

aws ec2 create-key-pair --key-name devops21 \
    | jq -r '.KeyMaterial' >devops21.pem

packer build -machine-readable packer-ubuntu-docker-rexray.json \
  | tee packer-ubuntu-docker-rexray.log
```


### Docker Swarm

# Initialize

---

```bash
export TF_VAR_aws_access_key=[...]

export TF_VAR_aws_secret_key=[...]

export TF_VAR_aws_default_region=us-east-1

export TF_VAR_swarm_ami_id=$(grep 'artifact,0,id' \
  packer-ubuntu-docker-rexray.log | cut -d, -f6 | cut -d: -f2)

terraform apply -target aws_instance.swarm-manager \
  -var swarm_init=true -var swarm_managers=1 -var rexray=true

terraform refresh

ssh -i devops21.pem ubuntu@$(terraform output \
  swarm_manager_1_public_ip) docker node ls
```


### Docker Swarm

# Add Nodes

---

```bash
export TF_VAR_swarm_manager_token=$(ssh -i devops21.pem \
  ubuntu@$(terraform output swarm_manager_1_public_ip) \
  docker swarm join-token -q manager)

export TF_VAR_swarm_manager_ip=$(terraform \
  output swarm_manager_1_private_ip)

terraform apply -target aws_instance.swarm-manager -var rexray=true

terraform refresh

ssh -i devops21.pem ubuntu@$(terraform \
  output swarm_manager_1_public_ip) docker node ls
```


### Docker Swarm

# Visualizer

---

```bash
ssh -i devops21.pem ubuntu@$(terraform \
  output swarm_manager_1_public_ip)

docker service create --name=visualizer \
  --publish=9090:8080/tcp --constraint=node.role==manager \
  --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  dockersamples/visualizer

exit

open "http://$(terraform output swarm_manager_1_public_ip):9090"
```


### Docker Swarm

# Networking

---

```bash
ssh -i devops21.pem ubuntu@$(terraform \
  output swarm_manager_1_public_ip)

docker network create --driver overlay proxy

docker network ls
```


### Docker Swarm

# Stacks

---

```bash
curl -o go-demo.yml \
    https://raw.githubusercontent.com/vfarcic\
/go-demo/master/docker-compose-stack.yml

cat go-demo.yml

docker stack deploy -c go-demo.yml go-demo

docker stack ps go-demo
```


### Docker Swarm

# Reverse Proxy

---

```bash
curl -o proxy.yml \
    https://raw.githubusercontent.com/vfarcic\
/docker-flow-proxy/master/docker-compose-stack.yml

docker stack deploy -c proxy.yml proxy

docker stack ps proxy

exit

open "http://$(terraform output \
    swarm_manager_1_public_ip)/demo/hello"
```


### Docker Swarm

# Persistent Storage

---

```bash
ssh -i devops21.pem ubuntu@$(terraform \
  output swarm_manager_1_public_ip)

curl -o registry.yml \
    https://raw.githubusercontent.com/vfarcic/\
docker-flow-stacks/master/docker/registry-rexray-external.yml

cat registry.yml

docker volume create -d rexray registry

docker volume ls

docker stack deploy -c registry.yml registry

docker stack ps registry
```


### Docker Swarm

# Persistent Storage

---

```bash
docker pull vfarcic/go-demo

docker tag vfarcic/go-demo localhost:5000/go-demo

docker push localhost:5000/go-demo

exit
```