<!-- .slide: data-background="../img/background/hands-on.jpg" -->
## Hands-on Time

# Apps And Infra


## Setup

```bash
# If AWS
export CLUSTER_TYPE=eks

# If Azure
export CLUSTER_TYPE=aks

# If Google Cloud
export CLUSTER_TYPE=gke

kubectl apply --filename crossplane-config/config-k8s.yaml

kubectl --namespace a-team apply \
    --filename examples/k8s/$PROVIDER-$CLUSTER_TYPE.yaml
```


## Setup

```bash
kubectl --namespace a-team get clusterclaims

# Wait until it is `READY`

# If Google
KUBECONFIG=$PWD/kubeconfig.yaml gcloud container clusters \
    get-credentials a-team-gke --project $PROJECT_ID \
    --region us-east1

# If NOT Google
./examples/k8s/get-kubeconfig-$CLUSTER_TYPE.sh
```


## LB IP

```bash
# If AWS
export INGRESS_HOSTNAME=$(kubectl --kubeconfig kubeconfig.yaml \
    --namespace ingress-nginx get service \
    a-team-eks-ingress-ingress-nginx-controller \
    --output jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# If AWS
export INGRESS_HOST=$(dig +short $INGRESS_HOSTNAME)

# If Google
export INGRESS_HOST=$(kubectl --kubeconfig kubeconfig.yaml \
    --namespace ingress-nginx get service \
    a-team-gke-ingress-ingress-nginx-controller \
    --output jsonpath="{.status.loadBalancer.ingress[0].ip}")
```


## LB IP

```bash
# If Azure
export INGRESS_HOST=$(kubectl --kubeconfig kubeconfig.yaml \
    --namespace ingress-nginx get service \
    ateamaks-ingress-ingress-nginx-controller \
    --output jsonpath="{.status.loadBalancer.ingress[0].ip}")

echo $INGRESS_HOST

# If there are multiple IPs, replace the value with only one of them

yq --inplace \
    ".spec.parameters.host = \"silly-demo.$INGRESS_HOST.nip.io\"" \
    examples/app/backend-prod.yaml
```


## Create A Stateless App

```bash
kubectl --kubeconfig kubeconfig.yaml get pkgrev

cat examples/app/backend-prod.yaml

kubectl --kubeconfig kubeconfig.yaml --namespace production \
    apply --filename examples/app/backend-prod.yaml
```


## Explore Configurations

```bash
cat packages/app/definition.yaml

ls -1 packages/app/

cat packages/app/backend-prod.yaml

cat packages/app/crossplane.yaml

cat packages/app/README.md

cat crossplane-config/config-app.yaml

# Open https://marketplace.upbound.io/configurations/devops-toolkit/dot-application
```


## Explore Configurations

```bash
kubectl --kubeconfig kubeconfig.yaml get crds \
    | grep devopstoolkitseries.com

kubectl --kubeconfig kubeconfig.yaml explain appclaim \
    --recursive
```


## Query Resources

```bash
kubectl --kubeconfig kubeconfig.yaml --namespace production \
    get all,ingresses

curl "http://silly-demo.$INGRESS_HOST.nip.io"

kubectl --kubeconfig kubeconfig.yaml --namespace production \
    get appclaims

kubectl --kubeconfig kubeconfig.yaml get apps

kubectl --kubeconfig kubeconfig.yaml get managed
```


## Delete The Stateless App

```bash
kubectl --kubeconfig kubeconfig.yaml --namespace production \
    delete --filename examples/app/backend-prod.yaml

kubectl --kubeconfig kubeconfig.yaml --namespace production \
    get all,appclaims
```


## Credentials

```bash
# If AWS
kubectl --kubeconfig kubeconfig.yaml \
     --namespace crossplane-system create secret generic \
    $PROVIDER-creds --from-file creds=./$PROVIDER-creds.conf

# If Google or Azure
kubectl --kubeconfig kubeconfig.yaml \
     --namespace crossplane-system create secret generic \
    $PROVIDER-creds --from-file creds=./$PROVIDER-creds.json

# If Google
kubectl --kubeconfig kubeconfig.yaml apply \
    --filename crossplane-config/provider-config-$PROVIDER.yaml
```


## LB IP

```bash
yq --inplace \
    "select(document_index == 0).spec.parameters.host = \"silly-demo.$INGRESS_HOST.nip.io\"" \
    examples/app/backend-$PROVIDER-postgresql.yaml
```


## Create A Stateful App

```bash
# If Azure
kubectl --kubeconfig kubeconfig.yaml \
    --namespace crossplane-system create secret generic \
    silly-demo-creds --from-literal "password=9jPD02g#fjWZ"

cat examples/app/backend-$PROVIDER-postgresql.yaml

kubectl --kubeconfig kubeconfig.yaml --namespace production \
    apply \
    --filename examples/app/backend-$PROVIDER-postgresql.yaml
```


## Query Resources

```bash
kubectl --kubeconfig kubeconfig.yaml --namespace production \
    get pods

kubectl --kubeconfig kubeconfig.yaml --namespace production \
    get appclaims,sqlclaims

kubectl --kubeconfig kubeconfig.yaml get apps,sqls

kubectl --kubeconfig kubeconfig.yaml get managed

kubectl --kubeconfig kubeconfig.yaml --namespace production \
    get all,ingresses
```


## Delete The Stateful App

```bash
kubectl --kubeconfig kubeconfig.yaml --namespace production \
    delete \
    --filename examples/app/backend-$PROVIDER-postgresql.yaml

kubectl --kubeconfig kubeconfig.yaml --namespace production \
    get all,sqlclaims,appclaims

kubectl --kubeconfig kubeconfig.yaml get managed

kubectl --kubeconfig kubeconfig.yaml --namespace production \
    get all
```
