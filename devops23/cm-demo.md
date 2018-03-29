## Hands-On Time

---

# ConfigMaps


## Gist

---

[09-config-map.sh](https://gist.github.com/717f8418982cc5ec1c755fcf7d4255dd) (https://goo.gl/sdQL66)


## Creating A Cluster

---

```bash
cd k8s-specs

git pull

minikube start --vm-driver=virtualbox

kubectl config current-context
```


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

```bash
kubectl exec -it alpine -- sh -c \
    'echo "SOMETHING ELSE" >> /etc/config/prometheus-conf.yml'

kubectl exec -it alpine -- cat /etc/config/prometheus-conf.yml

# Wait

kubectl exec -it alpine -- cat /etc/config/prometheus-conf.yml

kubectl delete -f cm/alpine.yml

kubectl delete cm my-config
```


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

```bash
kubectl create -f cm/alpine.yml

kubectl exec -it alpine -- ls /etc/config

kubectl delete -f cm/alpine.yml

kubectl delete cm my-config
```


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


## Configs From Environment Files

---

```bash
cat cm/my-env-file.yml

kubectl create cm my-config --from-env-file=cm/my-env-file.yml

kubectl get cm my-config -o yaml
```


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


## ConfigMaps As YAML

---

```bash
kubectl get cm my-config -o yaml

cat cm/prometheus.yml

cat cm/prometheus.yml | sed -e "s/192.168.99.100/$(minikube ip)/g" \
    | kubectl create -f -

kubectl rollout status deploy prometheus

open "http://$(minikube ip)/prometheus/targets"
```


<!-- .slide: data-background="img/cm-components.png" data-background-size="contain" -->


## What Now?

---

```bash
minikube delete
```

[ConfigMap v1 core](https://v1-8.docs.kubernetes.io/docs/api-reference/v1.8/#configmap-v1-core) (https://v1-8.docs.kubernetes.io/docs/api-reference/v1.8/#configmap-v1-core)

## Secrets coming next<!-- .element: class="fragment" -->
