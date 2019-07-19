## Hands-On Time

---

# Versioning Releases


## Semantic Versioning

---

**MAJOR.MINOR.PATCH**

* *Patch* is incremented when we release bug fixes.
* *Minor* is incremented when new functionality is added in a backward-compatible manner.
* *Major* is incremented when changes are not backward compatible.


## Versioning From Pipelines

---

```bash
jx get applications --env staging

VERSION=2.0.0

echo "VERSION := $VERSION" | tee -a Makefile

git add . 

git commit -m "Finally 1.0.0"

git push

jx get activities -f go-demo-6 -w

jx get applications --env staging
```


## Versioning From Pipelines

---

```bash
GH_USER=[...]

open "https://github.com/$GH_USER/go-demo-6/releases"

echo "A silly change" | tee README.md

git add .

git commit -m "A silly change"

git push

jx get activity --filter go-demo-6 --watch

jx get applications --env staging

cd ..
```
