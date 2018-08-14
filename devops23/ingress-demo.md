## Hands-On Time

---

# Using Ingress To Forward Traffic


## Services Deficiencies

---

```bash
# If minikube
kubectl create -f ingress/go-demo-2-deploy.yml

# If EKS
kubectl create -f ingress/go-demo-2-deploy-lb.yml

kubectl get -f ingress/go-demo-2-deploy.yml

kubectl get pods
```


## Services Deficiencies

---

* We created API and DB Deployments and Services
* We retrieved the Pods and confirmed that they are running


## Services Deficiencies

---

```bash
# If minikube
API_IP=$(minikube ip)

# If EKS
API_IP=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# If minikube
API_PORT=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.spec.ports[0].nodePort}")

# If EKS
API_PORT=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.spec.ports[0].port}")

curl -i "http://$API_IP:$API_PORT/demo/hello"
```


## Services Deficiencies

---

* We retrieved IP/address and port of the API Service
* We sent a request to the API and confirmed that it is accessible


## Services Deficiencies

---

```bash
# If minikube
kubectl create -f ingress/devops-toolkit-dep.yml \
    --record --save-config

# If EKS
kubectl create -f ingress/devops-toolkit-dep-lb.yml \
    --record --save-config

kubectl get -f ingress/devops-toolkit-dep.yml
```


## Services Deficiencies

---

* We created a Deployment and a Service for UI application


## Services Deficiencies

---

```bash
# If minikube
UI_IP=$(minikube ip)

# If EKS
UI_IP=$(kubectl get svc devops-toolkit \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# If minikube
UI_PORT=$(kubectl get svc devops-toolkit \
    -o jsonpath="{.spec.ports[0].nodePort}")

# If EKS
UI_PORT=$(kubectl get svc devops-toolkit \
    -o jsonpath="{.spec.ports[0].port}")
```


## Services Deficiencies

---

* We retrieved the IP/address and the port of the UI


## Services Deficiencies

---

```bash
open "http://$UI_IP:$UI_PORT"

curl "http://$UI_IP/demo/hello"

curl -i -H "Host: devopstoolkitseries.com" "http://$UI_IP"
```


## Services Deficiencies

---

* We opened UI in browser
* We confirmed that the API is NOT accessible without the port
* We confirmed that the UI is NOT accessible on a specific domain and without the port


<!-- .slide: data-background="img/services.png" data-background-size="contain" -->


## Enabling Ingress (minikube)

---

```bash
# If minikube
minikube addons list

# If minikube
minikube addons enable ingress

IP=$(minikube ip)
```


## Enabling Ingress (minikube)

---

* We listed all the available minikube addons
* We enabled the `ingress` addon
* We retrieved the IP of the minikube VM


## Enabling Ingress (EKS)

---

```bash
kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml

kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/aws/service-l4.yaml

kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/aws/patch-configmap-l4.yaml

IP=$(kubectl -n ingress-nginx get svc ingress-nginx \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

echo $IP
```


## Enabling Ingress (EKS)

---

* We installed NGINX Ingress resources
* We retrieved the address of the ELB created by the Ingress Service


## Enabling Ingress

---

```bash
curl -i "http://$IP/healthz"

curl -i "http://$IP/something"
```


## Enabling Ingress

---

* We retrieved Ingress' health status
* We confirmed that random addresses return `404 Not Found`


## Ingress Based On Paths

---

```bash
cat ingress/go-demo-2-ingress.yml

kubectl create -f ingress/go-demo-2-ingress.yml

kubectl get -f ingress/go-demo-2-ingress.yml

curl -i "http://$IP/demo/hello"

kubectl delete -f ingress/go-demo-2-ingress.yml

kubectl delete -f ingress/go-demo-2-deploy.yml

kubectl delete -f ingress/devops-toolkit-dep.yml
```


## Ingress Based On Paths

---

* We created an Ingress resource tied to `go-demo-2-api` Service and `/demo` path
* We sent a request to `/demo/hello` and got a response from the API
* We deleted all the resources we created


## Ingress Based On Paths

---

```bash
cat ingress/go-demo-2.yml

kubectl create -f ingress/go-demo-2.yml --record --save-config

curl -i "http://$IP/demo/hello"
```


## Ingress Based On Paths

---

* We created all go-demo-2 resources from a single YAML file
* We confirmed that Ingress is working by sending a request


<!-- .slide: data-background="img/seq_ingress_ch07.png" data-background-size="contain" -->


## Ingress Based On Paths

---

```bash
cat ingress/devops-toolkit.yml

kubectl create -f ingress/devops-toolkit.yml --record --save-config

kubectl get ing

open "http://$IP"

curl "http://$IP/demo/hello"
```


## Ingress Based On Paths

---

* We created all UI resources from a single YAML file
* We listed Ingress resources and confirmed that both exist
* We opened UI in browser and sent a request to the API using the same address


<!-- .slide: data-background="img/ingress.png" data-background-size="contain" -->


## Ingress Based On Domains

---

```bash
cat ingress/devops-toolkit-dom.yml

kubectl apply -f ingress/devops-toolkit-dom.yml --record

curl -I "http://$IP"

curl -I -H "Host: devopstoolkitseries.com" "http://$IP"

curl -H "Host: acme.com" "http://$IP/demo/hello"
```


## Ingress Based On Domains

---

* We changed UI Ingress to allow only requests from *devopstoolkitseries.com* domain
* We confirmed that a request without a domain returns `404 Not Found`
* We confirmed that a request with the domain returns `200 OK`
* We confirmed that `/demo/hello` is still accessible through any domain


## Ingress With Default Backends

---

```bash
curl -I -H "Host: acme.com" "http://$IP"

cat ingress/default-backend.yml

kubectl create -f ingress/default-backend.yml

curl -I -H "Host: acme.com" "http://$IP"
```


## Ingress With Default Backends

---

* We confirmed that requests to a random domain return `404 Not Found`
* We created a default (catch all) Ingress
* We confirmed that requests to a domain/path not covered by other Ingress rules are responded by the default Ingress


<!-- .slide: data-background="img/ingress-components.png" data-background-size="contain" -->


## What Now?

---

```bash
kubectl delete -f ingress/default-backend.yml

kubectl delete -f ingress/devops-toolkit-dom.yml

kubectl delete -f ingress/go-demo-2.yml
```
