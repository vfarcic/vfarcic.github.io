```bash
jx get addons

jx create addon prometheus

jx get addons

helm ls

PROM_ADDR=$(kubectl -n jx get ing prometheus-server -o jsonpath="{.spec.rules[0].host}")

open "http://$PROM_ADDR"
```

* Use `admin` as the username and password

```bash
jx create addon anchore

# export JENKINS_X_DOCKER_REGISTRY_SERVICE_HOST=docker-registry.jx.35.231.225.121.nip.io

# export JENKINS_X_DOCKER_REGISTRY_SERVICE_PORT=80

# jx step post build --image vfarcic/presentations
```