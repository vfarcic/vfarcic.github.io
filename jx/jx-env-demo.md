## Hands-On Time

---

# Applying GitOps Principles


## Ten Commandments Of GitOps Applied To Continuous Delivery

---

# Git is the only source of truth


<!-- .slide: data-background="img/gitops-apps.png" data-background-size="contain" -->


## Ten Commandments Of GitOps Applied To Continuous Delivery

---

## Everything must be tracked, every action must be reproducible, and everything must be idempotent


## Ten Commandments Of GitOps Applied To Continuous Delivery

---

# Communication between processes must be asynchronous


<!-- .slide: data-background="img/gitops-webhooks.png" data-background-size="contain" -->


## Ten Commandments Of GitOps Applied To Continuous Delivery

---

# Processes should run for as long as needed, but not longer


<!-- .slide: data-background="img/gitops-agents.png" data-background-size="contain" -->


## Ten Commandments Of GitOps Applied To Continuous Delivery

---

# All binaries must be stored in registries


<!-- .slide: data-background="img/gitops-registries.png" data-background-size="contain" -->


## Ten Commandments Of GitOps Applied To Continuous Delivery

---

## Information about all the releases must be stored in environment-specific repositories or branches


## Ten Commandments Of GitOps Applied To Continuous Delivery

---

# Everything must follow the same coding practices


<!-- .slide: data-background="img/gitops-env.png" data-background-size="contain" -->


## Ten Commandments Of GitOps Applied To Continuous Delivery

---

# All deployments must be idempotent


## Ten Commandments Of GitOps Applied To Continuous Delivery

---

## Git webhooks are the only ones allowed to initiate a change that will be applied to the system


## Ten Commandments Of GitOps Applied To Continuous Delivery

---

# All the tools must be able to speak with each other through APIs


## In case you messed it up

---

```bash
git checkout buildpack-tekton

git merge -s ours master --no-edit

git checkout master

git merge buildpack-tekton

git push
```


## Exploring Jenkins X Envs

---

```bash
jx get env

jx get env -p Auto

jx get env -p Manual

jx get env -p Never
```


## Adapting The Staging Env

---

```bash
cd ..

git clone \
    https://github.com/$GH_USER/environment-jx-rocks-staging.git

cd environment-jx-rocks-staging

ls -1

cat Makefile

# Make sure that you use tabs instead of spaces
echo 'test:
	ADDRESS=`kubectl -n jx-staging get ing go-demo-6 \\
	-o jsonpath="{.spec.rules[0].host}"` go test -v' \
    | tee -a Makefile
```


## Adapting The Staging Env

---

```bash
curl -sSLo integration_test.go https://bit.ly/2Do5LRN

cat integration_test.go

cat Jenkinsfile

curl -sSLo Jenkinsfile https://bit.ly/2Dr1Kfk

ls -1 env

cat env/requirements.yaml
```


## Adapting The Staging Env

---

```bash
git add .

git commit -m "Added tests"

git push

jx get activity -f environment-jx-rocks-staging

jx get build logs $GH_USER/environment-jx-rocks-staging/master

jx console

kubectl -n jx-staging get pods
```


## App <> Env Pipelines

---

```bash
cat env/requirements.yaml
```


<!-- .slide: data-background="img/gitops-full-flow.png" data-background-size="contain" -->


## Controlling The Environments

---

```bash
jx create env --name pre-production --label Pre-Production \
    --namespace jx-pre-production --promotion Manual -b

jx get env

jx edit env --name pre-production --promotion Auto

jx delete env pre-production

GH_USER=[...]

hub delete -y $GH_USER/environment-jx-pre-production

cd ..
```
