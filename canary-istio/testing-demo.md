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

while true; do 
    curl $APP_ADDR
    sleep 0.5
done

# Open a second terminal

export KUBECONFIG=../terraform-gke/kubeconfig

istioctl dashboard prometheus

# sum(rate(istio_requests_total{destination_workload="jx-my-app-primary", reporter="destination",response_code!~"5.*"}[1m])) / sum(rate(istio_requests_total{destination_workload="jx-my-app-primary", reporter="destination"}[1m]))

# sum(rate(istio_request_duration_milliseconds_sum{destination_workload="jx-my-app-primary", reporter="destination"}[1m])) / sum(rate(istio_request_duration_milliseconds_count{destination_workload="jx-my-app-primary", reporter="destination"}[1m]))

kubectl --namespace jx-production get canaries
```
