## Setup

```bash
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl"

chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/kubectl

kubectl version

minikube start

kubectl cluster-info

kubectl get nodes
```

## Deployment

```bash
kubectl run kubernetes-bootcamp --image=docker.io/jocatalin/kubernetes-bootcamp:v1 --port=8080

kubectl get deployments

kubectl proxy

export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')

echo "Pods:\n$POD_NAME"

curl "http://localhost:8001/api/v1/proxy/namespaces/default/pods/$POD_NAME/"

kubectl get pods

kubectl describe pods

kubectl logs $POD_NAME

kubectl exec $POD_NAME env

kubectl exec -ti $POD_NAME bash

cat server.js

curl "localhost:8080"

exit

# TODO: https://kubernetes.io/docs/tutorials/kubernetes-basics/expose-intro/
```