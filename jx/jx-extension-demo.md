<!-- .slide: class="center dark" -->
<!-- .slide: data-background="img/hands-on.jpg" -->
# Using The Pipeline Extension Model

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 10 of 12</div>
<div class="label">Hands-on Time</div>

## In Case You Messed It Up

```bash
cd go-demo-6

git pull

git checkout versioning

git merge -s ours master --no-edit

git checkout master

git merge versioning

git push
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 10 of 12</div>
<div class="label">Hands-on Time</div>

## Exploring Build Pack Pipelines

```bash
git checkout master

rm -f Jenkinsfile

echo "buildPack: go" | tee jenkins-x.yml

git add .

git commit -m "jenkins-x.yml"

git push

ls -1

cat jenkins-x.yml

open "https://github.com/jenkins-x-buildpacks/jenkins-x-kubernetes"

curl "https://raw.githubusercontent.com/jenkins-x-buildpacks/jenkins-x-kubernetes/master/packs/go/pipeline.yaml"

curl "https://raw.githubusercontent.com/jenkins-x-buildpacks/jenkins-x-classic/master/packs/go/pipeline.yaml"

jx get activities --filter go-demo-6 --watch
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 10 of 12</div>
<div class="label">Hands-on Time</div>

## Extending Build Pack Pipelines

<pre><code class="language-bash" style="max-height:154px">git checkout -b extension

cat charts/go-demo-6/values.yaml | sed -e \
    's@replicaCount: 1@replicaCount: 3@g' \
    | tee charts/go-demo-6/values.yaml

cat functional_test.go | sed -e \
    's@fmt.Sprintf("http://@fmt.Sprintf("@g' \
    | tee functional_test.go

cat production_test.go | sed -e \
    's@fmt.Sprintf("http://@fmt.Sprintf("@g' \
    | tee production_test.go

jx create step
</code></pre>

```
? Pick the pipeline kind:  pullrequest
? Pick the lifecycle:  build
? Pick the create mode:  pre
? Command for the new step:  make unittest
Updated Jenkins X Pipeline file: jenkins-x.yml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 10 of 12</div>
<div class="label">Hands-on Time</div>

## Extending Build Pack Pipelines

```bash
cat jenkins-x.yml

git add . && git commit --message "Trying to extend the pipeline"

git push --set-upstream origin extension

jx create pullrequest --title "Extensions" --body "What I can say?" \
    --batch-mode

PR_ADDR=[...] # e.g., `https://github.com/vfarcic/go-demo-6/pull/56`

BRANCH=[...] # e.g., `PR-56`

# Wait for a few moments

jx get build logs --filter go-demo-6 --branch $BRANCH
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 10 of 12</div>
<div class="label">Hands-on Time</div>

## Extending Build Pack Pipelines

```bash
jx create step --pipeline pullrequest --lifecycle promote --mode post \
    --sh 'ADDRESS=`jx get preview --current 2>&1` make functest'

cat jenkins-x.yml

git add .

git commit --message "Trying to extend the pipeline"

git push

# Wait for a few moments

jx get build logs --filter go-demo-6 --branch $BRANCH
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 10 of 12</div>
<div class="label">Hands-on Time</div>

## Extending Build Pack Pipelines

```bash
jx create step --pipeline pullrequest --lifecycle promote --mode post \
    --sh 'ADDRESS=http://this-domain-does-not-exist.com make functest'

git add .

git commit --message "Added silly tests"

git push

# Wait for a few moments

jx get build logs --filter go-demo-6 --branch $BRANCH

open "$PR_ADDR"
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 10 of 12</div>
<div class="label">Hands-on Time</div>

## Extending Build Pack Pipelines

```bash
cat jenkins-x.yml | sed '$ d' | tee jenkins-x.yml

git add .

git commit --message "Removed the silly test"

git push
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 10 of 12</div>
<div class="label">Hands-on Time</div>

## Extending Environment Pipelines

```bash
cd ..

GH_USER=[...]

cd environment-$NAMESPACE-staging

git pull

cat jenkins-x.yml

curl https://raw.githubusercontent.com/jenkins-x-buildpacks/jenkins-x-kubernetes/master/packs/environment/pipeline.yaml

jx create step --pipeline release --lifecycle postbuild --mode post \
    --sh 'echo "Running integ tests!!!"'

cat jenkins-x.yml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 10 of 12</div>
<div class="label">Hands-on Time</div>

## Extending Environment Pipelines

```bash
git add .

git commit --message "Added integ tests"

git push

# Wait for a few moments

jx get build logs --filter environment-$NAMESPACE-staging \
    --branch master

open "$PR_ADDR"

# Merge it

cd ..
```
