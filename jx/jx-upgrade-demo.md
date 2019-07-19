## Hands-On Time

---

# Upgrading Jenkins X Components


## Jenkins X Version Stream

---

```bash
open "https://github.com/jenkins-x/jenkins-x-versions"
```


## In Case You Messed It Up

---

```bash
cd go-demo-6

git pull

git checkout extension-model-cd

git merge -s ours master --no-edit

git checkout master

git merge extension-model-cd

git push

cd ..
```


## Upgrading The Cluster And Local Binaries

---

```bash
jx version

jx upgrade platform --help

jx upgrade platform --batch-mode

jx version

jx get addons

# https://github.com/jenkins-x/jx/issues/3392
# jx upgrade addons

jx get addons
```


## Upgrading Ingress Rules
## (only me)

---

```bash 
jx get applications

STAGING_ADDR=[...]

curl "$STAGING_ADDR/demo/hello"

# If created the cluster with `jx create cluster`
LB_IP=$(kubectl --namespace kube-system \
    get svc jxing-nginx-ingress-controller \
    -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

# If installed `jx` in an existing cluster
LB_IP=$(kubectl --namespace ingress-nginx \
    get svc ingress-nginx \
    -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

echo $LB_IP
```


## Upgrading Ingress Rules
## (only me)

---

<!-- https://github.com/jenkins-x/jx/issues/4802 -->
```bash
# Update your domain DNSes

DOMAIN=[...]

jx upgrade ingress --cluster true --domain $DOMAIN

jx get applications --env staging

STAGING_ADDR=[...]

curl "$STAGING_ADDR/demo/hello"

cd go-demo-6

jx repo --batch-mode
```


## Upgrading Ingress Rules
## (only me)

---

```bash
echo "I am too lazy to write a README" | tee README.md

git add .

git commit -m "Checking webhooks"

git push

jx get activities --filter go-demo-6 --watch
```


## Changing URL Patterns

---

```bash
jx get applications --env staging

NAMESPACE=$(kubectl config view --output jsonpath="{..namespace}")

jx upgrade ingress --namespaces $NAMESPACE-staging \
    --urltemplate "{{.Service}}.staging.{{.Domain}}"

jx get applications --env staging

VERSION=[...]

STAGING_ADDR=[...]

curl "$STAGING_ADDR/demo/hello"

jx promote go-demo-6 --version $VERSION --env production --batch-mode
```


## Changing URL Patterns

---

```bash
jx get applications --env production

jx upgrade ingress --domain $DOMAIN --namespaces $NAMESPACE-production \
    --urltemplate "{{.Service}}.{{.Domain}}"

jx get applications --env production
```


## Changing URL Patterns

---

* We could add the following to the chart template

```yaml
# If could be `jx-production` if you're using static JX.
{{- if eq .Release.Namespace "cd-production" }}
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: go-demo-6-prod
  annotations:
    kubernetes.io/ingress.class: nginx
spec:
  rules:
  - host: go-demo-6.com
    http:
      paths:
      - backend:
          serviceName: go-demo-6
          servicePort: 80
{{- end }}
```


## What Now?

---

```bash
cd ..
```