## Hands-On Time

---

## Ship logs

## from any container

## running inside a cluster


# ELK Stack

---

```bash
curl -o logging.yml \
  https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/logging/logging-df-proxy.yml

cat logging.yml

echo 'input {
  syslog { port => 51415 }
}

output {
  elasticsearch {
    hosts => ["elasticsearch:9200"]
  }
}' | docker config create logstash.conf -

docker stack deploy -c logging.yml logging
```


# Testing Log Spout

---

```bash
docker stack ps -f desired-state=running logging

exit

open "http://$CLUSTER_DNS/app/kibana"
```


# Cleanup

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP

docker service rm logging_kibana
```