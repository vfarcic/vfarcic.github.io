<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Apps Need A DB
# And A Schema

<div class="label">Hands-on Time</div>


## Apps Need A DB And A Schema

```bash
kubectl --namespace dev get secrets

kubectl get databases.postgresql.sql.crossplane.io

cat examples/sql/schemahero-postgresql-params.yaml

kubectl --namespace dev apply \
    --filename examples/sql/schemahero-postgresql-params.yaml

kubectl --namespace dev get tables.schemas.schemahero.io
```
