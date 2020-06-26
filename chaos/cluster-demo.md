<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## ChaosToolkit

```bash
pip install -U chaostoolkit

chaos --help

# If `chaos` fails, you might want to activate the virtual environment.
source ~/.venvs/chaostk/bin/activate \
    && python3 -m venv ~/.venvs/chaostk

pip install -U chaostoolkit-kubernetes
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Kubernetes Cluster

```bash
minikube start --memory 6g --cpus 4
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Demo App

```bash
git clone https://github.com/vfarcic/go-demo-8.git

cd go-demo-8

kubectl create namespace go-demo-8

kubectl --namespace go-demo-8 \
    apply --filename k8s/terminate-pods/pod.yaml
```
