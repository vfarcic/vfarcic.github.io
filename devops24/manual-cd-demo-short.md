## Hands-On Time

---

# Defining CD


<!-- .slide: data-background="img/manual-cd-stages.png" data-background-size="contain" -->


## Defining A Pod With The Tools

---

```bash
cd ..

git clone https://github.com/vfarcic/go-demo-3.git

cd go-demo-3

cat k8s/build-ns.yml

kubectl apply -f k8s/build-ns.yml --record

cat k8s/cd.yml

kubectl apply -f k8s/cd.yml --record
```


## Executing Continuous Integration Inside Containers

---

```bash
kubectl -n go-demo-3-build exec -it cd -c docker -- sh

git clone https://github.com/vfarcic/go-demo-3.git .

docker login -u vfarcic

cat Dockerfile

docker image build -t vfarcic/go-demo-3:1.0-beta .

docker image push vfarcic/go-demo-3:1.0-beta

exit
```


<!-- .slide: data-background="img/manual-cd-steps-build.png" data-background-size="contain" -->


<!-- .slide: data-background="img/manual-cd-steps-func.png" data-background-size="contain" -->


<!-- .slide: data-background="img/manual-cd-steps-release.png" data-background-size="contain" -->


<!-- .slide: data-background="img/manual-cd-steps-deploy.png" data-background-size="contain" -->


<!-- .slide: data-background="img/manual-cd-steps-prod.png" data-background-size="contain" -->


<!-- .slide: data-background="img/manual-cd-steps-cleanup.png" data-background-size="contain" -->


## What Now?

---

```bash
cd ../k8s-specs

kubectl delete ns go-demo-3-build
```