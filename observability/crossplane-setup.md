<!-- .slide: data-background="../img/background/hands-on.jpg" -->
## Hands-on Time

# Setup


## Setup

```sh
git clone \
    https://github.com/vfarcic/crossplane-observability-demo

cd crossplane-observability-demo

# Watch https://youtu.be/0ulldVwZiKA if you are not familiar
#   with Nix

nix-shell --run $SHELL

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

export KUBECONFIG=$PWD/kubeconfig.yaml

aws eks update-kubeconfig --region us-east-1 \
    --name a-team-cluster --kubeconfig $KUBECONFIG
```


## Setup

```sh
helm upgrade --install dynatrace-operator \
    oci://docker.io/dynatrace/dynatrace-operator \
    --set installCRD=true --set csidriver.enabled=true \
    --atomic --create-namespace --namespace dynatrace --wait

kubectl --namespace dynatrace \
    create secret generic app \
    --from-literal=apiToken=$DYNATRACE_OPERATOR_TOKEN \
    --from-literal=dataIngestToken=$DYNATRACE_DATA_INGEST_TOKEN

kubectl --namespace dynatrace apply \
    --filename observability/dynatrace/dynakube-app.yaml

unset KUBECONFIG
```


## Setup

```sh
export INGRESS_HOSTNAME=$(kubectl --namespace traefik \
    get service traefik \
    --output jsonpath="{.status.loadBalancer.ingress[0].hostname}")

export INGRESS_IP=$(dig +short $INGRESS_HOSTNAME \
    | awk '{print $1;}' | head -n 1)

yq --inplace \
    ".spec.rules[0].host = \"sillydemo.$INGRESS_IP.nip.io\"" \
    app/ingress.yaml
```
