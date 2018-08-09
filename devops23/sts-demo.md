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

```bash
kubectl -n go-demo-3 logs $DB_1

kubectl -n go-demo-3 logs $DB_2

kubectl get pv

kubectl delete ns go-demo-3
```


<!-- .slide: data-background="img/sts-deployment.png" data-background-size="contain" -->


## Using StatefulSets To Run Stateful Applications At Scale

---

```bash
cat sts/go-demo-3-sts.yml

kubectl apply -f sts/go-demo-3-sts.yml --record

kubectl -n go-demo-3 get pods

kubectl get pv
```


<!-- .slide: data-background="img/sts.png" data-background-size="contain" -->


## Using StatefulSets To Run Stateful Applications At Scale

---

```bash
kubectl -n go-demo-3 exec -it db-0 -- hostname

# If kops
kubectl -n go-demo-3 run -it --image busybox dns-test \
    --restart=Never --rm sh

# If kops
nslookup db

# If kops
nslookup db-0.db

# If kops
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

```bash
exit

exit

kubectl -n go-demo-3 get pods
```


## Using StatefulSets To Run Stateful Applications At Scale

---

```bash
diff sts/go-demo-3-sts.yml sts/go-demo-3-sts-upd.yml

kubectl apply -f sts/go-demo-3-sts-upd.yml --record

kubectl -n go-demo-3 get pods

kubectl delete ns go-demo-3
```


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

```bash
cat sa/go-demo-3.yml

kubectl create -f sa/go-demo-3.yml --record --save-config

kubectl -n go-demo-3 get pods

kubectl -n go-demo-3 logs db-0 -c db-sidecar
```


## What Now?

```bash
kubectl delete ns go-demo-3
```
