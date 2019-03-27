## Hands-On Time

---

# Promoting Releases To Production


## In case you messed it up

---

```bash
git pull

git checkout pr

git merge -s ours master --no-edit

git checkout master

git merge pr

git push
```


## Promoting Production

---

```bash
jx get applications -e production

jx get applications -e staging

VERSION=[...]

jx promote go-demo-6 --version $VERSION --env production -b

jx get applications -e production

PROD_ADDR=[...]

curl "$PROD_ADDR/demo/hello"
```
