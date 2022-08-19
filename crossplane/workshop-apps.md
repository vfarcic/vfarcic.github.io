<!-- .slide: data-background="../img/background/hands-on.jpg" -->
## Hands-on Time

# Apps And Infra


## LB IP

```bash
# If AWS
export INGRESS_HOSTNAME=$(kubectl --kubeconfig kubeconfig.yaml \
    --namespace ingress-nginx get service \
    a-team-eks-ingress-ingress-nginx-controller \
    --output jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# If AWS
export INGRESS_HOST=$(dig +short $INGRESS_HOSTNAME)

echo $INGRESS_HOST

# If there are multiple IPs, replace the value with only one of them
```


## LB IP

```bash
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

kubectl --kubeconfig kubeconfig.yaml explain appclaim --recursive
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
kubectl --kubeconfig kubeconfig.yaml\
     --namespace crossplane-system create secret generic \
    aws-creds --from-file creds=./aws-creds.conf

# If AWS
kubectl --kubeconfig kubeconfig.yaml apply \
    --filename crossplane-config/provider-config-aws.yaml
```


## LB IP

```bash
yq --inplace \
    "select(document_index == 0).spec.parameters.host = \"silly-demo.$INGRESS_HOST.nip.io\"" \
    examples/app/backend-$PROVIDER-postgresql.yaml
```


## Create A Stateful App

```bash
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
