## Hands-On Time

---

### Taking
# Jenkins-X
## For A Spin


## Creating A Cluster

---

```bash
git clone https://github.com/vfarcic/k8s-specs.git

cd k8s-specs/cluster

brew tap jenkins-x/jx

brew install jx

jx create cluster gke

PASS=[...]
```


## Creating A Project

---

```bash
jx create quickstart # Cancel with ctrl+c

jx create quickstart -l go

ll golang-http

open "https://github.com/vfarcic/golang-http"
```


## Creating A Project

---

```bash
cat golang-http/Dockerfile

cat golang-http/Jenkinsfile

ll golang-http/charts

ll golang-http/charts/golang-http

ll golang-http/charts/preview

open "https://github.com/vfarcic/golang-http/settings/hooks"

# Added Git repo to Jenkins

# Triggered the first pipeline
```


## Creating A Project

---

```bash
open "https://github.com/jenkins-x-quickstarts"

ll ~/.jx/draft/packs/github.com/jenkins-x/draft-packs/packs

jx create quickstart  -l go --organisations vfarcic
```


## Browsing The Project

---

```bash
kubectl get pods

echo $PASS

jx console

jx get activities

jx get activities -f golang-http -w
```


## Browsing The Project

---

```bash
jx get build logs

jx get build logs -f golang-http

jx get build logs vfarcic/golang-http/master

jx get pipelines

jx get app

jx get app -e staging

open "https://github.com/vfarcic/golang-http/releases"
```


## Switching The k8s Context

---

```bash
jx get env

jx env staging

kubectl get all

jx ns # Press ctrl+c

jx ns jx-production

kubectl get all
```


## Promoting A Build

---

```bash
jx get app -e staging

jx promote golang-http --version 0.0.1 --env production \
    --timeout 24h
```


## Cleanup

---

```bash
# Delete the cluster

# Delete the LB

# Delete the environment repos

# Delete the golang-http repo

rm -rf golang-http
```