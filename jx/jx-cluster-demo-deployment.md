<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Creating A Jenkins X Cluster

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
PROJECT=[...] # e.g. devops26

jx create cluster gke --cluster-name jx-rocks --project-id $PROJECT \
    --region us-east1 -m n1-standard-2 --min-num-nodes 1 \
    --max-num-nodes 2 --default-admin-password=admin \
    --default-environment-prefix tekton --git-provider-kind github \
    --namespace cd --prow --tekton --batch-mode

jx create addon gloo --install-knative-version=0.9.0

jx create addon istio && jx create addon flagger
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
KNATIVE_IP=$(kubectl --namespace gloo-system \
    get service knative-external-proxy \
    --output jsonpath="{.status.loadBalancer.ingress[0].ip}")

echo "apiVersion: v1
kind: ConfigMap
metadata:
  name: config-domain
  namespace: knative-serving
data:
  $KNATIVE_IP.nip.io: \"\"" \
    | kubectl apply --filename -
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
LB_IP=$(kubectl --namespace kube-system \
    get svc jxing-nginx-ingress-controller \
    -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

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
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Setting The Scene (Serverless)

```bash
jx create quickstart --filter golang-http --project-name jx-knative \
    --deploy-kind knative --batch-mode

jx get activity --filter jx-knative --watch
```


## Setting The Scene (Recreate)

```bash
jx create quickstart --filter golang-http --project-name jx-recreate \
    --deploy-kind default --batch-mode

jx get activity --filter jx-recreate --watch

cd jx-recreate

cat charts/jx-recreate/templates/deployment.yaml | sed -e \
    's@  replicas:@  strategy:\
    type: Recreate\
  replicas:@g' | tee charts/jx-recreate/templates/deployment.yaml
```


## Setting The Scene (Recreate)

```bash
cat charts/jx-recreate/values.yaml \
    | sed -e 's@replicaCount: 1@replicaCount: 5@g' \
    | tee charts/jx-recreate/values.yaml

git add . && git commit -m "Recreate"

git push --set-upstream origin master

jx get activity --filter jx-recreate --watch

cd ..
```


## Setting The Scene (Rolling Update)

```bash
jx create quickstart --filter golang-http --project-name jx-rolling \
    --deploy-kind default --batch-mode

jx get activity --filter jx-rolling --watch

cd jx-rolling

cat charts/jx-rolling/values.yaml \
    | sed -e 's@replicaCount: 1@replicaCount: 5@g' \
    | tee charts/jx-rolling/values.yaml
```


## Setting The Scene (Rolling Update)

```bash
git add . && git commit -m "Rolling"

git push --set-upstream origin master

jx get activity --filter jx-rolling --watch

cd ..
```


## Setting The Scene (Canary)

```bash
jx create quickstart --filter golang-http --project-name jx-canary \
    --deploy-kind default --batch-mode

jx get activity --filter jx-canary --watch

cd jx-canary

cat charts/jx-canary/values.yaml \
    | sed -e 's@replicaCount: 1@replicaCount: 5@g' \
    | tee charts/jx-canary/values.yaml

kubectl label namespace cd-staging istio-injection=enabled --overwrite
```


## Setting The Scene (Canary)

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
" | tee charts/jx-canary/templates/canary.yaml
```


## Setting The Scene (Canary)

```bash
ISTIO_IP=$(kubectl --namespace istio-system \
    get service istio-ingressgateway \
    --output jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "
canary:
  enable: false
  provider: istio
  service:
    hosts:
    - jx-canary.$ISTIO_IP.nip.io
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
" | tee -a charts/jx-canary/values.yaml
```


## Setting The Scene (Canary)

```bash
cd ..

GH_USER=[...]

jx get activity --filter environment-tekton-staging/master --watch

git clone \
    https://github.com/$GH_USER/environment-tekton-staging.git

cd environment-tekton-staging

STAGING_ADDR=staging.jx-canary.$ISTIO_IP.nip.io
```


## Setting The Scene (Canary)

```bash
echo "jx-canary:
  canary:
    enable: true
    service:
      hosts:
      - $STAGING_ADDR" \
    | tee -a env/values.yaml

git add . && git commit -m "Added progressive deployment" && git push

jx get activity --filter environment-tekton-staging/master --watch
```


## Setting The Scene (Canary)

```bash
cd ../jx-canary

git add . && git commit -m "Canary"

git push --set-upstream origin master

jx get activity --filter jx-canary --watch

cd ..
```
