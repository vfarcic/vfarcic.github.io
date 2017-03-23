## Hands-On Time

---

## Ship logs

## from any container

## running inside a cluster


# ELK Stack

---

```bash
ssh -i devops21.pem ubuntu@$(terraform \
  output swarm_manager_1_public_ip)

curl -o logging.yml https://raw.githubusercontent.com/vfarcic/\
docker-flow-stacks/master/logging/logging-df-proxy.yml

cat logging.yml

docker stack deploy -c logging.yml logging

docker stack ps logging
```


# Testing Log Spout

---

```bash
exit

open "http://$(terraform output swarm_manager_1_public_ip)\
/app/kibana"
```


# Cleanup

---

```bash
docker service rm logging_kibana

exit
```