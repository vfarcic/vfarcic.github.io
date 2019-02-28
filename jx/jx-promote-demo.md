## Hands-On Time

---

# Promoting To Production


## Promoting To Production

---

```bash
git checkout master

jx get applications -e staging

VERSION=[...]

jx promote go-demo-6 --version $VERSION --env production -b

PROD_ADDR=$(kubectl -n jx-production get ing go-demo-6 \
    -o jsonpath="{.spec.rules[0].host}")

curl "http://$PROD_ADDR/demo/hello"
```
