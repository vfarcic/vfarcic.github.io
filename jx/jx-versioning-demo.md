## Hands-On Time

---

# Versioning Releases


## Semantic Versioning

---

**MAJOR.MINOR.PATCH**

* *Patch* is incremented when we release bug fixes.
* *Minor* is incremented when new functionality is added in a backward-compatible manner.
* *Major* is incremented when changes are not backward compatible.


## Versioning Through Tags

---

```bash
jx get applications

jx create devpod -b

jx rsh -d

cd go-demo-6

curl -L -o /usr/local/bin/jx-release-version \
  https://github.com/jenkins-x/jx-release-version/releases/download/v1.0.17/jx-release-version-linux

chmod +x /usr/local/bin/jx-release-version

git tag

jx-release-version
```


## Versioning Through Tags

---

```bash
git tag v1.0.0

jx-release-version

exit

jx delete devpod
```


## Versioning From Pipelines

---

* Add the snippet that follows to Makefile.

```
VERSION := 1.0.0
```

```bash
jx-release-version

cat Jenkinsfile

git commit -m "Finally 1.0.0"

git push

jx get activities -f go-demo-6 -w

jx get applications

GH_USER=[...]

open "https://github.com/$GH_USER/go-demo-6/releases"
```


## Versioning From Pipelines

---

```bash
echo "A silly change" | tee README.md

git add .

git commit -m "A silly change"

git push

jx get activity -f go-demo-6 -w
```
