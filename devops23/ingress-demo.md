## Hands-On Time

---

# Using Ingress To Forward Traffic


## Services Deficiencies

---

```bash
# If minikube
kubectl create -f ingress/go-demo-2-deploy.yml

# If EKS or GKE
kubectl create -f ingress/go-demo-2-deploy-lb.yml

kubectl get -f ingress/go-demo-2-deploy.yml

kubectl get pods
```

Note:
We cannot explore solutions before we know what the problems are. Therefore, we’ll re-create a few objects using the knowledge we already gained. That will let us see whether Kubernetes Services satisfy all the needs users of our applications might have. Or, to be more explicit, we’ll explore which features we’re missing when making our applications accessible to users. We already discussed that it is a bad practice to publish fixed ports through Services. That method is likely to result in conflicts or, at the very least, create the additional burden of carefully keeping track of which port belongs to which Service. We already discarded that option before, and we won’t change our minds now. Since we’ve clarified that, let’s go back and create the Deployments and the Services from the previous chapter.


## Services Deficiencies

---

```bash
# If minikube
API_IP=$(minikube ip)

# If EKS
API_IP=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# If GKE
API_IP=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
```

Note:
We retrieved IP/address of the API Service


## Services Deficiencies

---

```bash
# If minikube
API_PORT=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.spec.ports[0].nodePort}")

# If EKS or GKE
API_PORT=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.spec.ports[0].port}")

curl -i "http://$API_IP:$API_PORT/demo/hello"
```

Note:
While publishing a random, or even a hard-coded port of a single application might not be so bad, if we’d apply the same principle to more applications, the user experience would be horrible. To make the point a bit clearer, we’ll deploy another application. In this exercise we will:
* Retrieve port of the API Service
* Run a curl command and confirmed that it is accessible


## Services Deficiencies

---

```bash
# If minikube
kubectl create -f ingress/devops-toolkit-dep.yml \
    --record --save-config

# If EKS or GKE
kubectl create -f ingress/devops-toolkit-dep-lb.yml \
    --record --save-config

kubectl get -f ingress/devops-toolkit-dep.yml
```

Note:
This is a second application being deployed inside the same cluster.



## Services Deficiencies

---

```bash
# If minikube
UI_IP=$(minikube ip)

# If EKS
UI_IP=$(kubectl get svc devops-toolkit \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# If GKE
UI_IP=$(kubectl get svc devops-toolkit \
    -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
```

Note:
* We retrieved the IP/address of the UI


## Services Deficiencies

---

```bash
# If minikube
UI_PORT=$(kubectl get svc devops-toolkit \
    -o jsonpath="{.spec.ports[0].nodePort}")

# If EKS or GKE
UI_PORT=$(kubectl get svc devops-toolkit \
    -o jsonpath="{.spec.ports[0].port}")
```

Note:
* We retrieved the port of the UI


## Services Deficiencies

---

```bash
open "http://$UI_IP:$UI_PORT"

curl "http://$UI_IP/demo/hello"

curl -i -H "Host: devopstoolkitseries.com" "http://$UI_IP"
```

Note:
The `open` command should display The DevOps Toolkit Books page. If you don't, you might want to wait a bit longer
* We will also confirm that the API is NOT accessible without the port
* Finally, the UI is NOT accessible on a specific domain and without the port


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

# Repeat if empty
```

Note:
* We installed NGINX Ingress resources
* We retrieved the address of the ELB created by the Ingress Service


## Enabling Ingress (GKE)

---

```bash
kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml

kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml

IP=$(kubectl -n ingress-nginx get svc ingress-nginx \
    -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

echo $IP

# Repeat if empty
```

Note:
* We installed NGINX Ingress resources
* We retrieved the address of the ELB created by the Ingress Service


## Enabling Ingress

---

```bash
curl -i "http://$IP/healthz"

curl -i "http://$IP/something"
```

Note:
The `curl` command on `healthz` responded with the status code 200 OK, thus indicating that it is healthy and ready to serve requests. There’s not much more to it so we’ll move to the second endpoint. The Ingress Controller has a default catch-all endpoint that is used when a request does not match any of the other criteria. Since we did not yet create any Ingress Resource, this endpoint should provide the same response to all requests except /healthz.


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

Note:
Looking at the YAML file this time, metadata contains a field we haven’t used before. The annotations section allows us to provide additional information to the Ingress Controller. As you’ll see soon, Ingress API specification is concise and limited. That is done on purpose. The specification API defines only the fields that are mandatory for all Ingress Controllers. All the additional info an Ingress Controller needs is specified through annotations. That way, the community behind the Controllers can progress at great speed, while still providing basic general compatibility and standards. Here we will create Ingress resource tied to `go-demo-2-api` Service and `/demo` path. When we send a request to `/demo/hello` and got a response from the API. Then we can delete all the resources we created



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
