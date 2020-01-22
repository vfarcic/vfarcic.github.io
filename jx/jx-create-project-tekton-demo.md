<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Creating A Quickstart Project

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 3</div>
<div class="label">Hands-on Time</div>

## Creating A Project

```bash
jx create quickstart # Cancel with ctrl+c

jx create quickstart --filter golang-http --project-name jx-go --batch-mode

open "https://github.com/$GH_USER/jx-go"
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 3</div>
<div class="label">Hands-on Time</div>

## Creating A Project

```bash
ls -l jx-go

cat jx-go/Dockerfile

cat jx-go/jenkins-x.yml

cat jx-go/Makefile

cat jx-go/skaffold.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 3</div>
<div class="label">Hands-on Time</div>

## Creating A Project

```bash
ls -l jx-go/charts

ls -l jx-go/charts/jx-go

ls -l jx-go/charts/preview

open "https://github.com/$GH_USER/jx-go/settings/hooks"

open "https://github.com/jenkins-x-quickstarts"

open "https://github.com/jenkins-x-buildpacks"
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 3</div>
<div class="label">Hands-on Time</div>

## Browsing The Project

```bash
kubectl get pods

jx get activities

jx get activities --filter jx-go --watch # Cancel with ctrl+c

jx get build logs # Cancel with ctrl+c

jx get build logs --filter jx-go # Cancel with ctrl+c
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 3</div>
<div class="label">Hands-on Time</div>

## Browsing The Project

```bash
jx get pipelines

jx get applications

jx get env

jx get applications --env staging

open "https://github.com/$GH_USER/jx-go/releases"
```
