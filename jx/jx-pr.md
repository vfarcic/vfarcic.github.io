## Exploring The Jenkinsfile

---

```bash
cat Jenkinsfile
```


## Creating a PR

---

```bash
git checkout -b my-pr

cat main.go | sed -e "s@hello, world@hello, PR@g" | tee main.go

cat main_test.go | sed -e "s@hello, world@hello, PR@g" \
    | tee main_test.go

git add . && git commit -m "This is a PR"

git push --set-upstream origin my-pr

open "https://github.com/$GH_USER/go-demo-6/pull/new/my-pr"
```

* Click the `Create pull request` button


## Creating a PR

---

```bash
jx get activity -f go-demo-6 -w

URL=[...] # Copy the address from `Preview Application`

curl "$URL/demo/hello"

helm ls

jx get build log
```


## Adding Unit Tests

---

```bash
jx create issue -t "Add unit tests" \
    --body "Add unit tests to the CD process"

ISSUE_ID=[...]

echo '
unit-test: 
	CGO_ENABLED=$(CGO_ENABLED) $(GO) test $(PACKAGE_DIRS) -test.v --run UnitTest --cover' \
    | tee -a Makefile

vim Jenkinsfile
```

* Add `sh "make unit-test"` after `checkout scm`

```bash
git add . && git commit -m "Added unit tests #$ISSUE_ID" && git push
```


## Adding Unit Tests

---

```bash
jx get build log -t

jx get activity -f go-demo-6 -w
```


## Adding Functional Tests

---

```bash
echo '
func-test: 
	CGO_ENABLED=$(CGO_ENABLED) $(GO) test $(PACKAGE_DIRS) -test.v --run FunctionalTest --cover' \
    | tee -a Makefile

vim Jenkinsfile
```

* Add the code that follows as the last step in the `CI Build and push snapshot` stage

```groovy
          dir('/home/jenkins/go/src/github.com/vfarcic/go-demo-6') {
            script {
              sleep 10
              addr=sh(script: "kubectl -n jx-$CHANGE_AUTHOR-$HELM_RELEASE get ing $APP_NAME -o jsonpath='{.spec.rules[0].host}'", returnStdout: true).trim()
              sh "ADDRESS=$addr make func-test"
            }
          }
```


## Adding Functional Tests

---

```bash
git add . && git commit -m "Added functional tests" && git push

jx get build log -t

jx get activity -f go-demo-6
```


## Adding Production Tests

---

```bash
echo '
prod-test: 
	DURATION=1 CGO_ENABLED=$(CGO_ENABLED) $(GO) test $(PACKAGE_DIRS) -test.v --run ProductionTest --cover' \
    | tee -a Makefile

vim Jenkinsfile
```

* Add the code that follows as the last step in the `Promote to Environments` stage

```groovy
          dir('/home/jenkins/go/src/github.com/vfarcic/go-demo-6') {
            script {
              sleep 10
              addr=sh(script: "kubectl -n jx-staging get ing $APP_NAME -o jsonpath='{.spec.rules[0].host}'", returnStdout: true).trim()
              sh "ADDRESS=$addr make prod-test"
            }
          }
```


## Adding Production Tests

---

```bash
git add . && git commit -m "Added production tests" && git push

jx get build log -t

jx get activity -f go-demo-6
```


## Merging a PR

---

* Open the `Preview` link
* Click the *Merge pull request* button
* Click the *Confirm merge* button

```bash
jx get activity -f go-demo-6 -w

curl $STAGING_URL
```
