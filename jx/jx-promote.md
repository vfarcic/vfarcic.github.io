## Promote Builds

---

```bash
jx get apps -e staging

VERSION=[...]

jx promote go-demo-6 --version $VERSION --env production -b

PROD_URL=$(kubectl -n jx-production get ing go-demo-6 \
    -o jsonpath="{.spec.rules[0].host}")

curl "http://$PROD_URL/demo/hello"
```
