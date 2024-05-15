## Kubernetes Functions With OpenFunction

```sh
cat function.yaml

kubectl --namespace production apply --filename function.yaml

kubectl --namespace production get functions

kubectl --namespace production get functions

export APP_URL="http://openfunction-demo.production.$INGRESS_IP.nip.io"

curl -X POST \
    "$APP_URL/video?id=1&title=An%20Amazing%20Video"

curl "$APP_URL/videos" | jq .
```


### Questions

* Does this experience work for you? 
* Are the projects used by OpenFunction glued in a way that works for your use case?
* What about application infrastructure that your functions will need? 


### Our findings 1/2

* Use OpenFunctions as an inspiration
* OpenFunctions is great but:
  * It is quite complex for someone who doesn't know all the tools
  * It is hard to debug when things go wrong


### Our findings 2/2

* Companies want to build their own experiences, for example:
  * Full control on your `functions` interfaces
  * Use GitHub actions to build containers and deploy to environments
  * Use ArgoCD to manage environments using GitOps


## What do you need to build your own experience? 1/2

* [Knative Serving](https://knative.dev/docs/concepts/)
  * From Container to URL
  * Check Knative Functions (CLI / Developer Experience)

<a href="https://knative.dev"><img src="../img/products/knative.png" style="width: 20%; height: 20%;"></a>  


## What do you need to build your own experience? 1/2

```
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: my-service
spec:
  template:
    spec:
      containers:
      - image: <YOUR CONTAINER>
```

```sh
kubectl get ksvc --output yaml
```


## What do you need to build your own experience? 2/2

* [Dapr](https://docs.dapr.io/concepts/overview/) 
  * APIs for developers to
    * Connect functions together
    * Connect to infrastructure and service that are available in the environment  

<a href="https://dapr.io"><img src="../img/products/dapr-white.png" style="width: 30%; height: 30%;"></a>


## What do you need to build your own experience? 2/2

<a href="https://dapr.io"><img src="../img/products/dapr-overview.png" style="width: 70%; height: 70%;"></a>


## Kubernetes Functions With OpenFunction

```sh
kubectl get components --oyaml
```

```sh
cat video.go
```
