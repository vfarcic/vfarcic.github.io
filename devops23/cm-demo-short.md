## Hands-On Time

---

# Using ConfigMaps To Inject Configuration Files


## Injecting Configs From Files

---

```bash
kubectl create cm my-config --from-file=cm/prometheus-conf.yml \
    --from-file=cm/prometheus.yml

cat cm/alpine.yml

kubectl create -f cm/alpine.yml

kubectl exec -it alpine -- ls /etc/config

kubectl exec -it alpine -- cat /etc/config/prometheus-conf.yml

kubectl delete -f cm/alpine.yml

kubectl delete cm my-config
```


## Configs From Literals

---

```bash
kubectl create cm my-config \
    --from-literal=something=else --from-literal=weather=sunny

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


<!-- .slide: data-background="img/cm-components.png" data-background-size="contain" -->
