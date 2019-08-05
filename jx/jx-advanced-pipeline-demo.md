<!-- .slide: class="center dark" -->
<!-- .slide: data-background="img/hands-on.jpg" -->
# Extending Jenkins X Pipelines

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 11</div>
<div class="label">Hands-on Time</div>

## In Case You Messed It Up

```bash
cd go-demo-6

git pull

git checkout extension-model-cd && git merge -s ours master --no-edit

git checkout master && git merge extension-model-cd

git push
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 11</div>
<div class="label">Hands-on Time</div>

## Naming Steps And Using Multi-Line Commands

```bash
cat jenkins-x.yml

git checkout -b better-pipeline
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 11</div>
<div class="label">Hands-on Time</div>

## Naming Steps And Using Multi-Line Commands

```bash
echo "buildPack: go
pipelineConfig:
  pipelines:
    pullRequest:
      build:
        preSteps:
        # This was modified
        - name: unit-tests
          command: make unittest
      promote:
        steps:
        # This is new
        - name: rollout
          command: |
            NS=\`echo cd-\$REPO_OWNER-go-demo-6-\$BRANCH_NAME | tr '[:upper:]' '[:lower:]'\`
            sleep 15
            kubectl -n \$NS rollout status deployment preview-preview --timeout 3m
        # This was modified
        - name: functional-tests
          command: ADDRESS=\`jx get preview --current 2>&1\` make functest
" | tee jenkins-x.yml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 11</div>
<div class="label">Hands-on Time</div>

## Naming Steps And Using Multi-Line Commands

```bash
jx step syntax validate pipeline

git add . && git commit -m "rollout status"

git push --set-upstream origin better-pipeline

jx create pullrequest --title "Better pipeline" \
    --body "What I can say?" --batch-mode

BRANCH=[...] # e.g., PR-72
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 11</div>
<div class="label">Hands-on Time</div>

## Naming Steps And Using Multi-Line Commands

```bash
jx get activities --filter go-demo-6/$BRANCH --watch

jx get build logs --current
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 11</div>
<div class="label">Hands-on Time</div>

## Env Variables And Agents

```bash
curl -o Makefile \
    https://gist.githubusercontent.com/vfarcic/313bedd36e863249cb01af1f459139c7/raw

open "https://codecov.io/"

CODECOV_TOKEN=[...]

open "https://github.com/vfarcic/codecov"
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 11</div>
<div class="label">Hands-on Time</div>

## Env Variables And Agents

```bash
echo "buildPack: go
pipelineConfig:
  # This is new
  env:
  - name: CODECOV_TOKEN
    value: \"$CODECOV_TOKEN\"
  pipelines:
    pullRequest:
      build:
        preSteps:
        - name: unit-tests
          command: make unittest
        # This is new
        - name: code-coverage
          command: codecov.sh
          agent:
            image: vfarcic/codecov
      promote:
        steps:
        - name: rollout
          command: |
            NS=\`echo cd-\$REPO_OWNER-go-demo-6-\$BRANCH_NAME | tr '[:upper:]' '[:lower:]'\`
            sleep 15
            kubectl -n \$NS rollout status deployment preview-preview --timeout 3m
        - name: functional-tests
          command: ADDRESS=\`jx get preview --current 2>&1\` make functest
" | tee jenkins-x.yml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 11</div>
<div class="label">Hands-on Time</div>

## Env Variables And Agents

```bash
jx step syntax validate pipeline

git add . && git commit -m "Code coverage" && git push

jx get activities --filter go-demo-6/$BRANCH --watch

jx get build logs --current

kubectl create secret generic codecov \
    --from-literal=token=$CODECOV_TOKEN
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 11</div>
<div class="label">Hands-on Time</div>

## Env Variables And Agents

```bash
echo "buildPack: go
pipelineConfig:
  env:
  # This was modified
  - name: CODECOV_TOKEN
    valueFrom:
      secretKeyRef:
        key: token
        name: codecov
  pipelines:
    pullRequest:
      build:
        preSteps:
        - name: unit-tests
          command: make unittest
        - name: code-coverage
          command: codecov.sh
          agent:
            image: vfarcic/codecov
      promote:
        steps:
        - name: rollout
          command: |
            NS=\`echo cd-\$REPO_OWNER-go-demo-6-\$BRANCH_NAME | tr '[:upper:]' '[:lower:]'\`
            sleep 15
            kubectl -n \$NS rollout status deployment preview-preview --timeout 3m
        - name: functional-tests
          command: ADDRESS=\`jx get preview --current 2>&1\` make functest
" | tee jenkins-x.yml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 11</div>
<div class="label">Hands-on Time</div>

## Env Variables And Agents

```bash
jx step syntax validate pipeline

git add . && git commit -m "Code coverage secret" && git push

jx get activities --filter go-demo-6/$BRANCH --watch
```

* Merge the PR


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 11</div>
<div class="label">Hands-on Time</div>

## Env Variables And Agents

```bash
git checkout master

git pull

git branch -d better-pipeline
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 11</div>
<div class="label">Hands-on Time</div>

## Overrides And Loops

```bash
echo "buildPack: go
pipelineConfig:
  env:
  - name: CODECOV_TOKEN
    valueFrom:
      secretKeyRef:
        key: token
        name: codecov
  pipelines:
    pullRequest:
      build:
        preSteps:
        - name: unit-tests
          command: make unittest
        - name: code-coverage
          command: codecov.sh
          agent:
            image: vfarcic/codecov
      promote:
        steps:
        - name: rollout
          command: |
            NS=\`echo cd-\$REPO_OWNER-go-demo-6-\$BRANCH_NAME | tr '[:upper:]' '[:lower:]'\`
            sleep 15
            kubectl -n \$NS rollout status deployment preview-preview --timeout 3m
        - name: functional-tests
          command: ADDRESS=\`jx get preview --current 2>&1\` make functest
    # This is new
    overrides:
    - pipeline: release
" | tee jenkins-x.yml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 11</div>
<div class="label">Hands-on Time</div>

## Overrides And Loops

```bash
jx step syntax validate pipeline

git add . && git commit -m "Multi-architecture" && git push

jx get activities --filter go-demo-6/master --watch
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 11</div>
<div class="label">Hands-on Time</div>

## Overrides And Loops

```bash
echo "buildPack: go
pipelineConfig:
  env:
  - name: CODECOV_TOKEN
    valueFrom:
      secretKeyRef:
        key: token
        name: codecov
  pipelines:
    pullRequest:
      build:
        preSteps:
        - name: unit-tests
          command: make unittest
        - name: code-coverage
          command: codecov.sh
          agent:
            image: vfarcic/codecov
      promote:
        steps:
        - name: rollout
          command: |
            NS=\`echo cd-\$REPO_OWNER-go-demo-6-\$BRANCH_NAME | tr '[:upper:]' '[:lower:]'\`
            sleep 15
            kubectl -n \$NS rollout status deployment preview-preview --timeout 3m
        - name: functional-tests
          command: ADDRESS=\`jx get preview --current 2>&1\` make functest
    overrides:
    - pipeline: release
      # This is new
      stage: build
    # This is new
    release:
      promote:
        steps:
        - name: rollout
          command: |
            sleep 15
            kubectl -n cd-staging rollout status deployment jx-go-demo-6 --timeout 3m
" | tee jenkins-x.yml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 11</div>
<div class="label">Hands-on Time</div>

## Overrides And Loops

```bash
jx step syntax validate pipeline

git add . && git commit -m "Multi-architecture" && git push

jx get activities --filter go-demo-6/master --watch
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 11</div>
<div class="label">Hands-on Time</div>

## Overrides And Loops

```bash
echo "buildPack: go
pipelineConfig:
  env:
  - name: CODECOV_TOKEN
    valueFrom:
      secretKeyRef:
        key: token
        name: codecov
  pipelines:
    pullRequest:
      build:
        preSteps:
        - name: unit-tests
          command: make unittest
        - name: code-coverage
          command: codecov.sh
          agent:
            image: vfarcic/codecov
      promote:
        steps:
        - name: rollout
          command: |
            NS=\`echo cd-\$REPO_OWNER-go-demo-6-\$BRANCH_NAME | tr '[:upper:]' '[:lower:]'\`
            sleep 15
            kubectl -n \$NS rollout status deployment preview-preview --timeout 3m
        - name: functional-tests
          command: ADDRESS=\`jx get preview --current 2>&1\` make functest
    # Removed overrides
    release:
      promote:
        steps:
        - name: rollout
          command: |
            sleep 15
            kubectl -n cd-staging rollout status deployment jx-go-demo-6 --timeout 3m
" | tee jenkins-x.yml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 11</div>
<div class="label">Hands-on Time</div>

## Overrides And Loops

```bash
jx step syntax effective
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 11</div>
<div class="label">Hands-on Time</div>

## Overrides And Loops

```bash
echo "buildPack: go
pipelineConfig:
  env:
  - name: CODECOV_TOKEN
    valueFrom:
      secretKeyRef:
        key: token
        name: codecov
  pipelines:
    pullRequest:
      build:
        preSteps:
        - name: unit-tests
          command: make unittest
        - name: code-coverage
          command: codecov.sh
          agent:
            image: vfarcic/codecov
      promote:
        steps:
        - name: rollout
          command: |
            NS=\`echo cd-\$REPO_OWNER-go-demo-6-\$BRANCH_NAME | tr '[:upper:]' '[:lower:]'\`
            sleep 15
            kubectl -n \$NS rollout status deployment preview-preview --timeout 3m
        - name: functional-tests
          command: ADDRESS=\`jx get preview --current 2>&1\` make functest
    overrides:
    - pipeline: release
      # This is new
      stage: build
      name: make-build
      steps:
      - loop:
          variable: GOOS
          values:
          - darwin
          - linux
          - windows
          steps:
          - name: build
            command: CGO_ENABLED=0 GOOS=\${GOOS} GOARCH=amd64 go build -o bin/go-demo-6_\${GOOS} main.go
    release:
      promote:
        steps:
        - name: rollout
          command: |
            sleep 15
            kubectl -n cd-staging rollout status deployment jx-go-demo-6 --timeout 3m
" | tee jenkins-x.yml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 11</div>
<div class="label">Hands-on Time</div>

## Overrides And Loops

```bash
jx step syntax validate pipeline

cat Dockerfile

cat Dockerfile | sed -e 's@/bin/ /@/bin/go-demo-6_linux /go-demo-6@g' \
    | tee Dockerfile

git add .

git commit -m "Multi-architecture"

git push

jx get activities --filter go-demo-6/master --watch
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 11</div>
<div class="label">Hands-on Time</div>

## Overrides And Loops

```bash
echo "buildPack: none
pipelineConfig:
  pipelines:
    release:
      pipeline:
        agent:
          image: go
        stages:
        - name: nothing
          steps:
          - name: silly
            command: echo \"This is a silly pipeline\"" \
    | tee jenkins-x.yml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 11</div>
<div class="label">Hands-on Time</div>

## Overrides And Loops

```bash
git add .

git commit -m "Without buildpack"

git push

jx get activities --filter go-demo-6/master --watch
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 11</div>
<div class="label">Hands-on Time</div>

## Exploring The Syntax Schema

```bash
jx step syntax schema

jx step syntax schema --buildpack

jx step syntax validate buildpacks
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 11</div>
<div class="label">Hands-on Time</div>

## What Now?

```bash
git checkout extension-model-cd

git merge -s ours master --no-edit

git checkout master

git merge extension-model-cd

git push
```
