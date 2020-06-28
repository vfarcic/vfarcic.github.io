<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Obstructing And Destroying Network

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Deploying The App

```bash
kubectl delete namespace go-demo-8

kubectl create namespace go-demo-8

kubectl label namespace go-demo-8 istio-injection=enabled

cat k8s/health/app/*

kubectl --namespace go-demo-8 apply --filename k8s/health/app/

kubectl --namespace go-demo-8 rollout status deployment go-demo-8
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Deploying The App

```bash
cat k8s/network/istio.yaml

kubectl --namespace go-demo-8 apply --filename k8s/network/istio.yaml

cat k8s/network/repeater/*

kubectl --namespace go-demo-8 apply --filename k8s/network/repeater

kubectl --namespace go-demo-8 rollout status deployment repeater

export INGRESS_HOST=$ISTIO_HOST
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Aborting Network Requests

```bash
curl -H "Host: repeater.acme.com" \
    "http://$INGRESS_HOST?addr=http://go-demo-8"

cat chaos/network.yaml

chaos run chaos/network.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Rolling Back Abort Failures

```bash
for i in {1..10}; do 
    curl -H "Host: repeater.acme.com" \
        "http://$INGRESS_HOST?addr=http://go-demo-8"
    echo ""
done

kubectl --namespace go-demo-8 describe virtualservice go-demo-8

kubectl --namespace go-demo-8 apply --filename k8s/network/istio.yaml

kubectl --namespace go-demo-8 describe virtualservice go-demo-8
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Rolling Back Abort Failures

```bash
cat chaos/network-rollback.yaml

diff chaos/network.yaml chaos/network-rollback.yaml

chaos run chaos/network-rollback.yaml

for i in {1..10}; do 
    curl -H "Host: repeater.acme.com" \
        "http://$INGRESS_HOST?addr=http://go-demo-8"
done

kubectl --namespace go-demo-8 describe virtualservice go-demo-8
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Making The App Resilient To Partial Network Failures

```bash
cat k8s/network/istio-repeater.yaml

kubectl --namespace go-demo-8 \
    apply --filename k8s/network/istio-repeater.yaml

chaos run chaos/network-rollback.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Increasing Network Latency

```bash
cat chaos/network-delay.yaml

diff chaos/network-rollback.yaml chaos/network-delay.yaml

chaos run chaos/network-delay.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Increasing Network Latency

```bash
cat k8s/network/istio-delay.yaml

diff k8s/network/istio-repeater.yaml k8s/network/istio-delay.yaml

kubectl --namespace go-demo-8 \
    apply --filename k8s/network/istio-delay.yaml

chaos run chaos/network-delay.yaml

# It might fail if (randomly) too many requests fall into delay or abort state
```
