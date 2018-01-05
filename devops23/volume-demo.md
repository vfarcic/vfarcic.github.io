## Hands-On Time

---

# Volumes


## Gist

---

[08-volume.sh](https://gist.github.com/5acafb64c0124a1965f6d371dd0dedd1) (https://goo.gl/v5xzyA)


## Creating A Cluster

---

```bash
cd k8s-specs

git pull

cp volume/prometheus-conf.yml ~/.minikube/files

minikube start --vm-driver=virtualbox

kubectl config current-context
```


## Host's Resources > hostPath

---

```bash
kubectl run docker --image=docker:17.11 --restart=Never docker image ls

kubectl get pods --show-all

kubectl logs docker

kubectl delete pod docker
```


## Host's Resources > hostPath

---

```bash
cat volume/docker.yml

kubectl create -f volume/docker.yml

kubectl exec -it docker -- docker image ls \
    --format '{{.Repository}}'
```


## Host's Resources > hostPath

---

```bash
kubectl exec -it docker sh

apk add -U git

git clone https://github.com/vfarcic/go-demo-2.git

cd go-demo-2

cat Dockerfile

docker image build -t vfarcic/go-demo-2:beta .
```


## Host's Resources > hostPath

---

```bash
docker image ls --format "{{.Repository}}"

docker system prune -f

docker image ls --format "{{.Repository}}"

exit

kubectl delete -f volume/docker.yml
```


## hostPath > Inject Config Files

---

```bash
cat volume/prometheus.yml

cat volume/prometheus.yml \
    | sed -e "s/192.168.99.100/$(minikube ip)/g" \
    | kubectl create -f - --record --save-config

kubectl rollout status deploy prometheus

open "http://$(minikube ip)/prometheus"

open "http://$(minikube ip)/prometheus/targets"

open "http://$(minikube ip)/prometheus/config"
```


## hostPath > Inject Config Files

---

```bash
cat volume/prometheus-host-path.yml

minikube ssh sudo chmod +rw /files/prometheus-conf.yml

minikube ssh cat /files/prometheus-conf.yml

cat volume/prometheus-host-path.yml \
    | sed -e "s/192.168.99.100/$(minikube ip)/g" \
    | kubectl apply -f -

kubectl rollout status deploy prometheus

open "http://$(minikube ip)/prometheus/targets"

kubectl delete -f volume/prometheus-host-path.yml
```


## gitRepo > Git Repository

---

```bash
cat volume/github.yml

kubectl create -f volume/github.yml

kubectl exec -it github sh

cd /src

ls -l

docker image build -t vfarcic/go-demo-2:beta .

exit

kubectl delete -f volume/github.yml
```


## emptyDir > Persist State

---

```bash
cat volume/jenkins.yml

kubectl create -f volume/jenkins.yml --record --save-config

kubectl rollout status deploy jenkins

open "http://$(minikube ip)/jenkins"

open "http://$(minikube ip)/jenkins/newJob"
```


## emptyDir > Persist State

---

```bash
POD_NAME=$(kubectl get pods -l service=jenkins,type=master \
    -o jsonpath="{.items[*].metadata.name}")

kubectl exec -it $POD_NAME kill 1

kubectl get pods

open "http://$(minikube ip)/jenkins"
```


## emptyDir > Persist State

---

```bash
cat volume/jenkins-empty-dir.yml

kubectl apply -f volume/jenkins-empty-dir.yml

kubectl rollout status deploy jenkins

open "http://$(minikube ip)/jenkins/newJob"

POD_NAME=$(kubectl get pods -l service=jenkins,type=master \
    -o jsonpath="{.items[*].metadata.name}")

kubectl exec -it $POD_NAME kill 1

kubectl get pods

open "http://$(minikube ip)/jenkins"
```


## What Now?

---

```bash
minikube delete
```

[Volume v1 core](https://v1-8.docs.kubernetes.io/docs/api-reference/v1.8/#volume-v1-core) (https://v1-8.docs.kubernetes.io/docs/api-reference/v1.8/#volume-v1-core)

## ConfigMaps coming next<!-- .element: class="fragment" -->