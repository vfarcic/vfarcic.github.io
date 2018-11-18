## Hands-On Time

---

# Distributing Kubernetes Applications


## Using ChartMuseum

---

```bash
helm repo add stable \
    https://kubernetes-charts.storage.googleapis.com

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
    --set env.secret.BASIC_AUTH_PASS=admin

kubectl -n charts rollout status deploy cm-chartmuseum

curl "http://$CM_ADDR/health"

open "http://$CM_ADDR"

curl "http://$CM_ADDR/index.yaml"

curl -u admin:admin "http://$CM_ADDR/index.yaml"
```


## Using ChartMuseum

---

```bash
helm repo add chartmuseum http://$CM_ADDR --username admin \
    --password admin

helm plugin install https://github.com/chartmuseum/helm-push

helm push ../go-demo-3/helm/go-demo-3/ chartmuseum \
    --username admin --password admin

curl "http://$CM_ADDR/index.yaml" -u admin:admin

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


## Using ChartMuseum

---

```bash
helm delete go-demo-3 --purge

curl -XDELETE "http://$CM_ADDR/api/charts/go-demo-3/0.0.1" \
    -u admin:admin
```


## Using Monocular

---

```bash
helm repo add monocular https://helm.github.io/monocular

helm inspect values monocular/monocular

cat helm/monocular-values.yml

MONOCULAR_ADDR="monocular.$LB_IP.nip.io"

echo $MONOCULAR_ADDR

helm install monocular/monocular --namespace charts \
    --name monocular --values helm/monocular-values.yml \
    --set ingress.hosts={$MONOCULAR_ADDR}

kubectl -n charts rollout status deploy monocular-monocular-ui
```


## Using Monocular

---

```bash
open "http://$MONOCULAR_ADDR"
```


## What Now?

---

```bash
helm delete monocular --purge

kubectl delete ns go-demo-3 go-demo-3-build
```
