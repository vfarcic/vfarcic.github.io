<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Defining And Running Serverless Deployments

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12</div>
<div class="label">Hands-on Time</div>

## TESTED ONLY IN GKE


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12</div>
<div class="label">Hands-on Time</div>

## Installing Gloo and Knative

* [Install glooctl](https://docs.solo.io/gloo/latest/installation/knative/#install-command-line-tool-cli)

```bash
glooctl install knative --install-knative-version=0.9.0
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12</div>
<div class="label">Hands-on Time</div>

## Installing Gloo and Knative (!=EKS)

```bash
KNATIVE_IP=$(kubectl --namespace gloo-system \
    get service knative-external-proxy \
    --output jsonpath="{.status.loadBalancer.ingress[0].ip}")
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12</div>
<div class="label">Hands-on Time</div>

## Installing Gloo and Knative (EKS)

```bash
KNATIVE_HOST=$(kubectl \
    --namespace gloo-system \
    get service knative-external-proxy \
    --output jsonpath="{.status.loadBalancer.ingress[0].hostname}")

export KNATIVE_IP="$(dig +short $KNATIVE_HOST | tail -n 1)"
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12</div>
<div class="label">Hands-on Time</div>

## Installing Gloo and Knative

```bash
echo $KNATIVE_IP

echo "apiVersion: v1
kind: ConfigMap
metadata:
  name: config-domain
  namespace: knative-serving
data:
  $KNATIVE_IP.nip.io: \"\"" | kubectl apply --filename -

kubectl get namespaces
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12</div>
<div class="label">Hands-on Time</div>

## Installing Gloo and Knative

```bash
jx edit deploy --team --kind knative --batch-mode
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12</div>
<div class="label">Hands-on Time</div>

## New Serverless Application

```bash
jx create quickstart --filter golang-http --project-name jx-knative \
    --batch-mode

cd jx-knative

cat charts/jx-knative/values.yaml

ls -1 charts/jx-knative/templates

cat charts/jx-knative/templates/deployment.yaml

cat charts/jx-knative/templates/ksvc.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12</div>
<div class="label">Hands-on Time</div>

## New Serverless Application

```bash
jx get activities --filter jx-knative --watch

jx get activities --filter environment-$CLUSTER_NAME-staging/master --watch

kubectl --namespace $NAMESPACE-staging get pods

kubectl --namespace $NAMESPACE-staging get all
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12</div>
<div class="label">Hands-on Time</div>

## New Serverless Application

```bash
jx get applications --env staging

ADDR=$(kubectl --namespace $NAMESPACE-staging get ksvc jx-knative \
    --output jsonpath="{.status.url}")

echo $ADDR

curl "$ADDR"

kubectl --namespace $NAMESPACE-staging get pods
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12</div>
<div class="label">Hands-on Time</div>

## New Serverless Application

```bash
# Wait for a while

kubectl --namespace $NAMESPACE-staging get pods

kubectl --namespace knative-serving describe configmap config-autoscaler

kubectl --namespace $NAMESPACE-staging get pods
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12</div>
<div class="label">Hands-on Time</div>

## New Serverless Application

```bash
kubectl run siege --image yokogawa/siege --generator "run-pod/v1" \
    -it --rm -- --concurrent 300 --time 30S "$ADDR" \
    && kubectl --namespace $NAMESPACE-staging get pods

sed -e \
    's@revisionTemplate:@revisionTemplate:\
        metadata:\
          annotations:\
            autoscaling.knative.dev/target: "3"\
            autoscaling.knative.dev/maxScale: "5"@g' \
    -i charts/jx-knative/templates/ksvc.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12</div>
<div class="label">Hands-on Time</div>

## New Serverless Application

```bash
git add .

git commit -m "Added Knative target"

git push --set-upstream origin master

jx get activities --filter jx-knative --watch

jx get activities --filter environment-jx-rocks-staging/master --watch

curl "$ADDR/"
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12</div>
<div class="label">Hands-on Time</div>

## New Serverless Application

```bash
kubectl run siege --image yokogawa/siege --generator "run-pod/v1" \
    -it --rm -- --concurrent 400 --time 60S "$ADDR" \
    && kubectl --namespace $NAMESPACE-staging get pods \
    --selector serving.knative.dev/service=jx-knative

kubectl --namespace $NAMESPACE-staging get pods \
    --selector serving.knative.dev/service=jx-knative

kubectl --namespace $NAMESPACE-staging get pods \
    --selector serving.knative.dev/service=jx-knative
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12</div>
<div class="label">Hands-on Time</div>

## New Serverless Application

```bash
sed -e \
    's@autoscaling.knative.dev/target: "3"@autoscaling.knative.dev/target: "3"\
            autoscaling.knative.dev/minScale: "1"@g' \
    -i charts/jx-knative/templates/ksvc.yaml

git add .

git commit -m "Added Knative minScale"

git push
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12</div>
<div class="label">Hands-on Time</div>

## New Serverless Application

```bash
jx get activities --filter jx-knative --watch

jx get activities --filter environment-jx-rocks-staging/master --watch

kubectl --namespace jx-staging get pods \
    --selector serving.knative.dev/service=jx-knative

kubectl --namespace jx-staging get pods \
    --selector serving.knative.dev/service=jx-knative
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12</div>
<div class="label">Hands-on Time</div>

## Serverless With Pull Requests

```bash
git checkout -b serverless

echo "A silly change" | tee README.md

git add .

git commit -m "Made a silly change"

git push --set-upstream origin serverless

jx create pullrequest --title "A silly change" --body "What I can say?" \
    --batch-mode
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12</div>
<div class="label">Hands-on Time</div>

## Serverless With Pull Requests

```bash
BRANCH=[...] # e.g., `PR-1`

jx get activities --filter jx-knative/$BRANCH --watch

GH_USER=[...]

PR_NAMESPACE=$(echo jx-$GH_USER-jx-knative-$BRANCH \
  | tr '[:upper:]' '[:lower:]')

echo $PR_NAMESPACE

kubectl --namespace $PR_NAMESPACE get pods
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12</div>
<div class="label">Hands-on Time</div>

## Serverless With Pull Requests

```bash
PR_ADDR=$(kubectl --namespace $PR_NAMESPACE get ksvc jx-knative \
    --output jsonpath="{.status.url}")

echo $PR_ADDR

curl "$PR_ADDR"
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12</div>
<div class="label">Hands-on Time</div>

## Limiting Serverless To Pull Requests

```bash
cd ..

rm -rf environment-jx-rocks-staging

git clone https://github.com/$GH_USER/environment-jx-rocks-staging.git

cd environment-jx-rocks-staging

echo "jx-knative:
  knativeDeploy: false" | tee -a env/values.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12</div>
<div class="label">Hands-on Time</div>

## Limiting Serverless To Pull Requests

```bash
git add .

git commit -m "Removed Knative"

git pull

git push

cd ../jx-knative

git checkout master
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12</div>
<div class="label">Hands-on Time</div>

## Limiting Serverless To Pull Requests

```bash
echo "jx-knative rocks" | tee README.md

git add .

git commit -m "Removed Knative"

git pull

git push

jx get activities --filter jx-knative/master --watch
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12</div>
<div class="label">Hands-on Time</div>

## Limiting Serverless To Pull Requests

```bash
jx get activities --filter environment-jx-rocks-staging/master --watch

kubectl --namespace jx-staging get pods

kubectl --namespace jx-staging get all | grep jx-knative

ADDR=$(kubectl --namespace jx-staging get ing jx-knative \
    --output jsonpath="{.spec.rules[0].host}")

echo $ADDR

curl "http://$ADDR"
```
