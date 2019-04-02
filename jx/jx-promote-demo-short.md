## Hands-On Time

---

# Promoting To Production


## Promoting To Production

---

```bash
jx get applications -e production

jx get applications -e staging

VERSION=[...]

jx promote jx-go --version $VERSION --env production -b

jx get applications -e production

PROD_ADDR=[...]

curl "$PROD_ADDR/demo/hello"
```
