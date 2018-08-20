## Hands-On Time

---

# Deploying Stateful Applications At Scale


## Using StatefulSets To Run Stateful Applications

---

```bash
cat sts/jenkins.yml

kubectl apply -f sts/jenkins.yml --record

kubectl -n jenkins rollout status sts jenkins

kubectl -n jenkins get pvc

kubectl -n jenkins get pv

JENKINS_ADDR=$(kubectl -n jenkins get ing jenkins \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

open "http://$JENKINS_ADDR/jenkins"

kubectl delete ns jenkins
```


## Using StatefulSets To Run Stateful Applications

---

* We observed that StatefulSets use `volumeClaimTemplate` instead of a separate PersistentVolumeClaim
* We used StatefulSet to run Jenkins
* We did NOT observe any significant difference between running a single replica Jenkins as a StatefulSet when compared to Deployments
* We deleted the `jenkins` Namespace


## Using Deployments To Run Stateful Applications At Scale

---

```bash
cat sts/go-demo-3-deploy.yml

kubectl apply -f sts/go-demo-3-deploy.yml --record

kubectl -n go-demo-3 rollout status deployment api

kubectl -n go-demo-3 get pods

DB_1=$(kubectl -n go-demo-3 get pods -l app=db \
    -o jsonpath="{.items[0].metadata.name}")

DB_2=$(kubectl -n go-demo-3 get pods -l app=db \
    -o jsonpath="{.items[1].metadata.name}")
```


## Using Deployments To Run Stateful Applications At Scale

---

* We installed *go-demo-3* API and DB as Deployments with multiple replicas
* We retrieved the Pods and observed that all but one DB failed
* We retrieved names of two DB Pods


## Using Deployments To Run Stateful Applications At Scale

---

```bash
kubectl -n go-demo-3 logs $DB_1

kubectl -n go-demo-3 logs $DB_2

kubectl get pv

kubectl delete ns go-demo-3
```


## Using Deployments To Run Stateful Applications At Scale

---

* We observed from the logs that at least one DB Pod could not get a lock on the storage file
* We retrieved the PersistentVolumes and observed that only one was created for all three replicas of the DB
* We deleted the `go-demo-3` Namespace


<!-- .slide: data-background="img/sts-deployment.png" data-background-size="contain" -->


## Using StatefulSets To Run Stateful Applications At Scale

---

```bash
cat sts/go-demo-3-sts.yml

kubectl apply -f sts/go-demo-3-sts.yml --record

kubectl -n go-demo-3 get pods

kubectl get pv
```


## Using StatefulSets To Run Stateful Applications At Scale

---

* We installed *go-demo-3* with DB replicas defined as StatefulSet
* We retrieved the Pods and observed that DB Pods are created sequentially (and that API Pods are failing)
* We retrieved PersistentVolumes and observed that one was created for each StatefulSet Pod


<!-- .slide: data-background="img/sts.png" data-background-size="contain" -->


## Using StatefulSets To Run Stateful Applications At Scale
## (only if kops)

---

```bash
kubectl -n go-demo-3 exec -it db-0 -- hostname

kubectl -n go-demo-3 run -it --image busybox dns-test \
    --restart=Never --rm sh

nslookup db

nslookup db-0.db

exit
```


## Using StatefulSets To Run Stateful Applications At Scale

---

```bash
kubectl -n go-demo-3 exec -it db-0 -- sh

mongo

rs.initiate( {
   _id : "rs0",
   members: [
      {_id: 0, host: "db-0.db:27017"},
      {_id: 1, host: "db-1.db:27017"},
      {_id: 2, host: "db-2.db:27017"}
   ]
})

rs.status()
```


## Using StatefulSets To Run Stateful Applications At Scale

---

* We entered into one of the DB Pods and created a MongoDB replica set


## Using StatefulSets To Run Stateful Applications At Scale

---

```bash
exit

exit

kubectl -n go-demo-3 get pods
```


## Using StatefulSets To Run Stateful Applications At Scale

---

* We retrieved the Pods and observed that API is not failing to connect to the DB any more


## Using StatefulSets To Run Stateful Applications At Scale

---

```bash
diff sts/go-demo-3-sts.yml sts/go-demo-3-sts-upd.yml

kubectl apply -f sts/go-demo-3-sts-upd.yml --record

kubectl -n go-demo-3 get pods

kubectl delete ns go-demo-3
```


## Using StatefulSets To Run Stateful Applications At Scale

---

* We updated the DB to the new image tag
* We observed that the Pods are updated in sequential order, from the last to the first
* We deleted the *go-demo-3* Namespace


## Using Sidecar Containers To Initialize Applications

---

```bash
cat sts/go-demo-3.yml

kubectl apply -f sts/go-demo-3.yml --record

# Wait for a few moments

kubectl -n go-demo-3 logs db-0 -c db-sidecar

kubectl delete ns go-demo-3
```


## Using Sidecar Containers To Initialize Applications

---

* We installed *go-demo-3* with DB StatefulSet containing a sidecar in charge of creating MongoDB replica set
* We retrieved the sidecar logs and observed that it is forbidden from listing the Pods
* We deleted the Namespace


## Using Sidecar Containers To Initialize Applications

---

```bash
cat sa/go-demo-3.yml

kubectl create -f sa/go-demo-3.yml --record --save-config

kubectl -n go-demo-3 get pods

kubectl -n go-demo-3 logs db-0 -c db-sidecar
```


## Using Sidecar Containers To Initialize Applications

---

* We created the DB StatefulSet attached to the ServiceAccount and provides the necessary permissions
* We observed that all the Pods were created
* We observed that sidecar logs do not show any issues


## What Now?

```bash
kubectl delete ns go-demo-3
```
