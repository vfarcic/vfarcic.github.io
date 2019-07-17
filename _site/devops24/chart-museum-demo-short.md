## Hands-On Time

---

# Distributing Kubernetes Applications


## Using ChartMuseum

---

```bash
helm inspect values stable/chartmuseum

CM_ADDR="cm.$LB_IP.nip.io"

echo $CM_ADDR

CM_ADDR_ESC=$(echo $CM_ADDR | sed -e "s@\.@\\\.@g")

echo $CM_ADDR_ESC

cat helm/chartmuseum-values.yml
```


## Using ChartMuseum

---

```bash
helm install stable/chartmuseum --namespace charts --name cm \
    --values helm/chartmuseum-values.yml \
    --set ingress.hosts."$CM_ADDR_ESC"={"/"} \
    --set env.secret.BASIC_AUTH_USER=admin \
    --set env.secret.BASIC_AUTH_PASS=admin \
    --set env.open.AUTH_ANONYMOUS_GET=true

kubectl -n charts rollout status deploy cm-chartmuseum

curl "http://$CM_ADDR/index.yaml"
```


## Using ChartMuseum

---

```bash
helm repo add chartmuseum http://$CM_ADDR --username admin \
    --password admin

helm plugin install https://github.com/chartmuseum/helm-push

helm push ../go-demo-3/helm/go-demo-3/ chartmuseum \
    --username admin --password admin

curl "http://$CM_ADDR/index.yaml"

helm search chartmuseum/

helm repo update

helm search chartmuseum/
```


## Using ChartMuseum

---

```bash
helm inspect chartmuseum/go-demo-3

GD3_ADDR="go-demo-3.$LB_IP.nip.io"

echo $GD3_ADDR

helm upgrade -i go-demo-3 chartmuseum/go-demo-3 \
    --namespace go-demo-3 --set image.tag=1.0 \
    --set ingress.host=$GD3_ADDR --reuse-values

kubectl -n go-demo-3 rollout status deploy go-demo-3

curl "http://$GD3_ADDR/demo/hello"
```


## What Now?

---

```bash
helm delete go-demo-3 --purge

curl -XDELETE "http://$CM_ADDR/api/charts/go-demo-3/0.0.1" \
    -u admin:admin

kubectl delete ns go-demo-3
```
