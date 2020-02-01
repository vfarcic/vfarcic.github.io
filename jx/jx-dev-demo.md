<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Improving And Simplifying Software Development

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 6</div>
<div class="label">Hands-on Time</div>

## Exploring The Requirements Of Efficient Development Environment

---


<!-- .slide: data-background="img/vs-code-jx.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 6</div>
<div class="label">Hands-on Time</div>

## In Case You Messed It Up

---

```bash
cd go-demo-6

git checkout buildpack-tekton && git merge -s ours master --no-edit

git checkout master && git merge buildpack-tekton

echo "buildPack: go" | tee jenkins-x.yml

git add . && git commit -m "Added jenkins-x.yml" && git push
```


## Remote Dev Environment

---

```bash
jx create devpod --batch-mode

jx rsh -d

cd go-demo-6

ls -1

go mod init

make linux
```


## Remote Dev Environment

---

```bash
cat skaffold.yaml

echo $DOCKER_REGISTRY

env

helm init --service-account tiller

skaffold run -p dev

echo $SKAFFOLD_DEPLOY_NAMESPACE

kubectl -n $SKAFFOLD_DEPLOY_NAMESPACE get pods
```


## Remote Dev Environment

---

```bash
cat watch.sh

chmod +x watch.sh

nohup ./watch.sh &

exit

jx get applications

URL=[...]

curl "$URL/demo/hello"
```


<!-- .slide: data-background="img/devpod.png" data-background-size="contain" -->


## Using Browser-Based IDE

---

```bash
jx open

jx open [...]

curl "$URL/demo/hello"

jx delete devpod
```


<!-- .slide: data-background="img/devpod-theia.png" data-background-size="contain" -->


## Synchronizing With A DevPod

---

```bash
echo 'unittest: 
	CGO_ENABLED=$(CGO_ENABLED) $(GO) test --run UnitTest -v
' | tee -a Makefile

sed -e \
    's@linux \&\& skaffold@linux \&\& make unittest \&\& skaffold@g' \
    -i watch.sh

jx sync --daemon

jx create devpod --sync -b
```

* Open a second terminal session.

```bash
jx rsh -d

go mod init

helm init --client-only

chmod +x watch.sh

./watch.sh
```


## Synchronizing With A DevPod

---

* Return to the first terminal.

```bash
curl "$URL/demo/hello"

sed -e 's@hello, world@hello, devpod with tests@g' \
    -i main.go

sed -e 's@hello, world@hello, devpod with tests@g' \
    -i main_test.go
```

* Go back to the second terminal and observe the output
* Go to the first terminal

```bash
curl "$URL/demo/hello"
```


<!-- .slide: data-background="img/devpod-ksync.png" data-background-size="contain" -->


## Synchronizing With A DevPod

---

```bash
git add .

git commit -m "devpod"

git push

jx get activity -f go-demo-6 -w

jx get applications

STAGING_URL=[...]

curl "$STAGING_URL/demo/hello"

jx delete devpod
```


## Integrating With VS Code

---


<!-- .slide: data-background="img/vs-code-jx.png" data-background-size="contain" -->


## Integrating With VS Code

---

* Install VS Code from the [official site](https://code.visualstudio.com/)
* *File* > *Open*, select *go-demo-6*, and click the *Open* button
* *View* > *Extensions*, search for *jx*, click *Install* in *jx-tools*
* Click the *Reload* button
* Open *View* > *Explorer*, and expanding the *JENKINS X* tab
* Click the *...* button
* Expand *Pipelines* > *go-demo-6* > *master*
* Open *View* > *Integrated Terminal*
