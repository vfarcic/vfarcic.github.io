<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Deploying Stateful Applications At Scale

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Running Stateful Applications

```bash
cat sts/jenkins.yml

kubectl apply -f sts/jenkins.yml --record

kubectl -n jenkins rollout status sts jenkins

kubectl -n jenkins get pvc

kubectl -n jenkins get pv
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Running Stateful Applications

* We observed that StatefulSets use `volumeClaimTemplate` instead of a separate PersistentVolumeClaim
* We used StatefulSet to run Jenkins


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Running Stateful Applications

```bash
# If EKS
JENKINS_ADDR=$(kubectl -n jenkins get ing jenkins \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# If GKE
JENKINS_ADDR=$(kubectl -n jenkins get ing jenkins \
    -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

open "http://$JENKINS_ADDR/jenkins"

kubectl delete ns jenkins
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Running Stateful Applications

* We did NOT observe any significant difference between running a single replica Jenkins as a StatefulSet when compared to Deployments
* We deleted the `jenkins` Namespace


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Using Deployments To Run Stateful Applications At Scale

```bash
cat sts/go-demo-3-deploy.yml

kubectl apply -f sts/go-demo-3-deploy.yml --record

kubectl -n go-demo-3 rollout status deployment api

kubectl -n go-demo-3 get pods
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Using Deployments To Run Stateful Applications At Scale

```bash
DB_1=$(kubectl -n go-demo-3 get pods -l app=db \
    -o jsonpath="{.items[0].metadata.name}")

DB_2=$(kubectl -n go-demo-3 get pods -l app=db \
    -o jsonpath="{.items[1].metadata.name}")
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Using Deployments To Run Stateful Applications At Scale

* We installed *go-demo-3* API and DB as Deployments with multiple replicas
* We retrieved the Pods and observed that all but one DB failed
* We retrieved names of two DB Pods


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Using Deployments To Run Stateful Applications At Scale

```bash
kubectl -n go-demo-3 logs $DB_1

kubectl -n go-demo-3 logs $DB_2

kubectl get pv

kubectl delete ns go-demo-3
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Using Deployments To Run Stateful Applications At Scale

* We observed from the logs that at least one DB Pod could not get a lock on the storage file
* We retrieved the PersistentVolumes and observed that only one was created for all three replicas of the DB
* We deleted the `go-demo-3` Namespace


<!-- .slide: data-background="img/sts-deployment.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Stateful Applications At Scale

```bash
cat sts/go-demo-3-sts.yml

kubectl apply -f sts/go-demo-3-sts.yml --record

kubectl -n go-demo-3 get pods

kubectl get pv
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Stateful Applications At Scale

* We installed *go-demo-3* with DB replicas defined as StatefulSet
* We retrieved the Pods and observed that DB Pods are created sequentially (and that API Pods are failing)
* We retrieved PersistentVolumes and observed that one was created for each StatefulSet Pod


<!-- .slide: data-background="img/sts.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Stateful Applications At Scale

```bash
kubectl -n go-demo-3 exec -it db-0 -- sh

mongo
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Stateful Applications At Scale

```bash
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


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Stateful Applications At Scale

* We entered into one of the DB Pods and created a MongoDB replica set


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Stateful Applications At Scale

```bash
exit

exit

kubectl -n go-demo-3 get pods
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Stateful Applications At Scale

* We retrieved the Pods and observed that API is not failing to connect to the DB any more


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Stateful Applications At Scale

```bash
diff sts/go-demo-3-sts.yml sts/go-demo-3-sts-upd.yml

kubectl apply -f sts/go-demo-3-sts-upd.yml --record

kubectl -n go-demo-3 get pods

kubectl delete ns go-demo-3
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Stateful Applications At Scale

* We updated the DB to the new image tag
* We observed that the Pods are updated in sequential order, from the last to the first
* We deleted the *go-demo-3* Namespace


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Sidecar Containers

```bash
cat sts/go-demo-3.yml

kubectl apply -f sts/go-demo-3.yml --record

# Wait for a few moments

kubectl -n go-demo-3 logs db-0 -c db-sidecar

kubectl delete ns go-demo-3
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Sidecar Containers

* We installed *go-demo-3* with DB StatefulSet containing a sidecar in charge of creating MongoDB replica set
* We retrieved the sidecar logs and observed that it is forbidden from listing the Pods
* We deleted the Namespace


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Sidecar Containers

```bash
cat sa/go-demo-3.yml

kubectl create -f sa/go-demo-3.yml --record --save-config

kubectl -n go-demo-3 get pods

kubectl -n go-demo-3 logs db-0 -c db-sidecar
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Sidecar Containers

* We created the DB StatefulSet attached to the ServiceAccount and provides the necessary permissions
* We observed that all the Pods were created
* We observed that sidecar logs do not show any issues


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## What Now?

```bash
kubectl delete ns go-demo-3
```
