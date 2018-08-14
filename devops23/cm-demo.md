## Hands-On Time

---

# Using ConfigMaps To Inject Configuration Files


## Injecting Configs From Files

---

```bash
kubectl create cm my-config --from-file=cm/prometheus-conf.yml

kubectl describe cm my-config

cat cm/alpine.yml

kubectl create -f cm/alpine.yml

kubectl get pods

kubectl exec -it alpine -- ls /etc/config

kubectl exec -it alpine -- cat /etc/config/prometheus-conf.yml
```


## Injecting Configs From Files

---

* We created a ConfigMap from a file
* We described the ConfigMap and confirmed that `prometheus-conf.yml` is present
* We created a Pod that mounts the ConfigMap
* We listed the files in `/etc/config` inside the container and confirmed that the file is available
* We output the content of the file inside the container to confirm that it is correct


## Injecting Configs From Files

---

```bash
kubectl exec -it alpine -- sh -c \
    'echo "SOMETHING ELSE" >> /etc/config/prometheus-conf.yml'

kubectl exec -it alpine -- cat /etc/config/prometheus-conf.yml

kubectl delete -f cm/alpine.yml

kubectl delete cm my-config
```


## Injecting Configs From Files

---

* We tried to modify the file created through ConfigMap and observed that it is read-only
* We deleted the Pod and the ConfigMap


## Injecting Configs From Files

---

```bash
kubectl create cm my-config --from-file=cm/prometheus-conf.yml \
    --from-file=cm/prometheus.yml

kubectl create -f cm/alpine.yml

kubectl exec -it alpine -- ls /etc/config

kubectl delete -f cm/alpine.yml

kubectl delete cm my-config

kubectl create cm my-config --from-file=cm

kubectl describe cm my-config
```


## Injecting Configs From Files

---

* We created a ConfigMap with two files and a Pod that mounts it
* We confirmed that both files are inside the container
* We deleted the Pod and the ConfigMap
* We created a new ConfigMap that references a directory
* We described the ConfigMap and confirmed that all the files from the directory are data entries


## Injecting Configs From Files

---

```bash
kubectl create -f cm/alpine.yml

kubectl exec -it alpine -- ls /etc/config

kubectl delete -f cm/alpine.yml

kubectl delete cm my-config
```


## Injecting Configs From Files

---

* We created a Pod with a container that mounts the ConfigMap
* We listed the files in the container and confirmed that all the files from ConfigMap are mounted
* We deleted the Pod and the ConfigMap


## Configs From Literals

---

```bash
kubectl create cm my-config \
    --from-literal=something=else --from-literal=weather=sunny

kubectl get cm my-config -o yaml

kubectl create -f cm/alpine.yml

kubectl exec -it alpine -- ls /etc/config

kubectl exec -it alpine -- cat /etc/config/something

kubectl delete -f cm/alpine.yml

kubectl delete cm my-config
```


## Configs From Literals

---

* We created a ConfigMap based on literal values
* We retrieved the information of the ConfigMap and confirmed that the values are available
* We created a Pod that mounts the ConfigMap
* We listed the files in the container and confirmed that each literal is mounted as a file
* We output content of the files and confirmed that it is the same as the literal value
* We deleted the Pod and the ConfigMap


## Configs From Environment Files

---

```bash
cat cm/my-env-file.yml

kubectl create cm my-config --from-env-file=cm/my-env-file.yml

kubectl get cm my-config -o yaml
```


## Configs From Environment Files

---

* We created a ConfigMap using a file with key/value entries
* We confirmed that each key/value pair is a separate data intry in the map


## ConfigMap To Env. Vars

---

```bash
cat cm/alpine-env.yml

kubectl create -f cm/alpine-env.yml

kubectl exec -it alpine-env -- env

kubectl delete -f cm/alpine-env.yml

cat cm/alpine-env-all.yml

kubectl create -f cm/alpine-env-all.yml

kubectl exec -it alpine-env -- env
```


## ConfigMap To Env. Vars

---

* We created a Pod with environment variables based on ConfigMap
* We confirmed that the container has the environment variables
* We deleted the Pod
* We created a new Pod that converts all ConfigMap entries into environment variables
* We confirmed that the container has the environment variables


## ConfigMaps As YAML

---

```bash
cat cm/prometheus.yml

cat cm/prometheus.yml | sed -e "s/192.168.99.100/$IP/g" \
    | kubectl create -f -

kubectl rollout status deploy prometheus

open "http://$IP/prometheus/targets"
```


## ConfigMaps As YAML

---

* We created Prometheus Deployment with configuration injected through a ConfigMap
* We confirmed that Prometheus is configured correctly


<!-- .slide: data-background="img/cm-components.png" data-background-size="contain" -->


## What Now?

---

```bash
kubectl delete -f cm/prometheus.yml

kubectl delete -f cm/alpine-env-all.yml

kubectl delete cm my-config
```
