TODO
====

* Pre-load vfarcic/docker-flow-proxy
* Pre-load vfarcic/books-ms

Self-Healing Systems Workshop
=============================

Workshop
--------

```bash
```

### Setting Up Consul Health Checks and Watches for Monitoring Hardware

```bash
vagrant ssh swarm-master

sudo mkdir -p /data/consul/scripts

echo '#!/usr/bin/env bash

set -- $(df -h | awk '"'"'$NF=="/"{print $2" "$3" "$5}'"'"')
total=$1
used=$2
used_percent=${3::-1}
printf "Disk Usage: %s/%s (%s%%)\n" $used $total $used_percent
if [ $used_percent -gt 95 ]; then
  exit 2
elif [ $used_percent -gt 80 ]; then
  exit 1
else
  exit 0
fi
' | sudo tee /data/consul/scripts/disk.sh

sudo chmod +x /data/consul/scripts/disk.sh

/data/consul/scripts/disk.sh

echo $?

echo '{
  "checks": [
    {
      "id": "disk",
      "name": "Disk utilization",
      "notes": "Critical 95% util, warning 80% util",
      "script": "/data/consul/scripts/disk.sh",
      "interval": "10s"
    }
  ]
}' | sudo tee /data/consul/config/consul_check.json

sudo killall -HUP consul
```

* Open [http://10.100.192.200:8500/ui/](http://10.100.192.200:8500/ui/) > Nodes > swarm-master

```bash
echo '#!/usr/bin/env bash

RED="\033[0;31m"
NC="\033[0;0m"

read -r JSON
echo "Consul watch request:"
echo "$JSON"

STATUS_ARRAY=($(echo "$JSON" | jq -r ".[].Status"))
CHECK_ID_ARRAY=($(echo "$JSON" | jq -r ".[].CheckID"))
LENGTH=${#STATUS_ARRAY[*]}

for (( i=0; i<=$(( $LENGTH -1 )); i++ ))
do
    CHECK_ID=${CHECK_ID_ARRAY[$i]}
    STATUS=${STATUS_ARRAY[$i]}
    echo -e "${RED}Triggering Jenkins job http://10.100.198.200:8080/job/hardware-notification/build${NC}"
    curl -X POST http://10.100.198.200:8080/job/hardware-notification/build \
        --data-urlencode json="{\"parameter\": [{\"name\":\"checkId\", \"value\":\"$CHECK_ID\"}, {\"name\":\"status\", \"value\":\"$STATUS\"}]}"
done
' | sudo tee /data/consul/scripts/manage_watches.sh

sudo chmod +x /data/consul/scripts/manage_watches.sh

echo '{
  "watches": [
    {
      "type": "checks",
      "state": "warning",
      "handler": "/data/consul/scripts/manage_watches.sh >>/data/consul/logs/watches.log"
    }, {
      "type": "checks",
      "state": "critical",
      "handler": "/data/consul/scripts/manage_watches.sh >>/data/consul/logs/watches.log"
    }
  ]
}' | sudo tee /data/consul/config/watches.json
```

* Open [http://10.100.198.200:8080/job/hardware-notification/configure](http://10.100.198.200:8080/job/hardware-notification/configure)

```bash
sudo sed -i "s/80/2/" /data/consul/scripts/disk.sh

sudo killall -HUP consul

cat /data/consul/logs/watches.log # Repeat until "Triggering Jenkins job"...
```

* Open [http://10.100.198.200:8080/job/hardware-notification/lastBuild/console](http://10.100.198.200:8080/job/hardware-notification/lastBuild/console)

```bash
exit
```

### Automatically Setting Up Consul Health Checks and Watches for Monitoring Hardware

```bash
vagrant ssh cd

cat /vagrant/ansible/swarm-healing.yml

ansible-playbook /vagrant/ansible/swarm-healing.yml \
    -i /vagrant/ansible/hosts/prod
```

* Open [http://10.100.192.200:8500/ui/#/dc1/nodes](http://10.100.192.200:8500/ui/#/dc1/nodes) > select any of the nodes

### Setting Up Consul Health Checks and Watches for Monitoring Services

* Open [http://10.100.198.200:8080/job/books-ms/](http://10.100.198.200:8080/job/books-ms/) > Build Indexing > Run Now
* Open [https://github.com/vfarcic/books-ms/blob/master/consul_check.ctmpl](https://github.com/vfarcic/books-ms/blob/master/consul_check.ctmpl)
* Open [https://github.com/vfarcic/books-ms/blob/master/Jenkinsfile](https://github.com/vfarcic/books-ms/blob/master/Jenkinsfile)

```bash
cat /vagrant/ansible/roles/consul-healing/templates/manage_watches.sh

cat /vagrant/ansible/roles/jenkins/templates/service-redeploy.groovy

docker -H tcp://swarm-master:2375 ps \
    --filter name=books

curl swarm-master/api/v1/books

exit

vagrant ssh swarm-master

docker stop nginx

exit

vagrant ssh cd

export DOCKER_HOST=tcp://swarm-master:2375

curl swarm-master/api/v1/books
```

* Open [http://10.100.192.200:8500/ui/#/dc1/services/books-ms](http://10.100.192.200:8500/ui/#/dc1/services/books-ms)
* Open [http://10.100.198.200:8080/job/service-redeploy/lastBuild/console](http://10.100.198.200:8080/job/service-redeploy/lastBuild/console)

```bash
curl -I swarm-master/api/v1/books

docker rm -f $(docker ps --filter name=booksms --format "{{.ID}}")
```

* Open [http://10.100.198.200:8080/job/service-redeploy/lastBuild/console](http://10.100.198.200:8080/job/service-redeploy/lastBuild/console)

```bash
docker ps --filter name=books --format "table {{.Names}}"

curl -I swarm-master/api/v1/books
```

### Preventive Healing Through Scheduled Scaling and Descaling

* Open [http://10.100.198.200:8080/job/books-ms-scale/configure](http://10.100.198.200:8080/job/books-ms-scale/configure)

```bash
docker ps --filter name=books --format "table {{.Names}}"

curl swarm-master:8500/v1/kv/books-ms/instances?raw
```

* Open [http://10.100.198.200:8080/job/books-ms-scale/build?delay=0sec](http://10.100.198.200:8080/job/books-ms-scale/build?delay=0sec) > Click Build
* Open [http://10.100.198.200:8080/job/books-ms-scale/lastBuild/console](http://10.100.198.200:8080/job/books-ms-scale/lastBuild/console)

```bash
docker ps --filter name=books --format "table {{.Names}}"

curl swarm-master:8500/v1/kv/books-ms/instances?raw
```

* Open [http://10.100.192.200:8500/ui/#/dc1/kv/books-ms/instances/edit](http://10.100.192.200:8500/ui/#/dc1/kv/books-ms/instances/edit)
* Open [http://10.100.198.200:8080/job/books-ms-descale/configure](http://10.100.198.200:8080/job/books-ms-descale/configure)
* Open [http://10.100.198.200:8080/job/books-ms-descale/build?delay=0sec](http://10.100.198.200:8080/job/books-ms-descale/build?delay=0sec) > Click Build

```bash
docker ps --filter name=books --format "table {{.Names}}"

curl swarm-master:8500/v1/kv/books-ms/instances?raw
```

### Cleanup

```bash
exit

vagrant halt
```