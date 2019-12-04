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

glooctl install knative --install-knative-version=0.9.0
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
jx edit deploy --team --kind knative --batch-mode

jx create quickstart --filter golang-http --project-name jx-knative \
    --batch-mode
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
jx get activities --filter jx-knative --watch

jx get activities --filter environment-tekton-staging/master --watch

ADDR=$(kubectl --namespace cd-staging get ksvc jx-knative \
    --output jsonpath="{.status.url}")

curl $ADDR
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
cd jx-knative

cat charts/jx-knative/templates/ksvc.yaml | sed -e \
    's@revisionTemplate:@revisionTemplate:\
        metadata:\
          annotations:\
            autoscaling.knative.dev/maxScale: "5"@g' \
    | tee charts/jx-knative/templates/ksvc.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
git add . && git commit -m "Added Knative target"

git push --set-upstream origin master

jx get activities --filter jx-knative --watch

jx get activities --filter environment-tekton-staging/master --watch

curl $ADDR
```
