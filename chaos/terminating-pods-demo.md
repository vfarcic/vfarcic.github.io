<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Destroying Application Instances

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Demo App

```bash
git clone https://github.com/vfarcic/go-demo-8.git

cd go-demo-8

cat k8s/terminate-pods/pod.yaml

kubectl create namespace go-demo-8

kubectl --namespace go-demo-8 \
    apply --filename k8s/terminate-pods/pod.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Terminating Application Instances

```bash
cat chaos/terminate-pod.yaml

chaos run chaos/terminate-pod.yaml

echo $?

kubectl --namespace go-demo-8 get pods
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Steady State Hypothesis

```bash
cat chaos/terminate-pod-ssh.yaml

diff chaos/terminate-pod.yaml chaos/terminate-pod-ssh.yaml

chaos run chaos/terminate-pod-ssh.yaml

echo $?
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Steady State Hypothesis

```bash
kubectl --namespace go-demo-8 \
    apply --filename k8s/terminate-pods/pod.yaml

chaos run chaos/terminate-pod-ssh.yaml

echo $?

kubectl --namespace go-demo-8 \
    apply --filename k8s/terminate-pods/pod.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Pausing After Actions

```bash
cat chaos/terminate-pod-pause.yaml

diff chaos/terminate-pod-ssh.yaml chaos/terminate-pod-pause.yaml

chaos run chaos/terminate-pod-pause.yaml

echo $?

kubectl --namespace go-demo-8 \
    apply --filename k8s/terminate-pods/pod.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Phases And Conditions

```bash
kubectl --namespace go-demo-8 describe pod go-demo-8

cat chaos/terminate-pod-phase.yaml

diff chaos/terminate-pod-pause.yaml chaos/terminate-pod-phase.yaml

chaos run chaos/terminate-pod-phase.yaml

echo $?
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Phases And Conditions

```bash
kubectl --namespace go-demo-8 logs go-demo-8

kubectl --namespace go-demo-8 apply --filename k8s/db

kubectl --namespace go-demo-8 rollout status deployment go-demo-8-db

# Repeat until the `go-demo-8` Pod `STATUS` is `Running`
kubectl --namespace go-demo-8 get pods

chaos run chaos/terminate-pod-phase.yaml

echo $?
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Making The App Fault-Tolerant

```bash
cat k8s/terminate-pods/deployment.yaml

kubectl --namespace go-demo-8 \
    apply --filename k8s/terminate-pods/deployment.yaml

kubectl --namespace go-demo-8 rollout status deployment go-demo-8

chaos run chaos/terminate-pod-phase.yaml
```