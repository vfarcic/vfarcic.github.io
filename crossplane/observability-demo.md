![](../img/products/grafana.png)


# The App

```bash
ls -1 kustomize

cat kustomize/base/deployment.yaml

cat kustomize/overlays/stateful-google/postgresql.yaml

kubectl --namespace a-team apply \
    --kustomize kustomize/overlays/stateful-google
```


![](../img/products/crossplane.png)


![](../img/products/lens.png)


![](../img/products/prometheus.png)


```bash
# Execute the following queries:
# `group by (customresource_kind) (kube_customresource_status_condition)`
# `kube_customresource_status_condition{customresource_kind="SQLClaim"}`
# `sum by (status) (kube_customresource_status_condition{customresource_kind="SQLClaim", condition="Ready"})`
# `kube_customresource_status_condition{customresource_kind="DatabaseInstance", condition="Ready"}`
# `sum by (status) (kube_customresource_status_condition{customresource_kind="DatabaseInstance", condition="Ready"})`
```


# Kube State Metrics

* https://github.com/vfarcic/devops-toolkit-crossplane/blob/master/examples/observability/ksm-cm-google.yaml
* https://github.com/vfarcic/devops-toolkit-crossplane/blob/master/examples/observability/prometheus-stack-values-google.yaml


![](../img/products/loki.png)


```bash
# Select `app` = `k8s-event-logger` as `Label filters`
# Set `a-team-gke` as `Line contains`
```


![](../img/products/lens.png)


# What Now?

* It's a start
* Kubernetes will continue to expand in scope
* Kubernetes will (and already is) a control plane for everything
