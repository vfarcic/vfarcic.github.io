<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Experimenting With Application Availability

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Validating The Application

```bash
cat k8s/health/ingress.yaml

kubectl --namespace go-demo-8 apply --filename k8s/health/ingress.yaml

curl -H "Host: go-demo-8.acme.com" "http://$INGRESS_HOST"
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Validating Application Health

```bash
cat chaos/health.yaml

chaos run chaos/health.yaml

kubectl --namespace go-demo-8 get pods
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Validating Application Health

```bash
cat chaos/health-pause.yaml

diff chaos/health.yaml chaos/health-pause.yaml

chaos run chaos/health-pause.yaml

kubectl --namespace go-demo-8 get pods
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Validating Application Availability

```bash
cat chaos/health-http.yaml

diff chaos/health-pause.yaml chaos/health-http.yaml

chaos run chaos/health-http.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Validating Application Availability

```bash
cat k8s/health/hpa.yaml

kubectl apply --namespace go-demo-8 --filename k8s/health/hpa.yaml

# Repeat if the number of replicas is not `2`
kubectl --namespace go-demo-8 get hpa

chaos run chaos/health-http.yaml
```