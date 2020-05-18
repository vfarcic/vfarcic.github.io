<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Importing Existing Projects Into Jenkins X

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 4</div>
<div class="label">Hands-on Time</div>

## Importing A Project

```bash
open "https://github.com/vfarcic/go-demo-6"
```

* Fork it

```bash
export GH_USER=[...] # Replace `[...]` with your GitHub user

git clone https://github.com/$GH_USER/go-demo-6.git

cd go-demo-6
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 4</div>
<div class="label">Hands-on Time</div>

## Importing A Project

```bash
git checkout orig

git merge -s ours master --no-edit

git checkout master

git merge orig

rm -rf charts

ls -1
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 4</div>
<div class="label">Hands-on Time</div>

## Importing A Project

```bash
git push

jx import --batch-mode

ls -1

jx get activities --filter go-demo-6 --watch # Stop with *ctrl*c*
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 4</div>
<div class="label">Hands-on Time</div>

## Importing A Project

```bash
jx get applications

STAGING_ADDR=[...]

curl "$STAGING_ADDR/demo/hello" # It fails

kubectl --namespace $NAMESPACE-staging logs --selector app=jx-go-demo-6
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 4</div>
<div class="label">Hands-on Time</div>

## Fixing The Helm Chart

```bash
git checkout buildpack-tekton

git merge -s ours master --no-edit

git checkout master

git merge buildpack-tekton

cat charts/go-demo-6/requirements.yaml

git push
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 4</div>
<div class="label">Hands-on Time</div>

## Fixing The Helm Chart

```bash
jx get activities --filter go-demo-6 --watch

# Stop with *ctrl+c*

jx get activities --filter environment-$CLUSTER_NAME-staging/master --watch

# Stop with *ctrl+c*

curl "$STAGING_ADDR/demo/hello"
```
