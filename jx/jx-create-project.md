## Creating A Project

---

```bash
jx create quickstart # Cancel with ctrl+c

jx create quickstart -l go -p jx-go -b true

GH_USER=[...]

open "https://github.com/$GH_USER/jx-go"

ll jx-go

cat jx-go/Dockerfile

cat jx-go/Jenkinsfile

cat jx-go/Makefile
```


## Creating A Project

---

```bash
cat jx-go/skaffold.yaml

ll jx-go/charts

ll jx-go/charts/jx-go

ll jx-go/charts/preview

open "https://github.com/$GH_USER/jx-go/settings/hooks"

open "https://github.com/jenkins-x-quickstarts"

ll ~/.jx/draft/packs/github.com/jenkins-x/draft-packs/packs
```


## Browsing The Project

---

```bash
kubectl get pods

jx console

jx get activities

jx get activities -f jx-go -w
```


## Browsing The Project

---

```bash
jx get build logs

jx get build logs -f jx-go

jx get build logs $GH_USER/jx-go/master

jx get pipelines

jx get apps

jx get apps -e staging

open "https://github.com/$GH_USER/jx-go/releases"
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

kubectl get all
```
