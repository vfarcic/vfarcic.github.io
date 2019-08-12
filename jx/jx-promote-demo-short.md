<!-- .slide: class="center dark" -->
<!-- .slide: data-background="img/hands-on.jpg" -->
# Promoting Releases To Production

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Promoting To Production

```bash
jx get applications -e production

jx get applications -e staging

VERSION=[...]

jx promote jx-go --version $VERSION --env production -b
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Promoting To Production

```bash
jx get applications -e production

PROD_ADDR=[...]

curl "$PROD_ADDR/demo/hello"
```
