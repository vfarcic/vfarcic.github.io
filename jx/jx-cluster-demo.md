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
docker-registry:
  enabled: true
" | tee myvalues.yaml
```


## Creating A Cluster With jx (GKE)

---

```bash
open "https://console.cloud.google.com/cloud-resource-manager"

PROJECT=[...] # e.g. devops24-book

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
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURDekNDQWZPZ0F3SUJBZ0lRVFJ5QVRRNWpaYjhTemlybDQ2Q3ZnREFOQmdrcWhraUc5dzBCQVFzRkFEQXYKTVMwd0t3WURWUVFERXlRMU1HVmtaakV3TWkwek16STBMVFEwT0dRdFlUWmxOQzAzT0RrNVl6STBPREl4WVRBdwpIaGNOTVRrd05ETXdNVFExTmpRd1doY05NalF3TkRJNE1UVTFOalF3V2pBdk1TMHdLd1lEVlFRREV5UTFNR1ZrClpqRXdNaTB6TXpJMExUUTBPR1F0WVRabE5DMDNPRGs1WXpJME9ESXhZVEF3Z2dFaU1BMEdDU3FHU0liM0RRRUIKQVFVQUE0SUJEd0F3Z2dFS0FvSUJBUUM0Qmtpbm1VOUFWRkpsTTRSYjQyTTYxNjBwOWVtcDhaeDgvV0xOS1FHNwpuS1NCd3BZOGJnd3BqTVRobndMekF0NGYrVy9aRUVsOVNtVi9mbjVTL2ZUV2VyazFFYVRERW1kNnRGWURNL3NoCmU4RU55VWhkUHNQcEVra2xXMG9XNW12aDZ0Zy85dWQyMmdGNXhGVzhJS0U3d0RsU0VxZHFZRElDekw2QjQzQVIKMVROZlVSa0c5SE1jS2JhVUhVUExGL3lOWjlQN2ZsaEVUam9kRnR4b2NBU2dQT2hhU2V3bko1M2pZN093bGxFYQpMR1VuaEt1YUdIZEp1MmlFNGdUalgvK0l2M0RGeEZQUXpSQjZscm92SzJybG1mTU1JNnVHR2cydEdTaUM1ZFZrCmxGKy9rdEhsblA0SE1qQ0JCSXFkZy9kdjlXZGo2ZDBtZ0M4L2c1aWZpaGE1QWdNQkFBR2pJekFoTUE0R0ExVWQKRHdFQi93UUVBd0lDQkRBUEJnTlZIUk1CQWY4RUJUQURBUUgvTUEwR0NTcUdTSWIzRFFFQkN3VUFBNElCQVFCcAppbndXeGZ5T0x0NCthbXo2UHJWSERyMUE4UTNuREVyWjJMenoxcS9UbWU4SFdsdHF6cXhlQ3lNYk0rUWtPdXBlCk1sQlMrWUlaZ05yZWJwQnlEQWsrMUdMdU1SeG0wV0FDcHhKaGFrZ1Rvb2NoeUlQM29weTJqUnd3ZnJhaEtiRk4KU042cGc4dXM4TE1vOGJ0bDY1Y2hHSDFDQTdDWXpJaFlad1pPZzhuM21uQVZjZXB2Ulp4YXVuSTFBTXF6N1IvaAp5M2lVZCtpc1FKWEVyWk9DWVIyOS9tK3RkZ05YbmVIYlpjenlyS0xPWmhCbEtXSXJHSjhvMkxOeExndnV5NzlJCmFpUlJNeEZObWJMZUZaQXRJRlM1QUFtSnhOd0k1Q3p2ZFhEbk1wMXhFQVVUNHAzM2wySXdtc0dBenBiZXRZc2kKOHhYL2kyb3JLNUZ0K1R5VXQ3VlMKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
    server: https://35.196.94.38
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
        access-token: ya29.Glv7BmrxXm_XuErXzw3eVF-1L8nMaJaRvOhufPVbskS1eHZxGncPzcVw5Ajsp9BGoBUb0xK8P15CkxRotMpECmsZBnSdMoedRSnHiFv1j5zzdCKBCYdiBKQROm8Z
        cmd-args: config config-helper --format=json
        cmd-path: /Users/vfarcic/google-cloud-sdk/bin/gcloud
        expiry: \"2019-04-30T16:56:39Z\"
        expiry-key: '{.credential.token_expiry}'
        token-key: '{.credential.access_token}'
      name: gcp" \
    | tee workshop_config.yml

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