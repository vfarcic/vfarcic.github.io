<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Creating A Jenkins X Cluster

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
export PROJECT=[...] # Replace `[...]` with the project ID

git clone https://github.com/vfarcic/terraform-gke.git

cd terraform-gke

git checkout jx-serverless-apps

git pull
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
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
gcloud container clusters \
    get-credentials $(terraform output cluster_name) \
    --project $(terraform output project_id) \
        --region $(terraform output region)

kubectl create clusterrolebinding \
    cluster-admin-binding \
    --clusterrole cluster-admin \
    --user $(gcloud config get-value account)

cd ..
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
git clone \
    https://github.com/jenkins-x/jenkins-x-boot-config.git \
    environment-$CLUSTER_NAME-dev

cd environment-$CLUSTER_NAME-dev

# Open `jx-requirements.yml` in an editor
# Set `cluster.clusterName` to `jx-demo`
# Set `cluster.environmentGitOwner`
# Set `cluster.project` to `jx-demo-276816`
# Set `cluster.zone` to `us-east1`
# Save & Exit
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
jx boot

cd ..
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
glooctl install knative --install-knative-version=0.9.0
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
KNATIVE_IP=$(kubectl --namespace gloo-system \
    get service knative-external-proxy \
    --output jsonpath="{.status.loadBalancer.ingress[0].ip}")

echo "apiVersion: v1
kind: ConfigMap
metadata:
  name: config-domain
  namespace: knative-serving
data:
  $KNATIVE_IP.nip.io: \"\"" \
    | kubectl apply --filename -
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
jx create quickstart --filter golang-http --project-name jx-knative \
    --deploy-kind knative --batch-mode

jx get activities --filter jx-knative --watch

jx get activities --filter environment-$CLUSTER_NAME-staging/master \
    --watch

ADDR=$(kubectl --namespace jx-staging get ksvc jx-knative \
    --output jsonpath="{.status.url}")

curl $ADDR
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
cd jx-knative

cat charts/jx-knative/templates/ksvc.yaml \
    | sed -e 's@revisionTemplate:@revisionTemplate:\
        metadata:\
          annotations:\
            autoscaling.knative.dev/maxScale: "5"@g' \
    | tee charts/jx-knative/templates/ksvc.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
git add . && git commit -m "Added Knative target"

git push --set-upstream origin master

jx get activities --filter jx-knative --watch

jx get activities --filter environment-$CLUSTER_NAME-staging/master \
    --watch

curl $ADDR
```
