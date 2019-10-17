<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Using Services To Enable Communication Between Pods

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Exposing Ports

```bash
cat svc/go-demo-2-rs.yml

kubectl create -f svc/go-demo-2-rs.yml

kubectl get -f svc/go-demo-2-rs.yml
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Exposing Ports

```bash
# If minikube
kubectl expose rs go-demo-2 --name=go-demo-2-svc --target-port=28017 \
    --type=NodePort

# If EKS or GKE
kubectl expose rs go-demo-2 --name=go-demo-2-svc --target-port=28017 \
    --type=LoadBalancer
```

Note:
Looking at the yml file we customized the command and the arguments so that MongoDB exposes the REST interface. Those additions are needed so that we can test that the database is accessible through the Service. We can use the kubectl expose command to expose a resource as a new Kubernetes Service. That resource can be a Deployment, another Service, a ReplicaSet, a ReplicationController, or a Pod. We'll expose the ReplicaSet since it is already running in the cluster. In this exercise we show how to create two different services.
* We recreated the *go-demo-2* ReplicaSet
* We exposed the port `28017` of the ReplicaSet `go-demo-2` using imperative process
* `NodePort` type exposes the port on all of the worker nodes of the cluster
* `LoadBalancer` acts as `NodePort`, but it also creates an external load balancer


<!-- .slide: data-background="img/seq_svc_ch05.png" data-background-size="contain" -->

Note:
1. Kubernetes client (kubectl) sent a request to the API server requesting the creation of the Service based on Pods created through the go-demo-2 ReplicaSet.
2. Endpoint controller is watching the API server for new service events. It detected that there is a new Service object.
3. Endpoint controller created endpoint objects with the same name as the Service, and it used Service selector to identify endpoints (in this case the IP and the port of go-demo-2 Pods).
4. kube-proxy is watching for service and endpoint objects. It detected that there is a new Service and a new endpoint object.
5. kube-proxy added iptables rules which capture traffic to the Service port and redirect it to endpoints. For each endpoint object, it adds iptables rule which selects a Pod.
6. The kube-dns add-on is watching for Service. It detected that there is a new service.
7. The kube-dns added db's record to the dns

<!-- .slide: data-background="img/comp_svc_ch05.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Exposing Ports

```bash
kubectl describe svc go-demo-2-svc

# If minikube
PORT=$(kubectl get svc go-demo-2-svc \
    -o jsonpath="{.spec.ports[0].nodePort}")

# If EKS or GKE
PORT=28017
```

Note:
* We described the newly created Service
* We retrieved the port through which we can access the new Service
* EKS and GKE opened the same port in `loadBalancer` as the target port, and it forwards requests to the randomly generated NodePort


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Exposing Ports

```bash
# If minikube
IP=$(minikube ip)

# If EKS
IP=$(kubectl get svc go-demo-2-svc \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# If GKE
IP=$(kubectl get svc go-demo-2-svc \
    -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
```

Note:
* We retrieved the IP/address through which we can access the new Service
* minikube's address is the IP of the VM
* EKS' address is the address of the ELB
* GKE' address is the IP of the ELB


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Exposing Ports

```bash
open "http://$IP:$PORT"

kubectl delete svc go-demo-2-svc
```

Note:
* We validated that MongoUI is accessible through the Service
* We deleted the Service


<!-- .slide: data-background="img/svc-expose-rs.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Declarative Syntax

```bash
# If minikube
cat svc/go-demo-2-svc.yml

# If EKS or GKE
cat svc/go-demo-2-svc-lb.yml

# If minikube
kubectl create -f svc/go-demo-2-svc.yml

# If EKS or GKE
kubectl create -f svc/go-demo-2-svc-lb.yml
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Declarative Syntax

```bash
kubectl get -f svc/go-demo-2-svc.yml
```

Note:
 When we cat the file we see the selector is used by the Service to know which Pods should receive requests. It works in the same way as ReplicaSet selectors. In this case, we defined that the service should forward requests to Pods with labels type set to backend and service set to go-demo. Those two labels are set in the Pods spec of the ReplicaSet.
* We created a Service using declarative syntax (YAML)
* We retrieved the basic info about the newly created Service
* The difference between minikube and EKS/GKE Service is in `type` (`NodePort` or `LoadBalancer`)


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Declarative Syntax

```bash
# If EKS
IP=$(kubectl get svc go-demo-2 \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# If GKE
IP=$(kubectl get svc go-demo-2 \
    -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

# If minikube
PORT=30001

open "http://$IP:$PORT"
```

Note:
* We retrieved the IP/address and the port
* minikube's IP is the same as it was, EKS and GKE created a new ELB with a new address
* EKS and GKE open the same port in ELB as target port, so it's left unchanged


<!-- .slide: data-background="img/svc-hard-coded-port.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Declarative Syntax

```bash
kubectl delete -f svc/go-demo-2-svc.yml

kubectl delete -f svc/go-demo-2-rs.yml
```

Note:
Now we can clean up the cluster by deleting the ReplicaSet and Service


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Communication Through Services

```bash
cat svc/go-demo-2-db-rs.yml

kubectl create -f svc/go-demo-2-db-rs.yml

cat svc/go-demo-2-db-svc.yml

kubectl create -f svc/go-demo-2-db-svc.yml

cat svc/go-demo-2-api-rs.yml

kubectl create -f svc/go-demo-2-api-rs.yml
```

Note:
When we at the `go-demo-2-api-rs` file:
The number of replicas is set to 3. That solves one of the main problems we had with the previous ReplicaSets that defined Pods with both containers. Now the number of replicas can differ, and we have one Pod for the database, and three for the backend API. The type label is set to api so that both the ReplicaSet and the (soon to come) Service can distinguish the Pods from those created for the database. We have the environment variable DB set to go-demo-2-db. The code behind the vfarcic/ go-demo-2 image is written in a way that the connection to the database is established by reading that variable. In this case, we can say that it will try to connect to the database running on the DNS go-demo-2-db. If you go back to the database Service definition, you'll notice that its name is go-demo-2-db as well. If everything works correctly, we should expect that the DNS was created with the Service and that it'll forward requests to the database. The `readinessProbe` has the same fields as the `livenessProbe`. We used the same values for both, except for the `periodSeconds`, where instead of relying on the default value of 10, we set it to 1. While livenessProbe is used to determine whether a Pod is alive or it should be replaced by a new one, the readinessProbe is used by the iptables. A Pod that does not pass the readinessProbe will be excluded and will not receive requests. In theory, Requests might be still sent to a faulty Pod, between two iterations. Still, such requests will be small in number since the iptables will change as soon as the next probe responds with HTTP code less than 200, or equal or greater than 400.

* We created a ReplicaSet with a DB
* We created a Service type `ClusterIP` for the DB
* We created a ReplicaSet with the API


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Communication Through Services

```bash
# If minikube
cat svc/go-demo-2-api-svc.yml

# If EKS or GKE
cat svc/go-demo-2-api-svc-lb.yml

# If minikube
kubectl create -f svc/go-demo-2-api-svc.yml

# If EKS or GKE
kubectl create -f svc/go-demo-2-api-svc-lb.yml
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Communication Through Services

```bash
kubectl get all
```

Note:
* We created a Service for the API
* We listed all the resources we created
* For minikube we used Service type `NodePort`
* For EKS or GKE we used Service type `LoadBalancer`


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Communication Through Services

```bash
# If EKS
IP=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# If GKE
IP=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

# If minikube
PORT=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.spec.ports[0].nodePort}")
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Communication Through Services

```bash
# If EKS or GKE
PORT=8080

curl -i "http://$IP:$PORT/demo/hello"
```

Note:
Before running `kubectl get svc...` it is worth mentioning that the code behind the vfarcic/ go-demo-2 image is designed to fail if it cannot connect to the database. The fact that the three replicas of the go-demo-2-api Pod are running means that the communication is established.
* We retrieved API Service address and port
* We sent a request to the API to confirm that it is accessible
* EKS or GKE created a new ELB so the IP changed
* The Service in minikube exposed a new random port
* The port of the Service in EKS or GKE is the same as the target port


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Communication Through Services

```bash
kubectl delete -f svc/go-demo-2-db-rs.yml

kubectl delete -f svc/go-demo-2-db-svc.yml

kubectl delete -f svc/go-demo-2-api-rs.yml

kubectl delete -f svc/go-demo-2-api-svc.yml
```

Note:
Now we are going to cleanup the cluster by deleting everything created from the various yml files.


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Multiple Resources In YAML

```bash
# If minikube
cat svc/go-demo-2.yml

# If EKS or GKE
cat svc/go-demo-2-lb.yml

# If minikube
kubectl create -f svc/go-demo-2.yml

# If EKS or GKE
kubectl create -f svc/go-demo-2-lb.yml
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Multiple Resources In YAML

```bash
kubectl get -f svc/go-demo-2.yml
```

Note:
The vfarcic/ go-demo-2 and mongo images form the same stack. They work together and having four YAML definitions is confusing. It would get even more confusing later on since we are going to add more objects to the stack. Things would be much simpler and easier if we would move all the objects we created thus far into a single YAML definition. Fortunately, that is very easy to accomplish. In the following example we created all the resources from a single YAML file. Afterwards we will confirm all the resources are created.


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Multiple Resources In YAML

```bash
# If EKS
IP=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# If GKE
IP=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

# If minikube
PORT=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.spec.ports[0].nodePort}")
```

Note:
* We retrieved the IP and the port of the API Service
* EKS or GKE created a new ELB so the IP changed
* The Service in minikube exposed a new random port


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Multiple Resources In YAML

```bash
curl -i "http://$IP:$PORT/demo/hello"

POD_NAME=$(kubectl get pod --no-headers \
    -o=custom-columns=NAME:.metadata.name \
    -l type=api,service=go-demo-2 | tail -1)

kubectl exec $POD_NAME env
```

Note:
* We are going to send a request to confirm that the API is accessible through the Service
* We going to list the environment variables in one of the Pods to display Service-specific info
The first five variables are using the Docker format. If you already worked with Docker networking, you should be familiar with them. At least, if you're familiar with the way Swarm (standalone) and Docker Compose operate. Later version of Swarm (Mode) still generate the environment variables but they are mostly abandoned by the users in flavor of DNSes.
 1. GO_DEMO_2_DB_PORT = tcp:// 10.0.0.250: 27017
 2. GO_DEMO_2_DB_PORT_27017_TCP_ADDR = 10.0.0.250
 3. GO_DEMO_2_DB_PORT_27017_TCP_PROTO = tcp
 4. GO_DEMO_2_DB_PORT_27017_TCP_PORT = 27017
 5. GO_DEMO_2_DB_PORT_27017_TCP = tcp:// 10.0.0.250: 27017
 6. GO_DEMO_2_DB_SERVICE_HOST = 10.0.0.250
 7. GO_DEMO_2_DB_SERVICE_PORT = 27017

The last two environment variables are Kubernetes specific and follow the `[SERVICE_NAME]SERVICE_HOST `and `[SERVICE_NAME]_SERIVCE_PORT` format (service name is upper-cased). No matter which set of environment variables


<!-- .slide: data-background="img/flow_svc_ch05.png" data-background-size="contain" -->

Note:
1. When the api container go-demo-2 tries to connect with the go-demo-2-db Service, it looks at the nameserver configured in /etc/ resolv.conf. kubelet configured the nameserver with the kube-dns Service IP (10.96.0.10) during the Pod scheduling process.
2. The container queries the DNS server listening to port 53. go-demo-2-db DNS gets resolved to the service IP 10.0.0.19. This DNS record was added by kube-dns during the service creation process.
3. The container uses the service IP which forwards requests through the iptables rules. They were added by kube-proxy during Service and Endpoint creation process.
4. Since we only have one replica of the go-demo-2-db Pod, iptables forwards requests to just one endpoint. If we had multiple replicas, iptables would act as a load balancer and forward requests randomly among Endpoints of the Service.


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Services?

* Communication between Pods<!-- .element: class="fragment" -->
* Communication from outside the cluster<!-- .element: class="fragment" -->


<!-- .slide: data-background="img/svc-components.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## What Now?

```bash
kubectl delete -f svc/go-demo-2.yml
```
