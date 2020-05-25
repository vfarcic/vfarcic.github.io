<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Setup

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
export GH_USER=[...] # Replace `[...]` with your GitHub user

export PROJECT_ID=[...] # Replace `[...]` with the project ID

export REGION=us-east1

git clone https://github.com/vfarcic/terraform-gke.git

cd terraform-gke

git checkout testing-production
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
git pull

# Create a service account (https://console.cloud.google.com/apis/credentials/serviceaccountkey)

# Download the JSON and store it as account.json in this directory

terraform apply

export CLUSTER_NAME=$(terraform output cluster_name)

export KUBECONFIG=$PWD/kubeconfig
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
cd ..

git clone \
    https://github.com/jenkins-x/jenkins-x-boot-config.git \
    environment-$CLUSTER_NAME-dev

cd environment-$CLUSTER_NAME-dev
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
cat jx-requirements.yml \
    | sed -e "s@clusterName: \"\"@clusterName: \"$CLUSTER_NAME\"@g" \
    | sed -e "s@environmentGitOwner: \"\"@environmentGitOwner: \"$GH_USER\"@g" \
    | sed -e "s@project: \"\"@project: \"$PROJECT_ID\"@g" \
    | sed -e "s@zone: \"\"@zone: \"$REGION\"@g" \
    | tee jx-requirements.yml

jx boot

cd ..
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
istioctl manifest apply --skip-confirmation

kubectl apply \
    --kustomize github.com/weaveworks/flagger/kustomize/istio

jx create quickstart --filter golang-http --project-name my-app \
    --name my-app

jx get activity --filter my-app --watch
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
kubectl label namespace jx-production istio-injection=enabled --overwrite

export ISTIO_IP=$(kubectl --namespace istio-system \
    get service istio-ingressgateway \
    --output jsonpath='{.status.loadBalancer.ingress[0].ip}')

export APP_ADDR=my-app.$ISTIO_IP.nip.io

jx get activity --filter environment-$CLUSTER_NAME-staging/master --watch
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
git clone https://github.com/$GH_USER/environment-$CLUSTER_NAME-production.git

cd environment-$CLUSTER_NAME-production

echo "my-app:
  hpa:
    enabled: true
    minReplicas: 5
  canary:
    enabled: true
    host: $APP_ADDR
" | tee -a env/values.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
git add . && git commit -m "Progressive deployment" && git push

jx get applications --env staging

export VERSION=[...]

jx promote my-app --version $VERSION --env production

jx get activity --filter environment-$CLUSTER_NAME-production/master \
    --watch

kubectl -n jx-production get canaries
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
curl $APP_ADDR

cd ../my-app

cat main.go | sed -e "s@Jenkins X golang http example@Something else@g" \
    | tee main.go

git add . && git commit -m "Progressive deployment" && git push
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
jx get activity --filter my-app --watch

jx get activity --filter environment-$CLUSTER_NAME-staging/master \
    --watch

jx get applications

export VERSION=[...]
```
