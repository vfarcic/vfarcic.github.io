## Promote Builds

---

```bash
jx get apps -e staging

VERSION=[...]

jx promote go-demo-6 --version $VERSION --env production \
    --timeout 20m
```
