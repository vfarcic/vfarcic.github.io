<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Apps Need A DB Server

<div class="label">Hands-on Time</div>


## Apps Need A DB Server

```bash
cat examples/sql/kubernetes.yaml

cat examples/sql/aws-official.yaml

kubectl --namespace dev apply \
    --filename examples/sql/aws-official.yaml

kubectl --namespace dev get sqlclaims
```
