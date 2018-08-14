## Hands-On Time

---

# Using Volumes To Access Host's File System


## Adding Files (minikube)

---

```bash
minikube stop

cp volume/prometheus-conf.yml ~/.minikube/files

minikube start

minikube ssh "ls -l /files"

minikube ssh "sudo mkdir /files"

minikube ssh "sudo mv /prometheus-conf.yml  /files/"
```


## Adding Files (minikube)

---

* We stopped minikube, copied a few files to `~/.minikube/files`, and started it again
* We observed that the files were copied to minikube VM
* We moved them from root to `/files`


## Host's Resources > hostPath

---

```bash
kubectl run docker --image=docker:17.11 \
    --restart=Never docker image ls

kubectl get pods

kubectl logs docker

kubectl delete pod docker
```


## Host's Resources > hostPath

---

* We created a Pod based on `docker` image
* We listed the Pods and observed that `docker` errors
* We output the logs and noticed that Docker client inside a container cannot connect to Docker socket
* We removed the Pod


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

* We created a Pod based on `docker` image and with `/var/run/docker.sock` mounted to the same path on the node
* We entered into the newly created Pod and confirmed that we can list images available on the node


<!-- .slide: data-background="img/volume-hostPath.png" data-background-size="contain" -->


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

* We entered into the `docker` container
* We installed Git and cloned `go-demo-2` repository
* We built a new image


## Host's Resources > hostPath

---

```bash
docker image ls --format "{{.Repository}}"

docker system prune -f

docker image ls --format "{{.Repository}}"

exit

kubectl delete -f volume/docker.yml
```


## Host's Resources > hostPath

---

* We listed the images thus confirming that the one we built is inside the node, not inside the container
* We pruned unused images, containers, networks, and so on
* We listed the images again thus confirming that unused ones are removed
* We deleted the Pod


## hostPath > Inject Config Files (minikube)

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


## hostPath > Inject Config Files (minikube)

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


## gitRepo > Git Repository (minikube)

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


<!-- .slide: data-background="img/volume-git-repo.png" data-background-size="contain" -->


## emptyDir > Persist State (minikube)

---

```bash
cat volume/jenkins.yml

kubectl create -f volume/jenkins.yml --record --save-config

kubectl rollout status deploy jenkins

open "http://$(minikube ip)/jenkins"

open "http://$(minikube ip)/jenkins/newJob"

# Create a new job
```


## emptyDir > Persist State (minikube)

---

```bash
POD_NAME=$(kubectl get pods -l service=jenkins,type=master \
    -o jsonpath="{.items[*].metadata.name}")

kubectl exec -it $POD_NAME kill 1

kubectl get pods

open "http://$(minikube ip)/jenkins"
```


## emptyDir > Persist State (minikube)

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


<!-- .slide: data-background="img/volume-components.png" data-background-size="contain" -->


## What Now?

---

```bash
# If minikube
kubectl delete -f volume/jenkins-empty-dir.yml
```
