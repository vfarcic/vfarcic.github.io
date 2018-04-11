## Hands-On Time

---

# Deploying Stateful Applications At Scale


## Gist

---

[01-sts.sh](https://gist.github.com/505aedf2cb268837983132d4e4385fab) (https://bit.ly/2GUprBC)


## Creating A Cluster

---

```bash
git clone https://github.com/vfarcic/k8s-specs.git

cd k8s-specs

mkdir -p cluster

cd cluster

cat kops

source kops

export BUCKET_NAME=devops23-$(date +%s)

export KOPS_STATE_STORE=s3://$BUCKET_NAME
```


## Creating A Cluster

---

```bash
aws s3api create-bucket --bucket $BUCKET_NAME \
    --create-bucket-configuration \
    LocationConstraint=$AWS_DEFAULT_REGION

# Windows only
alias kops="docker run -it --rm -v $PWD/devops23.pub:/devops23.pub \
    -v $PWD/config:/config -e KUBECONFIG=/config/kubecfg.yaml \
    -e NAME=$NAME -e ZONES=$ZONES \
    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    -e KOPS_STATE_STORE=$KOPS_STATE_STORE \
    vfarcic/kops"
```


## Creating A Cluster

---

```bash
kops create cluster --name $NAME --zones $ZONES \
    --master-count 3 --master-size t2.small --master-zones $ZONES \
    --node-count 2 --node-size t2.medium --networking kubenet \
    --ssh-public-key devops23.pub --authorization RBAC --yes

kops validate cluster

# Windows only
kops export kubecfg --name ${NAME}

# Windows only
export KUBECONFIG=$PWD/config/kubecfg.yaml

kubectl create -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/ingress-nginx/v1.6.0.yaml

cd ..
```


## Using StatefulSets

---

```bash
cat sts/jenkins.yml

kubectl create -f sts/jenkins.yml --record --save-config

kubectl -n jenkins rollout status sts jenkins

kubectl -n jenkins get pvc

kubectl -n jenkins get pv

CLUSTER_DNS=$(kubectl -n jenkins get ing jenkins \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

open "http://$CLUSTER_DNS/jenkins"

kubectl delete ns jenkins
```


## Using Deployments At Scale

---

```bash
cat sts/go-demo-3-deploy.yml

kubectl create -f sts/go-demo-3-deploy.yml --record --save-config

kubectl -n go-demo-3 rollout status deployment api

kubectl -n go-demo-3 get pods
```


## Using Deployments At Scale

---

```bash
DB_1=$(kubectl -n go-demo-3 get pods -l app=db \
    -o jsonpath="{.items[0].metadata.name}")

DB_2=$(kubectl -n go-demo-3 get pods -l app=db \
    -o jsonpath="{.items[1].metadata.name}")

kubectl -n go-demo-3 logs $DB_1

kubectl -n go-demo-3 logs $DB_2

kubectl get pv

kubectl delete ns go-demo-3
```


<!-- .slide: data-background="img/sts-deployment.png" data-background-size="contain" -->


## Using StatefulSets At Scale

---

```bash
cat sts/go-demo-3-sts.yml

kubectl create -f sts/go-demo-3-sts.yml --record --save-config

kubectl -n go-demo-3 get pods

kubectl -n go-demo-3 get pods

kubectl -n go-demo-3 get pods

kubectl -n go-demo-3 get pods

kubectl get pv
```


<!-- .slide: data-background="img/sts.png" data-background-size="contain" -->


## Using StatefulSets At Scale

---

```bash
kubectl -n go-demo-3 exec -it db-0 -- hostname

kubectl -n go-demo-3 run -it --image busybox dns-test \
    --restart=Never --rm /bin/sh

nslookup db

nslookup db-0.db

exit
```


## Using StatefulSets At Scale

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

exit
```


## Using StatefulSets At Scale

---

```bash
exit

kubectl -n go-demo-3 get pods

diff sts/go-demo-3-sts.yml sts/go-demo-3-sts-upd.yml

kubectl apply -f sts/go-demo-3-sts-upd.yml --record

kubectl -n go-demo-3 get pods

kubectl delete ns go-demo-3
```


## Using Sidecar Containers

---

```bash
cat sts/go-demo-3.yml

kubectl create -f sts/go-demo-3.yml --record --save-config

kubectl -n go-demo-3 logs db-0 -c db-sidecar
```


## What Now?

---

```bash
kops delete cluster --name $NAME --yes

aws s3api delete-bucket --bucket $BUCKET_NAME
```

* [StatefulSet v1beta2 apps](https://v1-8.docs.kubernetes.io/docs/api-reference/v1.8/#statefulset-v1beta2-apps)
