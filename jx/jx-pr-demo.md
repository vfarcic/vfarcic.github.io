## Hands-On Time

---

# Working With Pull Requests And Preview Environments


<!-- .slide: data-background="img/pr.png" data-background-size="contain" -->


## Exploring Jenkinsfile

---

```bash
cat Jenkinsfile
```


## Creating Pull Requests

---

```bash
git checkout -b my-pr

cat main.go | sed -e "s@hello, devpod with tests@hello, PR@g" \
    | tee main.go

cat main_test.go | sed -e "s@hello, devpod with tests@hello, PR@g" \
    | tee main_test.go

echo "

db:
  enabled: false
  
preview-db:
  persistence:
    enabled: false" | tee -a charts/preview/values.yaml
```


## Creating Pull Requests

---

```bash
git add .

git commit -m "This is a PR"

git push --set-upstream origin my-pr

jx create pr -t "My PR" \
  --body "This is the text that describes the PR and it can span multiple lines" -b
```

* Open the link


## Creating Pull Requests

---

```bash
jx get previews

PR_ADDR=[...]

curl "$PR_ADDR/demo/hello"
```


## Adding Unit Tests

---

```bash
jx create issue -t "Add unit tests" \
    --body "Add unit tests to the CD process" \
    -b

ISSUE_ID=[...]
```

* Open *Jenkinsfile* and add the code that follows

```groovy
sh "make unittest"
```

* Save the changes

```bash
git add .

git commit \
  -m "Added unit tests (fixes #$ISSUE_ID)"

git push

jx get issues -b
```


## Adding Functional Tests

---

```bash
echo '
functest: 
	CGO_ENABLED=$(CGO_ENABLED) $(GO) \\
	test -test.v --run FunctionalTest \\
	--cover
' | tee -a Makefile
```

* Open *Jenkinsfile* and add the code that follows

```groovy
          dir('/home/jenkins/go/src/github.com/vfarcic/go-demo-6') {
            script {
              sleep 15
              addr=sh(script: "kubectl -n jx-$ORG-$HELM_RELEASE get ing $APP_NAME -o jsonpath='{.spec.rules[0].host}'", returnStdout: true).trim()
              sh "ADDRESS=$addr make functest"
            }
          }
```

* Save the changes


## Adding Integration Tests

---

```bash
echo '
integtest: 
	DURATION=1 \\
	CGO_ENABLED=$(CGO_ENABLED) $(GO) \\
	test -test.v --run ProductionTest \\
	--cover
' | tee -a Makefile
```

* Open *Jenkinsfile* and add the code that follows

```groovy
          dir('/home/jenkins/go/src/github.com/vfarcic/go-demo-6') {
            script {
              sleep 15
              addr=sh(script: "kubectl -n jx-staging get ing $APP_NAME -o jsonpath='{.spec.rules[0].host}'", returnStdout: true).trim()
              sh "ADDRESS=$addr make functest"
              sh "ADDRESS=$addr make integtest"
            }
          }
```

* Save the changes


## Adding Integration Tests

---

```bash
git add .

git commit -m "Added integration tests"

git push

jx get build logs

cat charts/go-demo-6/values.yaml

echo "
  usePassword: false" | tee -a charts/go-demo-6/values.yaml

echo "
  usePassword: false" | tee -a charts/preview/values.yaml
```


## Adding Integration Tests

---

```bash
git add .

git commit -m "Removed MongoDB password"

git push
```


## Merging a PR

---

* Open the pull request screen in GitHub
* Click *Merge pull request* button
* Click the *Confirm merge* button.

```bash
jx get activity -f go-demo-6 -w

jx get applications

STAGING_ADDR=[...] # Replace `[...]` with the URL

curl "$STAGING_ADDR/demo/hello"
```


## jx Garbage Collection

---

```bash
kubectl get cronjobs

jx get previews

jx gc previews

jx get previews
```
