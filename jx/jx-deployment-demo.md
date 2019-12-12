<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Choosing The Right Deployment Strategy

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## What Do We Expect From Deployments?

* fault-tolerant <!-- .element: class="fragment" -->
* highly available <!-- .element: class="fragment" -->
* responsive <!-- .element: class="fragment" -->
* rolling out progressively <!-- .element: class="fragment" -->
* rolling back in case of a failure <!-- .element: class="fragment" -->
* cost-effective <!-- .element: class="fragment" -->


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## The Setup

```bash
jx create quickstart --filter golang-http --project-name jx-progressive \
    --batch-mode
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Serverless Strategy (GKE only)

```bash
cd jx-progressive

cat charts/jx-progressive/templates/ksvc.yaml

jx get activities --filter jx-progressive --watch

jx get activities --filter environment-jx-rocks-staging/master --watch

kubectl --namespace jx-staging get pods
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Serverless Strategy (GKE only)

```bash
STAGING_ADDR=$(kubectl --namespace jx-staging get ksvc jx-progressive \
    --output jsonpath="{.status.url}")

curl "$STAGING_ADDR"
```


<!-- .slide: data-background="img/knative-request.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Serverless Strategy (GKE only)

```bash
kubectl --namespace jx-staging get pods
```


<!-- .slide: data-background="img/knative-scale-to-zero.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Serverless Strategy (GKE only)

```bash
kubectl run siege --image yokogawa/siege --generator "run-pod/v1" \
    -it --rm -- --concurrent 300 --time 30S "$STAGING_ADDR" \
    && kubectl --namespace jx-staging get pods
```


<!-- .slide: data-background="img/knative-scale-to-three.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Serverless Strategy (GKE only)

|Requirement        |Fullfilled|
|-------------------|----------|
|High-availability  |Fully     |
|Responsiveness     |Partly    |
|Progressive rollout|Partly    |
|Rollback           |Not       |
|Cost-effectiveness |Fully     |


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Serverless Strategy (GKE only)

```bash
jx edit deploy --kind default --batch-mode

cat charts/jx-progressive/values.yaml | grep knative

cd ..
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Recreate Strategy

```bash
cd jx-progressive

cat charts/jx-progressive/values.yaml | sed -e \
    's@replicaCount: 1@replicaCount: 3@g' \
    | tee charts/jx-progressive/values.yaml

cat charts/jx-progressive/templates/deployment.yaml | sed -e \
    's@  replicas:@  strategy:\
    type: Recreate\
  replicas:@g' \
    | tee charts/jx-progressive/templates/deployment.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Recreate Strategy

```bash
cat charts/jx-progressive/templates/deployment.yaml

git add .

git commit -m "Recreate strategy"

git push --set-upstream origin master

jx get activities --filter jx-progressive/master --watch

jx get activities --filter environment-jx-rocks-staging/master --watch
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Recreate Strategy

```bash
kubectl --namespace $NAMESPACE-staging get pods

kubectl --namespace $NAMESPACE-staging describe deployment jx-jx-progressive

kubectl --namespace $NAMESPACE-staging get ing

echo "something" | tee README.md
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Recreate Strategy

```bash
git add .

git commit -m "Recreate strategy"

git push

kubectl --namespace jx-staging get ing

cat main.go | sed -e "s@example@recreate@g" | tee main.go
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Recreate Strategy

```bash
git add .

git commit -m "Recreate strategy"

git push
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Recreate Strategy

```bash
# Go to the second terminal session

# If EKS
export AWS_ACCESS_KEY_ID=[...]

# If EKS
export AWS_SECRET_ACCESS_KEY=[...]

# If EKS
export AWS_DEFAULT_REGION=us-east-1
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Recreate Strategy

```bash
jx get applications --env staging

STAGING_ADDR=[...]

while true
do
    curl "$STAGING_ADDR"
    sleep 0.2
done

# Stop and go to the first terminal session
```


<!-- .slide: data-background="img/recreate.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Recreate Strategy

|Requirement        |Fulfilled|
|-------------------|----------|
|High-availability  |Not       |
|Responsiveness     |Not       |
|Progressive rollout|Not       |
|Rollback           |Not       |
|Cost-effectiveness |Not       |


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## RollingUpdate Strategy

```bash
cat charts/jx-progressive/templates/deployment.yaml | sed -e \
    's@type: Recreate@type: RollingUpdate@g' \
    | tee charts/jx-progressive/templates/deployment.yaml

cat main.go | sed -e "s@recreate@rolling update@g" | tee main.go

git add .

git commit -m "Recreate strategy"

git push
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## RollingUpdate Strategy

```bash
# Go to the second terminal session

while true
do
    curl "$STAGING_ADDR"
    sleep 0.2
done

# Stop and go to the first terminal session

kubectl --namespace jx-staging describe deployment jx-jx-progressive
```


<!-- .slide: data-background="img/rolling-update.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## RollingUpdate Strategy

|Requirement        |Fulfilled|
|-------------------|----------|
|High-availability  |Fully     |
|Responsiveness     |Fully     |
|Progressive rollout|Partly    |
|Rollback           |Not       |
|Cost-effectiveness |Partly    |


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Blue-Green Deployments


<!-- .slide: data-background="img/blue-green.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Blue-Green Deployments

```bash
jx get applications --env staging

VERSION=[...]

jx promote jx-progressive --version $VERSION --env production --batch-mode

jx get activities --filter environment-jx-rocks-production/master --watch
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Blue-Green Deployments

```bash
jx get applications --env production

PRODUCTION_ADDR=[...]

curl "$PRODUCTION_ADDR"
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Istio, Prometheus, Flagger, And Grafana

```bash
jx create addon istio

# If NOT EKS
ISTIO_IP=$(kubectl --namespace istio-system \
    get service istio-ingressgateway \
    --output jsonpath='{.status.loadBalancer.ingress[0].ip}')
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Istio, Prometheus, Flagger, And Grafana

```bash
# If EKS
ISTIO_HOST=$(kubectl --namespace istio-system \
    get service istio-ingressgateway \
    --output jsonpath='{.status.loadBalancer.ingress[0].hostname}')

# If EKS
export ISTIO_IP="$(dig +short $ISTIO_HOST | tail -n 1)"

echo $ISTIO_IP

jx create addon flagger
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Istio, Prometheus, Flagger, And Grafana

```bash
kubectl --namespace istio-system get pods

kubectl describe namespace $NAMESPACE-production

kubectl describe namespace $NAMESPACE-staging

kubectl label namespace $NAMESPACE-staging istio-injection=enabled --overwrite

kubectl describe namespace $NAMESPACE-staging
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Canary Resources With Flagger

```bash
echo "{{- if .Values.canary.enable }}
apiVersion: flagger.app/v1alpha2
kind: Canary
metadata:
  name: {{ template \"fullname\" . }}
spec:
  provider: {{.Values.canary.provider}}
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ template \"fullname\" . }}
  progressDeadlineSeconds: 60
  service:
    port: {{.Values.service.internalPort}}
{{- if .Values.canary.service.gateways }}
    gateways:
{{ toYaml .Values.canary.service.gateways | indent 4 }}
{{- end }}
{{- if .Values.canary.service.hosts }}
    hosts:
{{ toYaml .Values.canary.service.hosts | indent 4 }}
{{- end }}
  canaryAnalysis:
    interval: {{ .Values.canary.canaryAnalysis.interval }}
    threshold: {{ .Values.canary.canaryAnalysis.threshold }}
    maxWeight: {{ .Values.canary.canaryAnalysis.maxWeight }}
    stepWeight: {{ .Values.canary.canaryAnalysis.stepWeight }}
{{- if .Values.canary.canaryAnalysis.metrics }}
    metrics:
{{ toYaml .Values.canary.canaryAnalysis.metrics | indent 4 }}
{{- end }}
{{- end }}
" | tee charts/jx-progressive/templates/canary.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Canary Resources With Flagger

```bash
echo "
canary:
  enable: false
  provider: istio
  service:
    hosts:
    - jx-progressive.$ISTIO_IP.nip.io
    gateways:
    - jx-gateway.istio-system.svc.cluster.local
  canaryAnalysis:
    interval: 30s
    threshold: 5
    maxWeight: 70
    stepWeight: 20
    metrics:
    - name: request-success-rate
      threshold: 99
      interval: 120s
    - name: request-duration
      threshold: 500
      interval: 120s
" | tee -a charts/jx-progressive/values.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Canary Resources With Flagger

```bash
cd ..

rm -rf environment-jx-rocks-staging

GH_USER=[...]

git clone https://github.com/$GH_USER/environment-jx-rocks-staging.git

cd environment-jx-rocks-staging

STAGING_ADDR=staging.jx-progressive.$ISTIO_IP.nip.io
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Canary Resources With Flagger

```bash
echo "jx-progressive:
  canary:
    enable: true
    service:
      hosts:
      - $STAGING_ADDR" | tee -a env/values.yaml

git add .

git commit -m "Added progressive deployment"

git push
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Canary Resources With Flagger

```bash
cd ../jx-progressive

git add .

git commit -m "Added progressive deployment"

git push

jx get activities --filter jx-progressive/master --watch

jx get activities --filter environment-jx-rocks-staging/master --watch
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Canary Strategy

```bash
curl $STAGING_ADDR/demo/hello

kubectl --namespace $NAMESPACE-staging get pods

kubectl --namespace $NAMESPACE-staging get canary

kubectl --namespace $NAMESPACE-staging get virtualservices.networking.istio.io

kubectl --namespace istio-system logs \
    --selector app.kubernetes.io/name=flagger

cat main.go | sed -e "s@rolling update@progressive@g" | tee main.go
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Canary Strategy

```bash
git add .

git commit -m "Added progressive deployment"

git push

echo $STAGING_ADDR
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Canary Strategy

```bash
# Go to the second terminal

STAGING_ADDR=[...]

while true
do
    curl "$STAGING_ADDR"
    sleep 0.2
done

# Go to the fist terminal
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Canary Strategy

```bash
kubectl --namespace $NAMESPACE-staging get pods

kubectl --namespace $NAMESPACE-staging get virtualservice.networking.istio.io \
    jx-jx-progressive --output yaml

kubectl --namespace $NAMESPACE-staging get canary

kubectl --namespace $NAMESPACE-staging describe canary jx-jx-progressive
```


<!-- .slide: data-background="img/canary-rollout.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Canary Strategy

|Requirement        |Fullfilled|
|-------------------|----------|
|High-availability  |Fully     |
|Responsiveness     |Fully     |
|Progressive rollout|Fully     |
|Rollback           |Fully     |
|Cost-effectiveness |Not       |


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Visualizing Canary Deployments

```bash
# If NOT EKS
LB_IP=$(kubectl --namespace kube-system \
    get svc jxing-nginx-ingress-controller \
    -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

# If EKS
LB_HOST=$(kubectl --namespace kube-system \
    get svc jxing-nginx-ingress-controller \
    --output jsonpath='{.status.loadBalancer.ingress[0].hostname}')

# If EKS
export LB_IP="$(dig +short $LB_HOST | tail -n 1)"
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Visualizing Canary Deployments

```bash
echo $LB_IP

echo "apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx
  name: flagger-grafana
  namespace: istio-system
spec:
  rules:
  - host: flagger-grafana.$LB_IP.nip.io
    http:
      paths:
      - backend:
          serviceName: flagger-grafana
          servicePort: 80
" | kubectl create -f -
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Visualizing Canary Deployments

```bash
open "http://flagger-grafana.$LB_IP.nip.io"
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Which Strategy Should We Choose?

Use the **recreate** strategy when working with legacy applications that often do not scale, that are stateful without replication, and are lacking other features that make them not cloud-native.


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Which Strategy Should We Choose?

Use the **rolling update** strategy with cloud-native applications which, for one reason or another, cannot use canary deployments.


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Which Strategy Should We Choose?

Use the **canary** strategy instead of **rolling update** when you need the additional control when to roll forward and when to roll back.


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Which Strategy Should We Choose?

Use **serverless** deployments in permanent environments when you need excellent scaling capabilities or when an application is not in constant use.

Finally, use **serverless** for all the deployments to preview environments, no matter which strategy you're using in staging and production.
