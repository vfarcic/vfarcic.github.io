```bash
# Pre-Load

vagrant up cd serv-disc-01 serv-disc-02 serv-disc-03

vagrant ssh cd -c "sudo chmod +x /vagrant/scripts/*"

vagrant ssh cd -c "ansible-playbook /vagrant/ansible/consul.yml -i /vagrant/ansible/hosts/serv-disc" # Answer "yes" when asked

vagrant ssh serv-disc-01 -c "sudo /vagrant/scripts/preload_serv_disc.sh"

vagrant ssh serv-disc-02 -c "sudo /vagrant/scripts/preload_serv_disc.sh"

vagrant ssh serv-disc-03 -c "sudo /vagrant/scripts/preload_serv_disc.sh"

vagrant ssh cd -c "sudo apt-add-repository -y ppa:zanchey/asciinema && sudo apt-get update && sudo apt-get install -y asciinema toilet"

vagrant ssh serv-disc-01 -c "sudo apt-add-repository -y ppa:zanchey/asciinema && sudo apt-get update && sudo apt-get install -y asciinema toilet"

vagrant ssh serv-disc-02 -c "sudo apt-add-repository -y ppa:zanchey/asciinema && sudo apt-get update && sudo apt-get install -y asciinema toilet"

# Consul

toilet -f mono12 --metal "Consul"

vagrant ssh cd -c "ansible-playbook \
    /vagrant/ansible/consul.yml \
    -i /vagrant/ansible/hosts/serv-disc"

vagrant ssh cd -c "curl 10.100.194.201:8500/v1/catalog/nodes \
    | jq '.'"

vagrant ssh cd -c "curl -X PUT -d 'this is a test' \
    http://10.100.194.201:8500/v1/kv/msg1"

vagrant ssh cd -c "curl -X PUT -d 'this is another test' \
    http://10.100.194.202:8500/v1/kv/messages/msg2"

vagrant ssh cd -c "curl -X PUT -d 'this is a test with flags' \
    http://10.100.194.203:8500/v1/kv/messages/msg3?flags=1234"

vagrant ssh cd -c "curl http://10.100.194.203:8500/v1/kv/?recurse \
    | jq '.'"

vagrant ssh cd -c "curl http://10.100.194.202:8500/v1/kv/msg1 \
    | jq '.'"

vagrant ssh cd -c "curl http://10.100.194.201:8500/v1/kv/msg1?raw"

vagrant ssh cd -c "curl -X DELETE http://10.100.194.201:8500/v1/kv/messages/msg2"

vagrant ssh cd -c "curl http://10.100.194.203:8500/v1/kv/?recurse \
    | jq '.'"

vagrant ssh cd -c "curl -X DELETE http://10.100.194.202:8500/v1/kv/?recurse"

vagrant ssh cd -c "curl http://10.100.194.203:8500/v1/kv/?recurse \
    | jq '.'"

# Registrator

toilet -f mono9 --metal "Registrator"

vagrant ssh cd -c "ansible-playbook \
    /vagrant/ansible/registrator.yml \
    -i /vagrant/ansible/hosts/serv-disc"

vagrant ssh serv-disc-01 -c "docker run -d --name nginx \
    --env SERVICE_NAME=nginx \
    --env SERVICE_ID=nginx \
    -p 1234:80 \
    nginx"

vagrant ssh serv-disc-01 -c "curl http://10.100.194.201:8500/v1/catalog/service/nginx \
    | jq '.'"

vagrant ssh serv-disc-02 -c "docker run -d --name nginx2 \
    --env \"SERVICE_ID=nginx2\" \
    --env \"SERVICE_NAME=nginx\" \
    --env \"SERVICE_TAGS=balancer,proxy,www\" \
    -p 1111:80 \
    nginx"

vagrant ssh serv-disc-02 -c "curl http://localhost:8500/v1/catalog/service/nginx \
    | jq '.'"

# Consul Template

toilet -f mono12 --metal "Consul
Template"

vagrant ssh cd -c "ansible-playbook \
    /vagrant/ansible/consul-template.yml \
    -i /vagrant/ansible/hosts/serv-disc"

vagrant ssh serv-disc-01 -c "curl http://localhost:8500/v1/catalog/service/nginx \
    | jq '.'"

vagrant ssh serv-disc-01 -c "cat /data/consul-template/example.ctmpl"

vagrant ssh serv-disc-01 -c "consul-template \
    -consul localhost:8500 \
    -template \"/data/consul-template/example.ctmpl:/tmp/example.conf\" \
    -once"

vagrant ssh serv-disc-01 -c "cat /tmp/example.conf"

# Destroy

vagrant destroy -f
```