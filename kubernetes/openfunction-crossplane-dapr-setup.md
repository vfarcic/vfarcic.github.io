<!-- .slide: data-background="../img/background/hands-on.jpg" -->
## Hands-on Time

# Setup


## Setup

* The demo is based on AWS.
* Some commands and manifests might need to be modified to make it work in other providers.
* Make sure that Docker Desktop is up-and-running.
* Install [Nix](https://nix.dev/install-nix)


## Setup

```sh
git clone \
    https://github.com/vfarcic/crossplane-openfunction-dapr-demo

cd crossplane-openfunction-dapr-demo

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
```

* Wait until all the resources are `Available`.

```sh
crossplane beta trace sqlclaim my-db --namespace a-team
```

* Wait until all the resources are `Available`.


## Setup

```sh
export KUBECONFIG=$PWD/kubeconfig.yaml

aws eks update-kubeconfig --region us-east-1 \
    --name a-team-cluster --kubeconfig $KUBECONFIG

export INGRESS_HOSTNAME=$(kubectl --namespace projectcontour \
    get service contour-envoy \
    --output jsonpath="{.status.loadBalancer.ingress[0].hostname}")

export INGRESS_IP=$(dig +short $INGRESS_HOSTNAME \
    | awk '{print $1;}' | head -n 1)

echo $INGRESS_IP
```


## Setup

```sh
kubectl --namespace openfunction \
    patch gateway.networking.openfunction.io/openfunction \
    --type merge \
    --patch "{\"spec\": {\"domain\": \"$INGRESS_IP.nip.io\"}}"

unset KUBECONFIG
```