## Hands-On Time

---

# Understranding GitOps Principles


## Just In Case You Failed

---

```bash
git checkout buildpack

git merge -s ours master --no-edit

git checkout master

git merge orig

git push
```


## Exploring Environments

---

```bash
jx get env

jx get env -p Auto

jx get env -p Manual

jx get env -p Never
```


## The Staging Environment

---

```bash
cd ..

GH_USER=[...]

git clone \
    https://github.com/$GH_USER/environment-jx-rocks-staging.git

cd environment-jx-rocks-staging

ls -1
```


## The Staging Environment

---

```bash
cat Makefile

echo 'test:
	ADDRESS=`kubectl -n jx-staging get ing go-demo-6 \\
	-o jsonpath="{.spec.rules[0].host}"` go test -v' \
    | tee -a Makefile

curl -sSLo integration_test.go https://bit.ly/2Do5LRN

cat integration_test.go

cat Jenkinsfile

curl -sSLo Jenkinsfile https://bit.ly/2Dr1Kfk

cat Jenkinsfile
```


## The Staging Environment

---

```bash
ls -1 env

cat env/requirements.yaml

git add .

git commit -m "Added tests"

git push

jx get activity -f environment-jx-rocks-staging -w

jx get build logs $GH_USER/environment-jx-rocks-staging/master

jx console
```


## The Production Environment

---

```bash
cd ..

git clone \
    https://github.com/$GH_USER/environment-jx-rocks-production.git

cd environment-jx-rocks-production

echo 'test:
	ADDRESS=`kubectl -n jx-production get ing go-demo-6 \\
	-o jsonpath="{.spec.rules[0].host}"` go test -v' \
    | tee -a Makefile

# Replace spaces with tabs

curl -sSLo integration_test.go https://bit.ly/2Do5LRN

curl -sSLo Jenkinsfile https://bit.ly/2BsUQWM
```


## The Production Environment

---

```bash
git add .

git commit -m "Added tests"

git push

jx get activity -f environment-jx-rocks-production -w
```
