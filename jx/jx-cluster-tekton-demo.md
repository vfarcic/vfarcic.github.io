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
NAMESPACE=cd

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

# Use default answers

jx create cluster gke -n jx-rocks -p $PROJECT -r us-east1 \
    -m n1-standard-2 --min-num-nodes 1 --max-num-nodes 2 \
    --default-admin-password=admin \
    --default-environment-prefix jx-rocks --git-provider-kind github \
    --namespace $NAMESPACE --prow --tekton
```


## Creating A Cluster With jx (AKS)

---

```bash
# Use default answers

jx create cluster aks -c jxrocks -n jxrocks-group -l eastus \
    -s Standard_B2s --nodes 3 --default-admin-password=admin \
    --default-environment-prefix jx-rocks --git-provider-kind github \
    --namespace $NAMESPACE --prow --tekton
```


## Creating A Cluster With jx (EKS)

---

```bash
export AWS_ACCESS_KEY_ID=[...] # Replace [...] with the AWS Access Key ID

export AWS_SECRET_ACCESS_KEY=[...] # Replace [...] with the AWS Secret Access Key

export AWS_DEFAULT_REGION=us-west-2

# Use default answers except in the case specified below.
# Answer `Static Jenkins Server and Jenkinsfiles` when asked to `select Jenkins installation type`

jx create cluster eks -n jx-rocks -r $AWS_DEFAULT_REGION \
    --node-type t2.medium --nodes 3 --nodes-min 3 --nodes-max 6 \
    --default-admin-password=admin \
    --default-environment-prefix jx-rocks --git-provider-kind github \
    --namespace $NAMESPACE --prow --tekton
```


<!--
doctl auth init

export KUBECONFIG=$PWD/workshop_config.yaml

NODES=3

doctl k8s cluster create jx-rocks --count $NODES --region nyc1 --size s-4vcpu-8gb

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/1cd17cd12c98563407ad03812aebac46ca4442f2/deploy/mandatory.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/1cd17cd12c98563407ad03812aebac46ca4442f2/deploy/provider/cloud-generic.yaml

rm -rf charts/metrics-server charts/k8s/metrics-server

mkdir -p charts/k8s

helm fetch stable/metrics-server -d charts --untar

helm template charts/metrics-server --name metrics-server --output-dir charts/k8s --namespace kube-system

kubectl -n kube-system apply -f charts/k8s/metrics-server/templates
-->
## Using The Workshop Cluster

---

```bash
echo "apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURKekNDQWcrZ0F3SUJBZ0lDQm5Vd0RRWUpLb1pJaHZjTkFRRUxCUUF3TXpFVk1CTUdBMVVFQ2hNTVJHbG4KYVhSaGJFOWpaV0Z1TVJvd0dBWURWUVFERXhGck9ITmhZWE1nUTJ4MWMzUmxjaUJEUVRBZUZ3MHhPVEExTWpjeApOVFF4TlRsYUZ3MHpPVEExTWpjeE5UUXhOVGxhTURNeEZUQVRCZ05WQkFvVERFUnBaMmwwWVd4UFkyVmhiakVhCk1CZ0dBMVVFQXhNUmF6aHpZV0Z6SUVOc2RYTjBaWElnUTBFd2dnRWlNQTBHQ1NxR1NJYjNEUUVCQVFVQUE0SUIKRHdBd2dnRUtBb0lCQVFES2M1R2JrbFhWNXZldFJmL1ZkK0x4WlNybUUyVW1vZDBHRzMyUWNRUHN6YkY3eHlFeApObjRmTStJVlVUeDJNcWc0UHc4dlFpc0xrekRqcktLSXZjT2VtbjlFTkU0QUJRM2wrR2JSSmt0MkV6Y1VKU1RYClpVRlQ5VWhxbWRmNERoV08rMzZ3Q2ltSkJjeWxOYVhzenNkZTNWWlo5TFFlaTVLTWZMcVR4bXltRXcrS0Ird2sKbW1DNHJ5bk9ncjFRT2IxV0o3Tmt1Sy9Mc3lFc3crRHF4akV0UjFvZ25VTkpWL241dlUyUlJCenEyWi94d01ncQpqOUNVRjdCbFRneHVjSTFUNUpkSlBYWTY5ZUd1TUIrYzhGd3lyNnFwNlRvbHJHWURSdytFcTFESG0yWG03MS94CnNRSVlkeUttbEtEaFRFL1dYL2tScHdheE56d1B5ZVBmOXY5REFnTUJBQUdqUlRCRE1BNEdBMVVkRHdFQi93UUUKQXdJQmhqQVNCZ05WSFJNQkFmOEVDREFHQVFIL0FnRUFNQjBHQTFVZERnUVdCQlFSREtkUkJ3L0gyQkJlZmpybwo3SE9mWUxWR2NqQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FRRUF1UHl1VENMMTJEckQzNEZYMTdSZFdOZXB0bTJvCnBjOElNL0ZiWlRwcGRUVjMwWU12Sm1EaWlUS3RZM3hIeHozZ2xINmZDYVg5Qk01ckZSQjd1em84ZkpaOHIzKzUKQkVrRVdrSk1HdkN2SnJxWDA4N1N1dERmdWpTbmZIUnAzUnF2bVlUTWs4cnlmb3NmTndUQ0d1cDVhSmNKMHlaNAp3MVpBS3p1NnNuYnovWmpKaUM5QTZZMFZRY1ZSOXZReDQzeDYwT3diRk56WUIyV3k5WGs0UHV2S3orT29WbUJsCk5hRCtJdDZQaUVyWm9lcUlINE8wN1llU3FodFlEQUIrWVIyK21rM0RnQ1RLcjlEb2NJeGkvVTNPR05kaERpc3UKMVlieHpkbGticFBLWHVDcHB5OUhSYXV6VVJOS2JzZlhVMWVBekdiYVVOcytHMHNMYWkzZnkvZ01uZz09Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
    server: https://9e56f263-4757-49d4-b914-95fd22e11be1.k8s.ondigitalocean.com
  name: do-nyc1-jx-rocks
contexts:
- context:
    cluster: do-nyc1-jx-rocks
    user: do-nyc1-jx-rocks-admin
  name: do-nyc1-jx-rocks
current-context: do-nyc1-jx-rocks
kind: Config
preferences: {}
users:
- name: do-nyc1-jx-rocks-admin
  user:
    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURyVENDQXBXZ0F3SUJBZ0lDQm5Vd0RRWUpLb1pJaHZjTkFRRUxCUUF3TXpFVk1CTUdBMVVFQ2hNTVJHbG4KYVhSaGJFOWpaV0Z1TVJvd0dBWURWUVFERXhGck9ITmhZWE1nUTJ4MWMzUmxjaUJEUVRBZUZ3MHhPVEExTWpjeApOVFF6TURsYUZ3MHhPVEEyTURNeE5UUXpNRGxhTUg4eEN6QUpCZ05WQkFZVEFsVlRNUXN3Q1FZRFZRUUlFd0pPCldURVJNQThHQTFVRUJ4TUlUbVYzSUZsdmNtc3hIVEFiQmdOVkJBb1RGR3M0YzJGaGN6cGhkWFJvWlc1MGFXTmgKZEdWa01URXdMd1lEVlFRREV5Z3hNVFpoTTJJMU1qQXhOekZtTW1VeFlqZGtNMlJsTWpoaVkySTFPRE5sTm1NMwpNakk0WmpReE1JSUJJakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBUThBTUlJQkNnS0NBUUVBMGF6MmJMWVFIR3lPCkRaUEpwZXl6Tkg1Uk52OG92R0c2dlc5STlRVTdPaktFYUEvUW5yT1FMSDU5cXJIQmFQbHNrZ2pHZ3FsUERvcGYKaDQ1Rk1TL3QzZTUzT2pLM0FRaUFpS1dYeWt5K1pSWFU2YVA1WDQ2c2RydE03WG1BOEl0UnZYRWZoZXJlbEZqZQpCd1Zxay9BbERocDBMVWdoTlhLRlZrUlZiZlBaM2NWSWtRL2ErSEE5eVBwOHo1WFFWN2RaN3VIUnc4aThHMVduClc0aXRlS2dJbk1JUXV3SXU4UFRjMGpUc01tMjFTZjVva0g2cGhxMVBhVW1uMFlhNkZTWjdibi9taHg2NWlHaFYKWEtBYjlBb2RBOHlGUG82emJsWThqWFh3ZnNMeDZDVTluNmNpdC9TcjVWLzZCeitFRmo0cEphTFpKVFhTdXQ1Ywo1aUNYTVl0U0FRSURBUUFCbzM4d2ZUQU9CZ05WSFE4QkFmOEVCQU1DQmFBd0hRWURWUjBsQkJZd0ZBWUlLd1lCCkJRVUhBd0lHQ0NzR0FRVUZCd01CTUF3R0ExVWRFd0VCL3dRQ01BQXdIUVlEVlIwT0JCWUVGT29mQVlrTEYwZngKYmxzRmd4L3lNeTNiZlBNSk1COEdBMVVkSXdRWU1CYUFGQkVNcDFFSEQ4ZllFRjUrT3Vqc2M1OWd0VVp5TUEwRwpDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ29qdEdLbWViek1YRWo5YXYzcXYwUmhiQUVnRExCUjFsb2pJY0tKS0IvCk9lSFlCRkE2V0RtMFN6Qkhud0pRbDhtSGhsczVsTTNtUzBHS1VMTlZEQXpCaThFZDhrQU8xcFBFSHZ2ek1hUVgKZnZzTnNoOGpPUzFFVUNST04wRFMwSUV5TUhzU2FUcXE5dHh4eldEcXVudmV2NUp3ZEZ1MUVyVks4QlZ1Y1hWYwpJNVdCNEFVNnZoWE5jMVVWTGtIN1NkQmdxc0VsZlQ2ZDJUVExkYWR5YlpDMW9aOXpsOXZOREZwWFhrcDRPa0FGCk1FeGV3dGxWQ1JmMVVaVUNFWVVZU05LSERwNUtnTThZYTNhMzk4QjVCc2FDb1pieGlUUm5KMHpCekVZVVFUcGwKRVZhdVpZOWlHT0lGa09PVzVOenpZSmZyS3AxRndrekhBcXpVVlRlWHZES3QKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
    client-key-data: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcEFJQkFBS0NBUUVBMGF6MmJMWVFIR3lPRFpQSnBleXpOSDVSTnY4b3ZHRzZ2VzlJOVFVN09qS0VhQS9RCm5yT1FMSDU5cXJIQmFQbHNrZ2pHZ3FsUERvcGZoNDVGTVMvdDNlNTNPakszQVFpQWlLV1h5a3krWlJYVTZhUDUKWDQ2c2RydE03WG1BOEl0UnZYRWZoZXJlbEZqZUJ3VnFrL0FsRGhwMExVZ2hOWEtGVmtSVmJmUFozY1ZJa1EvYQorSEE5eVBwOHo1WFFWN2RaN3VIUnc4aThHMVduVzRpdGVLZ0luTUlRdXdJdThQVGMwalRzTW0yMVNmNW9rSDZwCmhxMVBhVW1uMFlhNkZTWjdibi9taHg2NWlHaFZYS0FiOUFvZEE4eUZQbzZ6YmxZOGpYWHdmc0x4NkNVOW42Y2kKdC9TcjVWLzZCeitFRmo0cEphTFpKVFhTdXQ1YzVpQ1hNWXRTQVFJREFRQUJBb0lCQVFDN2NsSlhPNmhKa082cAp5cTVpTEtyRXlneVhDeU9DemlmZ3hNVkhidWJWRDJaNWxYSGUvdzVzQ0tVVjNaWFgzK3drM2IyQ0FCU1NIamhxCitsQjNPYThBVWZpNnlhMzdPWHVYTGRyMld3ZDNYVDRicGFFQndZNERFMDBobkJjZWRKNmRxcTBRenJrdmpBYnAKNWZpeXl1U0ZxRGFtYUs1dmxyTUhQVTNXWDBNdFUxd1gwcWFUQ1YyK1NDbVRvZks0L09VVWt0SUlEdUhuTXJEUgpDS1pKVXpON1lqbGZKTTBHNlQrN2d6L3kyUC9JVitpTHROalQzbkRhaHRHREZiOThCVlprdG85L2p3ajJBVWs3Ckh4Qk41ODRpcWNQTGxwN0tmL0swdUNDU01pczVDS1VDWnIyRTg2b3Z3VDlaVVRzTTIxTlNIWW0xNmFQVzdWdmIKcFI0Z2JuTUJBb0dCQU45bSs2UHZaZVIyS25lSHdYbXF4eFd0N3lGb0k4bWpCZXBFY2lQSDNKZVhoRU51UDJVOAoyVDBuWVVFazVhVHlaS2ZlbU5UZlcyNm9tSThvV1ZCaXN2end3ZTRNdjB6QlZZY3k4cmNPbVRoUFBRR2NIdDc0CnI0TzdBVGh2ckRtMmpIQUhHb2lwaEpvdE9aODVIY0h6NmJyd2h6T1BBOHhhVjJkSkg0THllNDBSQW9HQkFQQkYKTzA1ejBQUUM0aGZaL1JoUXdSRmRpWjFpOFE3cUg2R1pWOEpBdkFGU2lhbzNWanpWclUwL2VYK3d0MnZXSEJzcgplYVowK29NNGxOV3lEZzlPME9iYXhZaDlQdGsrZENWd3NUWU5SSTFrdkhCR3hOazBTUzQxUWd6R3R2enYzQW9oCk1OdCtnenFBYmRla05xYTdxeXJHME5FZkkraU1oYUx0SmZNQ2x6WHhBb0dBWEJhd2JrQTF5VG9vZ1VNMXJyaUYKL2xySGN3YmhrYkdnczVQcFZQU0M2djRyS0R5ZTUxVncyek9MZEhZSUw3azNZcmR3V25lRDBoYXZaSHVtYld0eQpDckFYME0veVgycG1uaWVUUTRCQ0NxTW5LNjIyVUFWRkhGRU96THZEeTdxREkzN2FJakYybHJORHlHMmI1YUpzCjI0Rmd5aEVPNk1Mb3VvdTY4SmlSODNFQ2dZQWQ4Q0p4cGhDMU50N0JKaEpaUTBhclNVSnFiL2VsYWhyQzRmNkQKWDltTk9LR2FxZ1orMGdra0JQSzRyR1pPYzRGUkNWdkJGL1pXLzJmY01MRjd5dEJRMDVXbGFpVzRvQVdNM0x2WQpCbE15WXdqdjNJR09wdXN2Yk1kc0hCNlU2Ylk3Tk9PSGxmMzMvaVN4cCs1L1hBYjU3NGY1WnEzc3ZnV3d4V2ZqCkhjR0ZvUUtCZ1FDY29MQVdEY2xuajdkNjZQY3NOTExLYXIrUmdweFI4QlYxU1BDQVFCN05kaDZUcnN2VUp1SkoKQldYMkVqWkR0YVZmcHM3Y2xRSTdHWmhYcWNia3hsVUFMQTIxcjArRXZPKyt3Q21scDcxcUJnSFNOTUI2MWV5TgorWmlUNmx4N1hUNU55VGYxcGF5Sy94UHJlb1Nva1VxR2tJekpub0RablpxTktjbWtkdVd1MHc9PQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo=" \
    | tee workshop_config.yaml
```


## Using The Workshop Cluster

---

```bash
export LB_IP=$(kubectl -n ingress-nginx get svc -o jsonpath="{.items[0].status.loadBalancer.ingress[0].ip}")

echo $LB_IP

MY_USER=[...]

NAMESPACE=$MY_USER

jx install --provider kubernetes --external-ip $LB_IP \
    --domain $LB_IP.nip.io --default-admin-password=admin \
    --ingress-namespace ingress-nginx \
    --ingress-deployment nginx-ingress-controller \
    --default-environment-prefix tekton --git-provider-kind github \
    --namespace $NAMESPACE --prow --tekton
```


## Using The Workshop Cluster

---

* Answer to all questions with the default values, except in the case listed below
* Answer with `n` to "`Would you like to enable Long Term Storage?`"


## Verifying The Installation

---

```bash
kubectl get pods
```