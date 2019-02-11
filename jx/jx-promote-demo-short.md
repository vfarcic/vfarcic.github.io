## Hands-On Time

---

# Promoting To Production


## Promoting To Production

---

```bash
git checkout master

jx get apps -e staging

VERSION=[...]

jx promote jx-go --version $VERSION --env production -b

PROD_ADDR=$(kubectl -n jx-production get ing jx-go \
    -o jsonpath="{.spec.rules[0].host}")

curl "http://$PROD_ADDR"
```
