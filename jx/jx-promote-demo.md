<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Promoting Releases To Production

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 7</div>
<div class="label">Hands-on Time</div>

## In case you messed it up

```bash
git checkout master

git pull

git checkout pr && git merge -s ours master --no-edit

git checkout master && git merge pr

echo "buildPack: go" | tee jenkins-x.yml

git add . && git commit -m "Added jenkins-x.yml" && git push
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 7</div>
<div class="label">Hands-on Time</div>

## Promoting Production

```bash
jx get applications --env production

jx get applications --env staging

VERSION=[...]

jx promote go-demo-6 --version $VERSION --env production --batch-mode
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 7</div>
<div class="label">Hands-on Time</div>

## Promoting Production

```bash
jx get applications --env production

PROD_ADDR=[...]

curl "$PROD_ADDR/demo/hello"
```
