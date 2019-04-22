## Hands-On Time

---

# Going Serverless


<!-- .slide: data-background="img/serverless-static.png" data-background-size="contain" -->


<!-- .slide: data-background="img/serverless-static-agents.png" data-background-size="contain" -->


<!-- .slide: data-background="img/serverless-teams.png" data-background-size="contain" -->


<!-- .slide: data-background="img/serverless-teams-recovery.png" data-background-size="contain" -->


<!-- .slide: data-background="img/serverless.png" data-background-size="contain" -->


## Installing Serverless Jenkins X

---

```bash
LB_IP=$(kubectl -n kube-system get svc jxing-nginx-ingress-controller \
  -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

DOMAIN=serverless.$LB_IP.nip.io

INGRESS_NS=kube-system

INGRESS_DEP=jxing-nginx-ingress-controller

PROVIDER=[...] # gke, eks, aks, etc

echo "nexus:
  enabled: false
docker-registry:
  enabled: true
" | tee myvalues.yaml
```


## Installing Serverless Jenkins X

---

```bash
jx install --provider $PROVIDER --external-ip $LB_IP --domain $DOMAIN \
    --default-admin-password=admin --ingress-namespace $INGRESS_NS \
    --ingress-deployment $INGRESS_DEP \
    --default-environment-prefix tekton --git-provider-kind github \
    --namespace cd --no-tiller --prow --tekton -b
```


## Exploring Jenkins X Teams

---

```bash
jx get teams

jx team jx

jx team cd
```


## New Quickstart Project

---

```bash
jx create quickstart -l go -p jx-serverless -b

cd jx-serverless

ls -l

cat jenkins-x.yml

jx get activities -f jx-serverless -w

kubectl -n cd get pods

jx get pipelines

jx console

jx get build logs
```


<!-- .slide: data-background="img/serverless-flow-prow.png" data-background-size="contain" -->


<!-- .slide: data-background="img/serverless-flow-pipeline-operator.png" data-background-size="contain" -->


<!-- .slide: data-background="img/serverless-flow-tekton.png" data-background-size="contain" -->


<!-- .slide: data-background="img/serverless-flow.png" data-background-size="contain" -->
