<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Testing In Production

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 1</div>
<div class="label">Hands-on Time</div>

## Promotion

```bash
jx get applications

open https://github.com/$GH_USER/environment-$CLUSTER_NAME-production
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 1</div>
<div class="label">Hands-on Time</div>

## Running Test Cases

```bash
while true; do 
    curl $APP_ADDR
    sleep 0.5
done
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 1</div>
<div class="label">Hands-on Time</div>

## Collecting Test Results

```bash
# Open a second terminal

export KUBECONFIG=../terraform-gke/kubeconfig

istioctl dashboard prometheus

# sum(rate(istio_requests_total{destination_workload="jx-my-app-primary", reporter="destination",response_code!~"5.*"}[1m])) / sum(rate(istio_requests_total{destination_workload="jx-my-app-primary", reporter="destination"}[1m]))

# sum(rate(istio_request_duration_milliseconds_sum{destination_workload="jx-my-app-primary", reporter="destination"}[1m])) / sum(rate(istio_request_duration_milliseconds_count{destination_workload="jx-my-app-primary", reporter="destination"}[1m]))
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 1</div>
<div class="label">Hands-on Time</div>

## Exploring Test Reports

```bash
istioctl dashboard grafana

istioctl dashboard kiali
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 1</div>
<div class="label">Hands-on Time</div>

## Exploring Notifications

```bash
istioctl dashboard prometheus

# sum(rate(istio_request_duration_milliseconds_sum{destination_workload="jx-my-app-primary", reporter="destination"}[1m])) / sum(rate(istio_request_duration_milliseconds_count{destination_workload="jx-my-app-primary", reporter="destination"}[1m]))

# sum(rate(istio_request_duration_milliseconds_sum{destination_workload="jx-my-app-primary", reporter="destination"}[1m])) / sum(rate(istio_request_duration_milliseconds_count{destination_workload="jx-my-app-primary", reporter="destination"}[1m])) > 0.25
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 1</div>
<div class="label">Hands-on Time</div>

## Exploring Operations

```bash
# Go to the first terminal and cancel the loop

jx get applications

open https://github.com/$GH_USER/environment-$CLUSTER_NAME-production

kubectl --namespace jx-production get canaries

kubectl --namespace jx-production describe canary jx-my-app

cd ..
```
