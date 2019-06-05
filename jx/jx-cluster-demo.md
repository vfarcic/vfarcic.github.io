## Hands-On Time

---

### Creating A
# Jenkins-X
## Cluster


## Prerequisites

---

* [Git](https://git-scm.com/)
* GitBash (if using Windows)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [Helm](https://helm.sh/)
* If Google: [gcloud CLI](https://cloud.google.com/sdk/docs/quickstarts) and GCP admin permissions
* If Azure: [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) and Azure admin permissions
* If AWS: [AWS CLI](https://aws.amazon.com/cli/) and AWS admin permissions


## Creating A Cluster With jx

---

```bash
echo "nexus:
  enabled: false
" | tee myvalues.yaml
```


## Creating A Cluster With jx (GKE)

---

```bash
open "https://console.cloud.google.com/cloud-resource-manager"

PROJECT=[...] # e.g. devops26

# Use default answers except in the case specified below.
# Answer `Static Jenkins Server and Jenkinsfiles` when asked to `select Jenkins installation type`

jx create cluster gke -n jx-rocks -p $PROJECT -r us-east1 \
    -m n1-standard-2 --min-num-nodes 1 --max-num-nodes 2 \
    --default-admin-password=admin \
    --default-environment-prefix jx-rocks --git-provider-kind github
```


## Creating A Cluster With jx (AKS)

---

```bash
# Use default answers except in the case specified below.
# Answer `Static Jenkins Server and Jenkinsfiles` when asked to `select Jenkins installation type`

jx create cluster aks -c jxrocks -n jxrocks-group -l eastus \
    -s Standard_B2s --nodes 3 --default-admin-password=admin \
    --default-environment-prefix jx-rocks \
    --git-provider-kind github
```


## Creating A Cluster With jx (EKS)

---

```bash
export AWS_ACCESS_KEY_ID=[...] # Replace [...] with the AWS Access Key ID

export AWS_SECRET_ACCESS_KEY=[...] # Replace [...] with the AWS Secret Access Key

export AWS_DEFAULT_REGION=us-west-2

# Use default answers except in the case specified below.
# Answer with `n` to `Would you like to register a wildcard DNS ALIAS to point at this ELB address?`
# Answer `Static Jenkins Server and Jenkinsfiles` when asked to `select Jenkins installation type`

jx create cluster eks -n jx-rocks -r $AWS_DEFAULT_REGION \
    --node-type t2.medium --nodes 3 --nodes-min 3 --nodes-max 6 \
    --default-admin-password=admin \
    --default-environment-prefix jx-rocks \
    --git-provider-kind github
```


<!--
rm -f $PWD/workshop_config.yaml

export KUBECONFIG=workshop_config.yaml

gcloud auth login

gcloud container clusters \
    create jx-workshop \
    --region us-east1 \
    --machine-type n1-standard-4	 \
    --enable-autoscaling \
    --num-nodes 1 \
    --max-nodes 10 \
    --min-nodes 1

kubectl create clusterrolebinding \
    cluster-admin-binding \
    --clusterrole cluster-admin \
    --user $(gcloud config get-value account)

kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml

kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml
-->
## Creating A Cluster With jx (Workshop)

---

Available only during this workshop

```bash
echo "apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURDekNDQWZPZ0F3SUJBZ0lRRzJVV0dBV1FLRDZudUVYak9Fa0dqekFOQmdrcWhraUc5dzBCQVFzRkFEQXYKTVMwd0t3WURWUVFERXlRMk1tWXhNREl6WXkwMFltTXdMVFF4TVRZdFlqTTBOUzAzTmpCbU5EQXhZVEExWkRjdwpIaGNOTVRrd05UQTRNRFUwTmpFeldoY05NalF3TlRBMk1EWTBOakV6V2pBdk1TMHdLd1lEVlFRREV5UTJNbVl4Ck1ESXpZeTAwWW1Nd0xUUXhNVFl0WWpNME5TMDNOakJtTkRBeFlUQTFaRGN3Z2dFaU1BMEdDU3FHU0liM0RRRUIKQVFVQUE0SUJEd0F3Z2dFS0FvSUJBUURFZUYwMGZVSjdKR0U5azFxV0U4dXhDN3p3Q2xBNE1yaW9WTlFDaVd2SQpmMDNpdzZJK1MycUpXZjFOSEtMNkNhdlJEcVlZRDNMbkpPRzNNdXpHYmlSc2lsZHVtRFhpbTl5cXVGQmJRb2R3ClRtQ3BrQjNycDlDRnpPanh1MERZWTdIZ1pyYVlGUTZVYkFmT29UUVhQWGJSOEhVMDluTGUvMTJJcWlFa0ZZYUsKRUovOWM3eTVPd3dOZlV2Sm14TWJlNlFLVzRmTDFIK05POHp4TWY5Ym5HRE1ub1BLcVYzVzVYMitndGFqckFMeQpYb09adnBqdm9QOFFUWk5UWktkc3p6R1QrS0pqSXhtazg1K3hseTV3anFzbThabTg2UkkvSXVSenFZa0IrZ1ZxCjdrd1Y5WXVlYnFiNXZtdGNsNHpVek56bUJDT25hbmJvTjRLOHBQaVFLUzJYQWdNQkFBR2pJekFoTUE0R0ExVWQKRHdFQi93UUVBd0lDQkRBUEJnTlZIUk1CQWY4RUJUQURBUUgvTUEwR0NTcUdTSWIzRFFFQkN3VUFBNElCQVFBUQprZGF4MFhxZW1qalROdWxONVEzem52TVVvRlhncXh6Nitmek1LQ1MxcVRXOWdmZHVLN3JURjFVMVJDV2kxcWtPCndXa2pieVVQKzZnVVp5VFFoZ3Zpb1YvdEhTbW9JTGVRdUlrRGZROHh5bTNYamxYc2o0d1MwVEJMTmRNbUk1MXkKU2hVM2VkYmZhWWh5TXRlN2Y3M01tS01UWHFtUFREMitjaE55TGk4dno1VGhDMmtDK2xvWFRFc1pkZmpBeldIeApvZHc0VlJUTEV1U1dCSDl1d1Fwai9GaE5Va3VsR3NuMkN2Um90c2R0NmxDQVc4cXY5NCs1THZ0cjNGdkxJMW5DClhIYVY1em9BdzNnT1p6bjZSUEoyejFwVFZEdlFmVnkrTUk5NXhrU2tzRTdRNUw1T1BGN0NjR1dYNEF3eFgvWUYKMlpPclFwSFFCcjBLRXJwbUNhRVkKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
    server: https://35.196.136.87
  name: gke_devops24-book_us-east1_jx-workshop
contexts:
- context:
    cluster: gke_devops24-book_us-east1_jx-workshop
    user: gke_devops24-book_us-east1_jx-workshop
  name: gke_devops24-book_us-east1_jx-workshop
current-context: gke_devops24-book_us-east1_jx-workshop
kind: Config
preferences: {}
users:
- name: gke_devops24-book_us-east1_jx-workshop
  user:
    auth-provider:
      config:
        access-token: ya29.GlsDB7wNk8S60_IOBop1rD8EKFTHiqgq2qRVEQymMbUajBOdkPVAhCHqFuHWSvssipZPqgPx4_OyEpyPLPCMPs0YFzSVmy2HCb3eBXhGjtYfiB3LmfjsCwaw-LO6
        cmd-args: config config-helper --format=json
        cmd-path: /Users/vfarcic/google-cloud-sdk/bin/gcloud
        expiry: \"2019-05-08T07:46:13Z\"
        expiry-key: '{.credential.token_expiry}'
        token-key: '{.credential.access_token}'
      name: gcp" \
    | tee workshop_config.yaml

# Change `/Users/vfarcic/google-cloud-sdk/bin/gcloud` to the path of your `gcloud`

export KUBECONFIG=$PWD/workshop_config.yaml
```


## Creating A Cluster With jx (Workshop)

---

```bash
GH_USER=[...] # Replace with your GitHub username

export LB_IP=$(kubectl -n ingress-nginx get svc ingress-nginx \
    -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

echo $LB_IP

DOMAIN=$GH_USER.$LB_IP.nip.io

# Use default answers except in the case specified below.
# Answer `Static Jenkins Server and Jenkinsfiles` when asked to `select Jenkins installation type`

jx install --provider gke --external-ip $LB_IP --domain $DOMAIN \
    --default-admin-password=admin --ingress-namespace ingress-nginx \
    --ingress-deployment nginx-ingress-controller \
    --default-environment-prefix jx-rocks --git-provider-kind github \
    --namespace $GH_USER
```
<!-- 
for i in {1..20}
do
    GH_USER=$(codename \
        --lists=adjectives \
        --filters=alliterative,unique,random \
        |  tr '[:upper:]' '[:lower:]')
    jx install --provider gke --external-ip $LB_IP --domain $DOMAIN \
        --default-admin-password=admin --ingress-namespace ingress-nginx \
        --ingress-deployment nginx-ingress-controller \
        --default-environment-prefix jx-rocks --git-provider-kind github \
        --namespace $GH_USER --batch-mode
done
 -->


## Verifying The Installation

---

```bash
kubectl -n jx get pods
```