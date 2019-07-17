## Hands-On Time

---

# Using Volumes To Access Host's File System


## Host's Resources > hostPath

---

```bash
cat volume/docker.yml

kubectl create -f volume/docker.yml

kubectl exec -it docker -- docker image ls \
    --format '{{.Repository}}'
```


<!-- .slide: data-background="img/volume-hostPath.png" data-background-size="contain" -->


## Host's Resources > hostPath

---

```bash
kubectl exec -it docker sh

apk add -U git

git clone https://github.com/vfarcic/go-demo-2.git

cd go-demo-2

docker image build -t vfarcic/go-demo-2:beta .

docker image ls

exit

kubectl delete -f volume/docker.yml
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


<!-- .slide: data-background="img/volume-git-repo.png" data-background-size="contain" -->
