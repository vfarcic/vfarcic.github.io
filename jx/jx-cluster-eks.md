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
* [AWS CLI](https://aws.amazon.com/cli/), [eksctl](https://github.com/weaveworks/eksctl), [aws-iam-authenticator](https://github.com/kubernetes-sigs/aws-iam-authenticator), and AWS admin permissions (if EKS)


## Creating A New Cluster

---

```bash
export AWS_ACCESS_KEY_ID=[...] # Replace [...]

AWS_SECRET_ACCESS_KEY=[...] # Replace [...]

AWS_DEFAULT_REGION=us-west-2 && NAME=jx-rocks

MACHINE_TYPE=t2.medium && MIN_NODES=3 && MAX_NODES=9

mkdir -p cluster

eksctl create cluster -n $NAME -r $AWS_DEFAULT_REGION \
    --kubeconfig cluster/kubecfg-eks --node-type $MACHINE_TYPE \
    --nodes $MIN_NODES --nodes-max $MAX_NODES --nodes-min $MIN_NODES
```


## Creating A New Cluster

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


## Creating A New Cluster

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

jx install --provider eks --external-ip $LB_IP \
    --domain $JX_DOMAIN --default-admin-password=$PASS \
    --ingress-namespace $ING_NS --ingress-deployment $ING_DEP \
    --tiller-namespace $TILLER_NS -b

jx console

kubectl -n jx get pods

kubectl get secrets
```
