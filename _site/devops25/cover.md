<!--
cd k8s-specs

gcloud container clusters create devops25 --region us-east1 --machine-type n1-standard-1 --enable-autoscaling --num-nodes 1 --max-nodes 3 --min-nodes 1

kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $(gcloud config get-value account)

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml

kubectl create -f https://raw.githubusercontent.com/vfarcic/k8s-specs/master/helm/tiller-rbac.yml --record --save-config

helm init --service-account tiller

kubectl -n kube-system rollout status deploy tiller-deploy

export LB_IP=$(kubectl -n ingress-nginx get svc ingress-nginx -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

echo $LB_IP

PROM_ADDR=mon.$LB_IP.nip.io

AM_ADDR=alertmanager.$LB_IP.nip.io

helm upgrade -i prometheus stable/prometheus --namespace metrics --version 7.1.3 --set server.ingress.hosts={$PROM_ADDR} --set alertmanager.ingress.hosts={$AM_ADDR} -f mon/prom-values.yml --wait

kubectl apply -f scaling/go-demo-5-no-hpa.yml
-->
### The DevOps 2.5 Toolkit

# Monitoring, Logging, and Auto-Scaling Kubernetes

---

## [Viktor Farcic](http://technologyconversations.com/about/)

---

#### [@vfarcic](https://twitter.com/vfarcic)

#### [TechnologyConversations.com](http://technologyconversations.com)

#### [CloudBees.com](https://www.cloudbees.com)
    