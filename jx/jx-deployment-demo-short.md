<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Choosing The Right Deployment Strategy

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## What Do We Expect From Deployments?

* fault-tolerant <!-- .element: class="fragment" -->
* highly available <!-- .element: class="fragment" -->
* responsive <!-- .element: class="fragment" -->
* rolling out progressively <!-- .element: class="fragment" -->
* rolling back in case of a failure <!-- .element: class="fragment" -->
* cost-effective <!-- .element: class="fragment" -->


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Serverless Strategy


<!-- .slide: data-background="img/knative-request.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Serverless Strategy

```bash
kubectl --namespace jx-staging get ksvc jx-knative --output yaml

kubectl --namespace jx-staging get pods | grep knative
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Serverless Strategy

```bash
export KNATIVE_ADDR=$(kubectl --namespace jx-staging \
    get ksvc jx-knative --output jsonpath="{.status.url}")

kubectl run siege --image yokogawa/siege --generator "run-pod/v1" \
    -it --rm -- --concurrent 300 --time 30S "$KNATIVE_ADDR" \
    && kubectl --namespace jx-staging get pods | grep knative
```


<!-- .slide: data-background="img/knative-scale-to-zero.png" data-background-size="contain" -->


<!-- .slide: data-background="img/knative-scale-to-three.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Serverless Strategy

|Requirement        |Fullfilled|
|-------------------|----------|
|High-availability  |Fully     |
|Responsiveness     |Partly    |
|Progressive rollout|Partly    |
|Rollback           |Not       |
|Cost-effectiveness |Fully     |


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Recreate Strategy

```bash
cd jx-recreate

kubectl --namespace jx-staging get pods --selector app=jx-jx-recreate

sed -e "s@example@recreate@g" -i main.go

git add . && git commit -m "Recreate strategy" && git push

cd ..
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Recreate Strategy

* Open a **second terminal**

```bash
export KUBECONFIG=$PWD/terraform-gke/kubeconfig

RECREATE_ADDR=$(kubectl --namespace jx-staging get ing jx-recreate \
    --output jsonpath="{.spec.rules[0].host}")

while true; do
    curl "$RECREATE_ADDR"
    sleep 0.5
done
```

* Go to the **first terminal**


<!-- .slide: data-background="img/recreate.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
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
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Rolling Update Strategy

```bash
cd jx-rolling

sed -e "s@example@rolling update@g" -i main.go

git add . && git commit -m "Rolling update" && git push

cd ..
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Rolling Update Strategy

* Go to the **second terminal**

```bash
ROLLING_ADDR=$(kubectl --namespace jx-staging get ing jx-rolling \
    --output jsonpath="{.spec.rules[0].host}")

while true; do
    curl "$ROLLING_ADDR"
    sleep 0.5
done
```

* Go to the **first terminal**


<!-- .slide: data-background="img/rolling-update.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
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
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Blue-Green Strategy


<!-- .slide: data-background="img/blue-green.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Canary Strategy

```bash
cd jx-canary

sed -e "s@example@canary@g" -i main.go

git add . && git commit -m "Canary"

git push --set-upstream origin master

cd ..
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Canary Strategy

* Go to the **second terminal**

```bash
CANARY_IP=$(kubectl --namespace istio-system \
    get service istio-ingressgateway \
    --output jsonpath='{.status.loadBalancer.ingress[0].ip}')

CANARY_ADDR=staging.jx-canary.$CANARY_IP.nip.io

while true; do
    curl "$CANARY_ADDR"
    sleep 0.5
done
```

* Go to the **first terminal**


<!-- .slide: data-background="img/canary-rollout.png" data-background-size="contain" -->


<!-- .slide: data-background="img/canary-rollback.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## To Canary Or Not To Canary?

|Requirement        |Fullfilled|
|-------------------|----------|
|High-availability  |Fully     |
|Responsiveness     |Fully     |
|Progressive rollout|Fully     |
|Rollback           |Fully     |
|Cost-effectiveness |Not       |


## Which Should We Choose?


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Which Should We Choose?

### Recreate

When working with legacy applications that often do not scale, that are stateful without replication, and are lacking other features that make them not cloud-native.


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Which Should We Choose?

### Rolling update

With cloud-native applications which, for one reason or another, cannot use canary deployments.


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Which Should We Choose?

### Canary

Instead of **rolling update** when you need the additional control when to roll forward and when to roll back.


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Which Should We Choose?

### Serverless

In permanent environments when you need excellent scaling capabilities or when an application is not in constant use.

For all the deployments to preview environments, no matter which strategy you're using in staging and production.
