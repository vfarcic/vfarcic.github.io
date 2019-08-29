<!-- .slide: class="center dark" -->
<!-- .slide: data-background="img/hands-on.jpg" -->
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

## In Case You Messed It Up

```bash
cd go-demo-6

git pull

# If GKE
BRANCH=knative-$NAMESPACE

# If NOT GKE
BRANCH=extension-model-$NAMESPACE
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## In Case You Messed It Up

```bash
git checkout $BRANCH

git merge -s ours master --no-edit

git checkout master

git merge $BRANCH

git push
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## In Case You Messed It Up (GKE Only)

```bash
cat charts/go-demo-6/Makefile | sed -e "s@vfarcic@$PROJECT@g" \
    | tee charts/go-demo-6/Makefile

cat charts/preview/Makefile | sed -e "s@vfarcic@$PROJECT@g" \
    | tee charts/preview/Makefile

cat skaffold.yaml | sed -e "s@vfarcic@$PROJECT@g" | tee skaffold.yaml

git add . && git commit -m "Fixed the project" && git push
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Serverless Strategy (GKE only)

```bash
cat charts/go-demo-6/templates/ksvc.yaml

jx get activities --filter go-demo-6 --watch

jx get activities --filter environment-tekton-staging/master --watch

kubectl --namespace $NAMESPACE-staging get pods

STAGING_ADDR=$(kubectl --namespace $NAMESPACE-staging get ksvc go-demo-6 \
    --output jsonpath="{.status.domain}")

curl "http://$STAGING_ADDR/demo/hello"
```


<!-- .slide: data-background="img/knative-request.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Serverless Strategy (GKE only)

* Wait for 5-10 minutes

```bash
kubectl \
    --namespace $NAMESPACE-staging \
    get pods
```


<!-- .slide: data-background="img/knative-scale-to-zero.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Serverless Strategy (GKE only)

```bash
kubectl run siege --image yokogawa/siege --generator "run-pod/v1" \
    -it --rm -- --concurrent 300 --time 20S \
    "http://$STAGING_ADDR/demo/hello" \
    && kubectl --namespace $NAMESPACE-staging get pods
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

cat charts/go-demo-6/values.yaml | grep knative
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Recreate Strategy

```bash
cat charts/go-demo-6/templates/deployment.yaml | sed -e \
    's@  replicas:@  strategy:\
    type: Recreate\
  replicas:@g' | tee charts/go-demo-6/templates/deployment.yaml

cat charts/go-demo-6/templates/deployment.yaml

git add . && git commit -m "Recreate strategy" && git push
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Recreate Strategy

```bash
jx get activities --filter go-demo-6/master --watch

jx get activities --filter environment-tekton-staging/master --watch

kubectl --namespace $NAMESPACE-staging get pods

kubectl --namespace $NAMESPACE-staging describe deployment jx-go-demo-6

kubectl --namespace $NAMESPACE-staging get ing
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Recreate Strategy

```bash
echo "something" | tee README.md

git add . && git commit -m "Recreate strategy" && git push

kubectl --namespace $NAMESPACE-staging get ing

cat main.go | sed -e "s@hello, PR@hello, recreate@g" | tee main.go

cat main_test.go | sed -e "s@hello, PR@hello, recreate@g" \
    | tee main_test.go

git add . && git commit -m "Recreate strategy" && git push
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Recreate Strategy

* Open a **second terminal**

```bash
# If EKS
export AWS_ACCESS_KEY_ID=[...]

# If EKS
export AWS_SECRET_ACCESS_KEY=[...]

# If EKS
export AWS_DEFAULT_REGION=us-west-2

jx get applications --env staging

STAGING_ADDR=[...]
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Recreate Strategy

* Go to the **second terminal**

```bash
while true
do
    curl "$STAGING_ADDR/demo/hello"
    sleep 0.2
done
```

* Go to the **first terminal**


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
cat charts/go-demo-6/templates/deployment.yaml | sed -e \
    's@type: Recreate@type: RollingUpdate@g' \
    | tee charts/go-demo-6/templates/deployment.yaml

cat main.go | sed -e "s@hello, recreate@hello, rolling update@g" \
    | tee main.go

cat main_test.go | sed -e "s@hello, recreate@hello, rolling update@g" \
    | tee main_test.go

git add . && git commit -m "Recreate strategy" && git push
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## RollingUpdate Strategy

* Go to the **second terminal**

```bash
while true
do
    curl "$STAGING_ADDR/demo/hello"
    sleep 0.2
done
```

* Go to the **first terminal**

```bash
kubectl --namespace $NAMESPACE-staging describe deployment jx-go-demo-6
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

## Blue-Green Strategy


<!-- .slide: data-background="img/blue-green.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Blue-Green Strategy

```bash
jx get applications --env staging

VERSION=[...]

jx promote go-demo-6 --version $VERSION --env production --batch-mode

jx get activities --filter environment-tekton-production/master --watch
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Blue-Green Strategy

```bash
jx get applications --env production

PRODUCTION_ADDR=[...]

curl "$PRODUCTION_ADDR/demo/hello"
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Istio, Prometheus, Flagger, Grafana

```bash
jx create addon istio --version 1.1.7

# If NOT EKS
ISTIO_IP=$(kubectl --namespace istio-system \
    get service istio-ingressgateway \
    --output jsonpath='{.status.loadBalancer.ingress[0].secondp}')

# If EKS
ISTIO_HOST=$(kubectl --namespace istio-system \
    get service istio-ingressgateway \
    --output jsonpath='{.status.loadBalancer.ingress[0].hostname}')
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Istio, Prometheus, Flagger, Grafana

```bash
# If EKS
export ISTIO_IP="$(dig +short $ISTIO_HOST | tail -n 1)"

echo $ISTIO_IP
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Istio, Prometheus, Flagger, Grafana

```bash
jx create addon flagger

kubectl --namespace istio-system get pods

kubectl describe namespace $NAMESPACE-production

kubectl describe namespace $NAMESPACE-staging

kubectl label namespace $NAMESPACE-staging istio-injection=enabled \
    --overwrite

kubectl describe namespace $NAMESPACE-staging
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Creating Canary Resources

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
" | tee charts/go-demo-6/templates/canary.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Creating Canary Resources

```bash
echo "
canary:
  enable: false
  provider: istio
  service:
    hosts:
    - go-demo-6.$ISTIO_IP.nip.io
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
" | tee -a charts/go-demo-6/values.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Creating Canary Resources

```bash
cat charts/go-demo-6/values.yaml | sed -e 's@go-demo-6-db:@go-demo-6-db:\
  podAnnotations:\
    sidecar.istio.io/inject: "false"@g' | tee charts/go-demo-6/values.yaml

cd ..

ENVIRONMENT=tekton

rm -rf environment-$ENVIRONMENT-staging
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Creating Canary Resources

```bash
GH_USER=[...]

git clone \
    https://github.com/$GH_USER/environment-$ENVIRONMENT-staging.git

cd environment-$ENVIRONMENT-staging
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Creating Canary Resources

```bash
STAGING_ADDR=staging.go-demo-6.$ISTIO_IP.nip.io

echo "go-demo-6:
  canary:
    enable: true
    service:
      hosts:
      - $STAGING_ADDR" \
    | tee -a env/values.yaml

git add . && git commit -m "Added progressive deployment" && git push
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Creating Canary Resources

```bash
cd ../go-demo-6

git add . && git commit -m "Added progressive deployment" &6 git push

jx get activities --filter go-demo-6/master --watch

jx get activities --filter environment-tekton-staging/master --watch
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Canary Strategy

```bash
curl $STAGING_ADDR/demo/hello

kubectl --namespace $NAMESPACE-staging get pods

kubectl --namespace $NAMESPACE-staging get canary

kubectl --namespace $NAMESPACE-staging \
    get virtualservice.networking.istio.io

kubectl --namespace istio-system logs --selector app.kubernetes.io/name=flagger
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Canary Strategy

```bash
cat main.go | sed -e "s@hello, rolling update@hello, progressive@g" \
    | tee main.go

cat main_test.go | sed -e "s@hello, rolling update@hello, progressive@g" \
    | tee main_test.go

git add . && git commit -m "Added progressive deployment" && git push

echo $STAGING_ADDR
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Canary Strategy

* Go to the **second terminal**

```bash
STAGING_ADDR=[...]

while true
do
    curl "$STAGING_ADDR/demo/hello"
    sleep 0.2
done
```

* Go to the **first terminal**


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Canary Strategy

```bash
kubectl --namespace $NAMESPACE-staging get pods

kubectl --namespace $NAMESPACE-staging \
    get virtualservice.networking.istio.io jx-go-demo-6 --output yaml

kubectl -n $NAMESPACE-staging get canary

kubectl --namespace $NAMESPACE-staging describe canary jx-go-demo-6
```


<!-- .slide: data-background="img/canary-rollout.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Rolling Back Canary Deployments

```bash
cat main.go | sed -e \
    "s@Everything is still OK@Everything is still OK with progressive delivery@g" \
    | tee main.go

cat main_test.go | sed -e \
    "s@Everything is still OK@Everything is still OK with progressive delivery@g" \
    | tee main_test.go

git add . && git commit -m "Added progressive deployment" && git push
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Rolling Back Canary Deployments

* Go to the **second terminal**

```bash
while true
do
    curl "$STAGING_ADDR/demo/random-error"
    sleep 0.2
done
```

* Go to the **first terminal**

```bash
kubectl \
    --namespace $NAMESPACE-staging \
    describe canary jx-go-demo-6
```


<!-- .slide: data-background="img/canary-rollback.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Rolling Back Canary Deployments

* Go to the **second terminal**
* Stop the loop
* Go to the **first terminal**


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## To Canary Or Not To Canary?

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
    -o jsonpath="{.status.loadBalancer.ingress[0].secondp}")

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
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 13</div>
<div class="label">Hands-on Time</div>

## Visualizing Canary Deployments

```bash
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

## Which Should We Choose?

* **Recreate**: when working with legacy applications that often do not scale, that are stateful without replication, and are lacking other features that make them not cloud-native.
* **Rolling update**: with cloud-native applications which, for one reason or another, cannot use canary deployments.
* **Canary**: instead of **rolling update** when you need the additional control when to roll forward and when to roll back.
* **Serverless**: in permanent environments when you need excellent scaling capabilities or when an application is not in constant use.
* **Serverless**: for all the deployments to preview environments, no matter which strategy you're using in staging and production.
