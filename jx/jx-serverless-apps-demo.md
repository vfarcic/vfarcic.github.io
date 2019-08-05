<!-- .slide: class="center dark" -->
<!-- .slide: data-background="img/hands-on.jpg" -->
# Defining And Running Serverless Deployments

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12 of 12</div>
<div class="label">Hands-on Time</div>

## Installing Gloo and Knative

```bash
jx create addon gloo

kubectl get namespaces

jx edit deploy --team --kind default --batch-mode

jx edit deploy --team --kind knative --batch-mode
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12 of 12</div>
<div class="label">Hands-on Time</div>

## New Serverless Application

```bash
jx create quickstart --language go --project-name jx-knative \
    --batch-mode

cd jx-knative

cat charts/jx-knative/values.yaml

ls -1 charts/jx-knative/templates

cat charts/jx-knative/templates/deployment.yaml

cat charts/jx-knative/templates/ksvc.yaml

jx get activities --filter jx-knative --watch

jx get activities --filter environment-tekton-staging/master --watch
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12 of 12</div>
<div class="label">Hands-on Time</div>

## New Serverless Application

```bash
kubectl --namespace $NAMESPACE-staging get pods \
    --selector serving.knative.dev/service=jx-knative

kubectl --namespace $NAMESPACE-staging describe pod \
    --selector serving.knative.dev/service=jx-knative

kubectl --namespace $NAMESPACE-staging get all

jx get applications --env staging

ADDR=$(kubectl --namespace $NAMESPACE-staging get ksvc jx-knative \
    --output jsonpath="{.status.domain}")

echo $ADDR

curl "$ADDR"
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12 of 12</div>
<div class="label">Hands-on Time</div>

## New Serverless Application

```bash
kubectl --namespace $NAMESPACE-staging get pods \
    --selector serving.knative.dev/service=jx-knative

kubectl --namespace cd-staging get pods \
    --selector serving.knative.dev/service=jx-knative

kubectl --namespace knative-serving \
    describe configmap config-autoscaler

kubectl --namespace $NAMESPACE-staging get pods \
    --selector serving.knative.dev/service=jx-knative

# Make sure that the output is `no resources found`
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12 of 12</div>
<div class="label">Hands-on Time</div>

## New Serverless Application

```bash
kubectl run siege --image yokogawa/siege --generator "run-pod/v1" \
     -it --rm -- -c 300 -t 20S "http://$ADDR/" \
     && kubectl --namespace $NAMESPACE-staging get pods \
    --selector serving.knative.dev/service=jx-knative

cat charts/jx-knative/templates/ksvc.yaml | sed -e \
    's@revisionTemplate:@revisionTemplate:\
        metadata:\
          annotations:\
            autoscaling.knative.dev/target: "3"\
            autoscaling.knative.dev/maxScale: "5"@g' \
    | tee charts/jx-knative/templates/ksvc.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12 of 12</div>
<div class="label">Hands-on Time</div>

## New Serverless Application

```bash
git add .

git commit -m "Added Knative target"

git push

jx get activities --filter jx-knative --watch

jx get activities --filter environment-tekton-staging/master --watch

curl "http://$ADDR/"

kubectl run siege --image yokogawa/siege --generator "run-pod/v1" \
     -it --rm -- -c 400 -t 60S "http://$ADDR/" \
     && kubectl --namespace $NAMESPACE-staging get pods \
    --selector serving.knative.dev/service=jx-knative
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12 of 12</div>
<div class="label">Hands-on Time</div>

## New Serverless Application

```bash
kubectl --namespace $NAMESPACE-staging get pods \
    --selector serving.knative.dev/service=jx-knative

cat charts/jx-knative/templates/ksvc.yaml | sed -e \
    's@autoscaling.knative.dev/target: "3"@autoscaling.knative.dev/target: "3"\
            autoscaling.knative.dev/minScale: "1"@g' \
    | tee charts/jx-knative/templates/ksvc.yaml

git add .

git commit -m "Added Knative minScale"

git push

jx get activities --filter jx-knative --watch

jx get activities --filter environment-tekton-staging/master --watch
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12 of 12</div>
<div class="label">Hands-on Time</div>

## New Serverless Application

```bash
kubectl --namespace $NAMESPACE-staging get pods \
    --selector serving.knative.dev/service=jx-knative
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12 of 12</div>
<div class="label">Hands-on Time</div>

## Existing Projects To Serverless

```bash
cd ../go-demo-6

git checkout -b serverless

ls -1 charts/go-demo-6/templates
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12 of 12</div>
<div class="label">Hands-on Time</div>

## Adding Knative Support Manually

```bash
echo "knativeDeploy: false" | tee -a charts/go-demo-6/values.yaml

echo "{{- if .Values.knativeDeploy }}
{{- else }}
$(cat charts/go-demo-6/templates/deployment.yaml)
{{- end }}" | tee charts/go-demo-6/templates/deployment.yaml

echo "{{- if .Values.knativeDeploy }}
{{- else }}
$(cat charts/go-demo-6/templates/service.yaml)
{{- end }}" | tee charts/go-demo-6/templates/service.yaml

curl -o tee charts/go-demo-6/templates/ksvc.yaml \
    https://gist.githubusercontent.com/vfarcic/cb7c79f25e65bcca5f6e553a2aa8a47c/raw/886508339a4c04b9e575b6f4d417e80018e4c3f6/ksvc.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12 of 12</div>
<div class="label">Hands-on Time</div>

## Turning On Knative Support

```bash
jx edit deploy knative

cat charts/go-demo-6/values.yaml | grep knative
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12 of 12</div>
<div class="label">Hands-on Time</div>

## Adding The Final Touches

```bash
cat charts/go-demo-6/Makefile | sed -e "s@vfarcic@$PROJECT@g" \
    | tee charts/go-demo-6/Makefile

cat charts/preview/Makefile | sed -e "s@vfarcic@$PROJECT@g" \
    | tee charts/preview/Makefile

cat skaffold.yaml | sed -e "s@vfarcic@$PROJECT@g" | tee skaffold.yaml

cat jenkins-x.yml | sed '$ d' | tee jenkins-x.yml

curl -o Jenkinsfile https://gist.githubusercontent.com/vfarcic/56c986a29e0753076e08163a7c6a2051/raw/a8be26f33c877c0927e833b015c5620d150712d6/Jenkinsfile

git add .

git commit -m "Added Knative"

git push --set-upstream origin serverless
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12 of 12</div>
<div class="label">Hands-on Time</div>

## Serverless With PRs

```bash
jx create pullrequest --title "Serverless with Knative" \
    --body "What I can say?" --batch-mode

BRANCH=[...] # e.g., `PR-109`

jx get activities --filter go-demo-6/$BRANCH --watch

GH_USER=[...]

PR_NAMESPACE=$(echo $NAMESPACE-$GH_USER-go-demo-6-$BRANCH \
  | tr '[:upper:]' '[:lower:]')

echo $PR_NAMESPACE

kubectl --namespace $PR_NAMESPACE get pods
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12 of 12</div>
<div class="label">Hands-on Time</div>

## Serverless With PRs

```bash
PR_ADDR=$(kubectl --namespace $PR_NAMESPACE get ksvc go-demo-6 \
    --output jsonpath="{.status.domain}")

echo $PR_ADDR

curl "$PR_ADDR/demo/hello"

kubectl --namespace cd-staging get pods

jx repo

# Merge the PR
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12 of 12</div>
<div class="label">Hands-on Time</div>

## Serverless With PRs

```bash
git checkout master

git branch -d serverless

git pull

jx get activities --filter go-demo-6/master --watch

jx get activities --filter environment-tekton-staging/master --watch

kubectl --namespace $NAMESPACE-staging get pods
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12 of 12</div>
<div class="label">Hands-on Time</div>

## Serverless With PRs

```bash
ADDR=$(kubectl --namespace $NAMESPACE-staging get ksvc go-demo-6 \
    --output jsonpath="{.status.domain}")

echo $ADDR

curl "$ADDR/demo/hello"
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12 of 12</div>
<div class="label">Hands-on Time</div>

## Serverless With PRs Only

```bash
STAGING_ENV=environment-tekton-staging

cd ..

rm -rf $STAGING_ENV

git clone https://github.com/$GH_USER/$STAGING_ENV.git

cd $STAGING_ENV

echo "go-demo-6:
  knativeDeploy: false" | tee -a env/values.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12 of 12</div>
<div class="label">Hands-on Time</div>

## Serverless With PRs Only

```bash
git add .

git commit -m "Removed Knative"

git pull

git push
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12 of 12</div>
<div class="label">Hands-on Time</div>

## Serverless With PRs Only

```bash
cd ../go-demo-6

echo "go-demo-6 rocks" | tee README.md

git add .

git commit -m "Removed Knative"

git pull

git push

jx get activities --filter go-demo-6/master --watch

jx get activities --filter environment-tekton-staging/master --watch

kubectl --namespace $NAMESPACE-staging get pods
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 12 of 12</div>
<div class="label">Hands-on Time</div>

## Serverless With PRs Only

```bash
ADDR=$(kubectl --namespace $NAMESPACE-staging get ing go-demo-6 \
    --output jsonpath="{.spec.rules[0].host}")

echo $ADDR

curl "$ADDR/demo/hello"
```
