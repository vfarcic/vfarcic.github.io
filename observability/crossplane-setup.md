<!-- .slide: data-background="../img/background/hands-on.jpg" -->
## Hands-on Time

# Setup


## Setup

```sh
git clone \
    https://github.com/vfarcic/crossplane-observability-demo

cd crossplane-observability-demo

devbox shell

chmod +x setup.sh

./setup.sh

source .env
```


## Setup

```sh
kubectl --namespace a-team apply --filename cluster/aws.yaml

kubectl --namespace a-team apply --filename db/aws.yaml

crossplane beta trace clusterclaim cluster --namespace a-team

# Wait until all the resources are available

crossplane beta trace sqlclaim my-db --namespace a-team

# Wait until all the resources are available
```


## Setup

```sh
export KUBECONFIG=$PWD/kubeconfig.yaml

aws eks update-kubeconfig --region us-east-1 \
    --name a-team-cluster --kubeconfig $KUBECONFIG

export INGRESS_HOSTNAME=$(kubectl --namespace traefik \
    get service traefik \
    --output jsonpath="{.status.loadBalancer.ingress[0].hostname}")

export INGRESS_IP=$(dig +short $INGRESS_HOSTNAME \
    | awk '{print $1;}' | head -n 1)
```


## Setup

```sh
yq --inplace \
    ".spec.rules[0].host = \"sillydemo.$INGRESS_IP.nip.io\"" \
    app/ingress.yaml

unset KUBECONFIG
```
