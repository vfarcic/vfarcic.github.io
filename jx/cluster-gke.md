## Cleaning

---

```bash
open "https://hub.github.com/"

hub delete -y $GH_USER/environment-jx-rocks-staging

hub delete -y $GH_USER/environment-jx-rocks-production

rm -rf ~/.jx/environments/$GH_USER/environment-jx-rocks-*

rm -rf ../environment-jx-rocks-staging

rm -rf ../environment-jx-rocks-production

gcloud container clusters delete $NAME --zone $ZONE --quiet
```


## Creating A New Cluster

---

```bash
gcloud auth login

NAME=jx-rocks && REGION=us-east1 && MACHINE_TYPE=n1-standard-2

MIN_NODES=1 && MAX_NODES=3

gcloud container clusters create $NAME --region $REGION \
    --machine-type $MACHINE_TYPE --enable-autoscaling \
    --num-nodes 1 --max-nodes $MAX_NODES --min-nodes $MIN_NODES

kubectl create clusterrolebinding cluster-admin-binding \
    --clusterrole cluster-admin \
    --user $(gcloud config get-value account)
```


## Creating A New Cluster

---

```bash
kubectl apply -f \
    https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml

kubectl apply -f \
    https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml

kubectl apply --record \
    -f https://raw.githubusercontent.com/vfarcic/k8s-specs/master/helm/tiller-rbac.yml

helm init --service-account tiller

kubectl -n kube-system rollout status deploy tiller-deploy
```


## Creating A New Cluster

---

```bash
export LB_IP=$(kubectl -n ingress-nginx get svc ingress-nginx \
    -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

echo $LB_IP

# Repeat the `export` command if the output is empty
```


## Using An Existing Cluster

---

```bash
jx compliance run

jx compliance status

jx compliance results

jx compliance delete
```


## Installing jx

---

```bash
PASS=admin && JX_DOMAIN=jenkinx.$LB_IP.nip.io

ING_NS=ingress-nginx && ING_DEP=nginx-ingress-controller

TILLER_NS=kube-system

jx install --provider gke --external-ip $LB_IP \
    --domain $JX_DOMAIN --default-admin-password=$PASS \
    --ingress-namespace $ING_NS --ingress-deployment $ING_DEP \
    --tiller-namespace $TILLER_NS \
    --default-environment-prefix jx-rocks -b
```


## Installing jx

---

```bash
jx console

jx get activity -f environment-jx-rocks-staging -w

kubectl -n jx-staging get pods

kubectl -n jx get pods

kubectl get secrets
```
