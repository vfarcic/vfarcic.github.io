## Hands-On Time

---

### Creating A
# Jenkins-X
## Cluster


<!-- .slide: data-background="../img/background/why.jpg" -->
### How long does it take to create a
## fully operational 
## and secure cluster,
## that is fault tollerant,
# with autoscaling,
## and with all the
## CD software pre-installed?


## Prerequisites

---

* [Git](https://git-scm.com/)
* GitBash (if Windows)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [Helm](https://helm.sh/)
* [gcloud CLI](https://cloud.google.com/sdk/docs/quickstarts), and GCP admin permissions (if GKE)
* [AWS CLI](https://aws.amazon.com/cli/), [eksctl](https://github.com/weaveworks/eksctl), [aws-iam-authenticator](https://github.com/kubernetes-sigs/aws-iam-authenticator), and AWS admin permissions (if EKS)


## Creating A Cluster With jx (GKE)

---

```bash
PROJECT=[...] # e.g. devops24-book

NAME=jx-rocks && ZONE=us-east1-b && MACHINE=n1-standard-2

MIN_NODES=3 && MAX_NODES=5 && PASS=admin

jx create cluster gke -n $NAME -p $PROJECT -z $ZONE -m $MACHINE \
    --min-num-nodes $MIN_NODES --max-num-nodes $MAX_NODES \
    --default-admin-password=$PASS -b

jx console

gcloud container clusters delete $NAME --zone $ZONE --quiet
```


## Creating A New Cluster (GKE)

---

```bash
PROVIDER=gke

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


## Creating A New Cluster (GKE)

---

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml

kubectl apply --record \
    -f https://raw.githubusercontent.com/vfarcic/k8s-specs/master/helm/tiller-rbac.yml \

helm init --service-account tiller

kubectl -n kube-system rollout status deploy tiller-deploy
```


## Creating A New Cluster (GKE)

---

```bash
export LB_IP=$(kubectl -n ingress-nginx get svc ingress-nginx \
    -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

echo $LB_IP

# Repeat the `export` command if the output is empty
```


## Creating A New Cluster (EKS)

---

```bash
PROVIDER=eks

export AWS_ACCESS_KEY_ID=[...] # Replace [...]

AWS_SECRET_ACCESS_KEY=[...] # Replace [...]

AWS_DEFAULT_REGION=us-west-2 && NAME=jx-rocks

MACHINE_TYPE=t2.medium && MIN_NODES=3 && MAX_NODES=9

mkdir -p cluster

eksctl create cluster -n $NAME -r $AWS_DEFAULT_REGION \
    --kubeconfig cluster/kubecfg-eks --node-type $MACHINE_TYPE \
    --nodes $MIN_NODES --nodes-max $MAX_NODES --nodes-min $MIN_NODES
```


## Creating A New Cluster (EKS)

---

```bash
export KUBECONFIG=$PWD/cluster/kubecfg-eks

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/aws/service-l4.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/aws/patch-configmap-l4.yaml

kubectl apply -f https://raw.githubusercontent.com/vfarcic/k8s-specs/master/helm/tiller-rbac.yml

helm init --service-account tiller

kubectl -n kube-system rollout status deploy tiller-deploy
```


## Creating A New Cluster (EKS)

---

```bash
LB_HOST=$(kubectl -n ingress-nginx get svc ingress-nginx \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

export LB_IP="$(dig +short $LB_HOST | tail -n 1)"

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

jx install --provider $PROVIDER --external-ip $LB_IP \
    --domain $JX_DOMAIN --default-admin-password=$PASS \
    --ingress-namespace $ING_NS --ingress-deployment $ING_DEP \
    --tiller-namespace $TILLER_NS -b

jx console
```
