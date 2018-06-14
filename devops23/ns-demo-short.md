## Hands-On Time

---

# Dividing A Cluster Into Namespaces


## Deploying The First Release

---

```bash
cat ns/go-demo-2.yml

IMG=vfarcic/go-demo-2

TAG=1.0

cat ns/go-demo-2.yml | sed -e "s@image: $IMG@image: $IMG:$TAG@g" \
    | kubectl create -f -

kubectl rollout status deploy go-demo-2-api

curl -H "Host: go-demo-2.com" "http://$(minikube ip)/demo/hello"
```


## Exploring Virtual Clusters

---

```bash
kubectl get all
```


<!-- .slide: data-background="img/go-demo-2.png" data-background-size="contain" -->


## Exploring The Existing Namespaces

---

```bash
kubectl get ns
```


<!-- .slide: data-background="img/default-ns.png" data-background-size="contain" -->


## Exploring The Existing Namespaces

---

```bash
kubectl -n kube-system get all
```


<!-- .slide: data-background="img/kube-system-ns.png" data-background-size="contain" -->


## Deploying To A New Namespace

---

```bash
kubectl create ns testing

TAG=2.0

DOM=go-demo-2.com

cat ns/go-demo-2.yml | sed -e "s@image: $IMG@image: $IMG:$TAG@g" \
    | sed -e "s@host: $DOM@host: $TAG\.$DOM@g" \
    | kubectl -n testing create -f -

kubectl  -n testing rollout status deploy go-demo-2-api
```


<!-- .slide: data-background="img/testing-ns.png" data-background-size="contain" -->


## Deploying To A New Namespace

---

```bash
curl -H "Host: go-demo-2.com" "http://$(minikube ip)/demo/hello"

curl -H "Host: 2.0.go-demo-2.com" "http://$(minikube ip)/demo/hello"
```


## Communicating Between Namespaces

---

```bash
kubectl run test --image=alpine --restart=Never sleep 10000

kubectl get pod test

kubectl exec -it test -- apk add -U curl

kubectl exec -it test -- curl "http://go-demo-2-api:8080/demo/hello"

kubectl exec -it test \
    -- curl "http://go-demo-2-api.testing:8080/demo/hello"
```


## Deleting A Namespace

---

```bash
kubectl delete ns testing

kubectl -n testing get all

kubectl get all

curl -H "Host: go-demo-2.com" "http://$(minikube ip)/demo/hello"

kubectl set image deployment/go-demo-2-api \
    api=vfarcic/go-demo-2:2.0 --record
```


## What Now?

---

```bash
kubectl delete -f ns/go-demo-2.yml

kubectl delete pod test
```
