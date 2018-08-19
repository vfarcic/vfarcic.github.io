## Hands-On Time

---

# Packaging Kubernetes Applications


## Installing Helm

---

```bash
# Only if MacOC
brew install kubernetes-helm

# Only if Windows
choco install kubernetes-helm

# Only if Linux
open https://github.com/kubernetes/helm/releases

# Only if Linux
# Download tar.gz file, unpack it, move binary to /usr/local/bin/.

cat helm/tiller-rbac.yml

kubectl create -f helm/tiller-rbac.yml --record --save-config
```


## Installing Helm

---

```bash
helm init --service-account tiller

kubectl -n kube-system rollout status deploy tiller-deploy

helm repo update
```


## Exploring Helm Charts

---

```bash
cd ../go-demo-3

ls -1 helm/go-demo-3

cat helm/go-demo-3/Chart.yaml

cat helm/go-demo-3/templates/deployment.yaml

cat helm/go-demo-3/values.yaml

helm package helm/go-demo-3 -d helm
```


## Upgrading Charts

---

```bash
HOST="go-demo-3.$LB_IP.xip.io"

echo $HOST

helm upgrade -i go-demo-3 helm/go-demo-3 --namespace go-demo-3 \
    --set image.tag=1.0 --set ingress.host=$HOST --reuse-values

kubectl -n go-demo-3 rollout status deployment go-demo-3

curl http://$HOST/demo/hello

helm upgrade -i go-demo-3 helm/go-demo-3 --namespace go-demo-3 \
    --set image.tag=2.0 --reuse-values
```


## What Now?

---

```bash
helm delete go-demo-3 --purge

kubectl delete ns go-demo-3

cd ../k8s-specs
```
