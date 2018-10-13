## Hands-On Time

---

# Deploying Releases With Zero-Downtime


## Deploying New Releases

---

```bash
cat deploy/go-demo-2-db.yml

kubectl create -f deploy/go-demo-2-db.yml --record

kubectl get -f deploy/go-demo-2-db.yml

kubectl describe -f deploy/go-demo-2-db.yml

kubectl get all
```


## Deploying New Releases

---

* We created a Deployment
* We described the Deployment and observed that it created a ReplicaSet
* We listed all the resources and observed that the ReplicaSet created Pods


<!-- .slide: data-background="img/deployment.png" data-background-size="contain" -->


<!-- .slide: data-background="img/seq_deploy_ch06.png" data-background-size="contain" -->


## Updating Deployments

---

```bash
kubectl set image -f deploy/go-demo-2-db.yml db=mongo:3.4 --record

kubectl describe -f deploy/go-demo-2-db.yml

kubectl get all

kubectl edit -f deploy/go-demo-2-db.yml

kubectl create -f deploy/go-demo-2-db-svc.yml --record
```


## Updating Deployments

---

* We changed the image of the `db` container definition in the Deployment
* We described the deployment to confirm that the image changed
* We retrieved all the resources and observed that a new ReplicaSet was created which, in turn, created a new Pod
* We tried to edit the resources definition but gave up since it is a bad practice
* We created a Service for the DB


## Zero-Downtime Deployments

---

```bash
cat deploy/go-demo-2-api.yml

kubectl create -f deploy/go-demo-2-api.yml --record

kubectl get -f deploy/go-demo-2-api.yml

kubectl set image -f deploy/go-demo-2-api.yml \
    api=vfarcic/go-demo-2:2.0 --record

kubectl rollout status -w -f deploy/go-demo-2-api.yml

kubectl describe -f deploy/go-demo-2-api.yml

kubectl rollout history -f deploy/go-demo-2-api.yml

kubectl get rs
```


## Zero-Downtime Deployments

---

* We created a Deployment for the API
* We changed the image of the `api` container definition in the API Deployment
* We executed `rollout status` to watch the progress of the update
* We described the API Deployment and observed events related to ReplicaSets
* We executed `rollout history` and observed that we made two revisions
* We retrieved all the ReplicaSets and observed that new ones we created with each update


<!-- .slide: data-background="img/flow_deploy_ch06.png" data-background-size="contain" -->


## Rolling Back Or Forward?

---

```bash
kubectl rollout undo -f deploy/go-demo-2-api.yml

kubectl describe -f deploy/go-demo-2-api.yml

kubectl rollout history -f deploy/go-demo-2-api.yml

kubectl set image -f deploy/go-demo-2-api.yml \
    api=vfarcic/go-demo-2:3.0 --record

kubectl rollout status -f deploy/go-demo-2-api.yml

kubectl set image -f deploy/go-demo-2-api.yml \
    api=vfarcic/go-demo-2:4.0 --record

kubectl rollout status -f deploy/go-demo-2-api.yml
```


## Rolling Back Or Forward?

---

* We undid the last update
* We described the deployment to observe the events related to ReplicaSets
* We output `rollout history` and observed that a new revision was created
* We updated the image of the `api` twice to generate a few more revisions


## Rolling Back Or Forward?

---

```bash
kubectl rollout history -f deploy/go-demo-2-api.yml

kubectl set image -f deploy/go-demo-2-api.yml \
    api=vfarcic/go-demo-2:2.0 --record

kubectl rollout undo -f deploy/go-demo-2-api.yml --to-revision=4

kubectl rollout history -f deploy/go-demo-2-api.yml
```


## Rolling Back Or Forward?

---

* We output `rollout history` to confirm that all the revisions were recorded
* We executed one more update
* We rolled out to the revision `2`
* We observed through `rollout history` that rollback to a specific revision was indeed performed


## Rolling Back Failures

---

```bash
kubectl set image -f deploy/go-demo-2-api.yml \
    api=vfarcic/go-demo-2:does-not-exist --record

kubectl get rs -l type=api

kubectl rollout status -f deploy/go-demo-2-api.yml

echo $?

kubectl rollout undo -f deploy/go-demo-2-api.yml

kubectl rollout status -f deploy/go-demo-2-api.yml
```


## Rolling Back Failures

---

* We set the image to the non-existing tag
* We retrieved the ReplicaSets of the `api` and observed that the could not finish the update
* We executed `rollout status` and observed that it returned error
* We rolled back to the previous revision
* We retrieved `rollout status` to confirm that the rollback was successful


## Rolling Back Failures

---

```bash
kubectl delete -f deploy/go-demo-2-db.yml

kubectl delete -f deploy/go-demo-2-db-svc.yml

kubectl delete -f deploy/go-demo-2-api.yml
```


## Rolling Back Failures

---

* We removed all the resources we created


## Merging Everything

---

```bash
cat deploy/go-demo-2.yml

kubectl create -f deploy/go-demo-2.yml --record --save-config

kubectl get -f deploy/go-demo-2.yml
```


## Merging Everything

---

* We created all the objects from a single YAML file


## Updating Multiple Objects

---

```bash
cat deploy/different-app-db.yml

kubectl create -f deploy/different-app-db.yml

kubectl get deployments --show-labels

kubectl get deployments -l type=db,vendor=MongoLabs

kubectl set image deployments -l type=db,vendor=MongoLabs \
    db=mongo:3.4 --record

kubectl describe -f deploy/go-demo-2.yml
```


## Updating Multiple Objects

---

* We installed a second DB Deployment
* We retrieved all the deployments and confirmed that two of them have matching labels
* We retrieved the Deployments of the DB using label filtering
* We updated all deployments with matching labels
* We described one of the deployments to confirm that the image was indeed updated


## Scaling Deployments

---

```bash
cat deploy/go-demo-2-scaled.yml

kubectl apply -f deploy/go-demo-2-scaled.yml

kubectl get -f deploy/go-demo-2-scaled.yml

kubectl scale deployment go-demo-2-api --replicas 8 --record

kubectl get -f deploy/go-demo-2.yml
```


## Scaling Deployments

---

* We created a few resources, including Deployment of the API with five replicas
* We retrieved the resources and observed that Deployment is indeed set to have five replicas
* We scaled the Deployment of the API to eight
* We retrieved the resources and observed that Deployment was changed to have eight replicas


## Deployments

---

* Zero-downtime updates<!-- .element: class="fragment" -->


<!-- .slide: data-background="img/deploy-components.png" data-background-size="contain" -->


## What Now?

---

```bash
kubectl delete -f deploy/go-demo-2.yml

kubectl delete -f deploy/different-app-db.yml
```
