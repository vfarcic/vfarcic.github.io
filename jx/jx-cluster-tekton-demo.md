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

# TODO: Fix the metrics server so that `kubectl top nodes` works

# Fetch k8s config from DO UI and replace the one below.
-->
## Using The Workshop Cluster (Not Today)

---

```bash
echo "apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURKekNDQWcrZ0F3SUJBZ0lDQm5Vd0RRWUpLb1pJaHZjTkFRRUxCUUF3TXpFVk1CTUdBMVVFQ2hNTVJHbG4KYVhSaGJFOWpaV0Z1TVJvd0dBWURWUVFERXhGck9ITmhZWE1nUTJ4MWMzUmxjaUJEUVRBZUZ3MHhPVEExTWpneApORE13TXpWYUZ3MHpPVEExTWpneE5ETXdNelZhTURNeEZUQVRCZ05WQkFvVERFUnBaMmwwWVd4UFkyVmhiakVhCk1CZ0dBMVVFQXhNUmF6aHpZV0Z6SUVOc2RYTjBaWElnUTBFd2dnRWlNQTBHQ1NxR1NJYjNEUUVCQVFVQUE0SUIKRHdBd2dnRUtBb0lCQVFDNmhZcVRJYzJBaG5rZkZhTGF6bE8ya2hEc010WW8vZjMvNkxIVExjaE1VK2JoVEJBUApjeDBQNTQ2S1VZK3dNSVdMK0pTT0ZBampBa3BzalkybXVmMGFNZThteEFtUzExWWRoM29hQmJOZFEvckxoUUdGCkJPWjNHYkp6UVBDci92eVlZY0dIMStqREJVOTJ6aE1ITGRBb1BSVnNDUjZVY0RDYlB6bzZUREQrWElUQ3BtemUKamVzRUNsWnpkU2w5clJtNitPUUlBNk9TTlBaRWJuQjdKZnNOVTcxK0hyM3R5djc1aUVRRlptN2xXcnp1a1VsSgo4SG1laGE4WjRkdjNpQzNrYjNQQml3WitJL1VxdDRpcU81eWRsamZQbHdvT1FkV3pYdDlnUU50bzR4MmVwTm1qCldvcVBpaWFIWmtJK3lDMi9BeVdzWkJQUGFwU290VWlEL3pSZEFnTUJBQUdqUlRCRE1BNEdBMVVkRHdFQi93UUUKQXdJQmhqQVNCZ05WSFJNQkFmOEVDREFHQVFIL0FnRUFNQjBHQTFVZERnUVdCQlNlM205MTRoUmlxOXV1eXdiYgpVNElKRi9TWnB6QU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FRRUFsUnhwMjQ3TUNQUUJCSTRXem05NXlhT3RsQVBjCmtBK0NhVDdDNVFOOURaSEtjY1F5c1VrUjJHNGM2bHd0ckNtVHJFbC9OaW9JcmVWN1huR05CTUV3eVBWLzhLSFMKVStrNGxKSmgxUUlXWFJyMnhTQlZPbW5EemdFNFNLWWtxYndQVGNwanVtMU5wUldSYU1kb2NFWE5FMUk2U1QyUwpSelhhVUF0WHFDRUxCbVZSNm1aV3VOUVVhWGQ5UFhXT3Y0cTE5T0FhRGYxbFJFck5IWkdiQ3dUV1dtaTltWnIvCkdXM2VBRTh4UEE4Vlo2QkdMTU8yMjhkUXAwVmt1TDkreWpoVFZ5bjkweit2K3hqdWI4ajZmUm81WXpMSlN3aXEKbW5NTHpEOGxYcEFVZzQ2L1VCK2l1MG9hODM2L1R6L3JCdDIwejF0Wk9mbU8zZWp4TU5qSmEzL0VWUT09Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
    server: https://abca04dc-61dc-42d0-a08b-e17f0646e187.k8s.ondigitalocean.com
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
    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURyVENDQXBXZ0F3SUJBZ0lDQm5Vd0RRWUpLb1pJaHZjTkFRRUxCUUF3TXpFVk1CTUdBMVVFQ2hNTVJHbG4KYVhSaGJFOWpaV0Z1TVJvd0dBWURWUVFERXhGck9ITmhZWE1nUTJ4MWMzUmxjaUJEUVRBZUZ3MHhPVEExTWpneApORE01TURaYUZ3MHhPVEEyTURReE5ETTVNRFphTUg4eEN6QUpCZ05WQkFZVEFsVlRNUXN3Q1FZRFZRUUlFd0pPCldURVJNQThHQTFVRUJ4TUlUbVYzSUZsdmNtc3hIVEFiQmdOVkJBb1RGR3M0YzJGaGN6cGhkWFJvWlc1MGFXTmgKZEdWa01URXdMd1lEVlFRREV5Z3hNVFpoTTJJMU1qQXhOekZtTW1VeFlqZGtNMlJsTWpoaVkySTFPRE5sTm1NMwpNakk0WmpReE1JSUJJakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBUThBTUlJQkNnS0NBUUVBbm9IWklLRCtSWU1MCjhoQ2d1bFBrM01vcHVMUzVmc2pEWWZLcjNNcjY0ZVBWRXE3ay9mVWRyWU9hMnVnZ1RtdUtnaFRmV2hMOUdtcnIKVXR2UnZUZ0JUN0dmb3UrTW5rYm5RQVhrd2tiWlJRWHBQVnppRlBqanNFbDRLcnZ3alIrRnhQOVluNnpmREZJaQpEMmdxQUcrME1DekFsUzMyQitNT01iWmJENXRpMU9kWnBudkNWOGgvRjM4emRxb2JKVEhHd1RRV1V4MVZNTk41CmE1eENPYTZjUHVXQlpqNEo2aHBUcW05ZmhYTEJDUnVJZ0s0UlFhUHFRd0phRGJvWTI2ZFVNd1VxZmlYOFYyeXYKUWdDenArYnpoOXpma3FsWStFaVlUQjIxa29ldk5aQ2k1TEhpTVVZbHNWaG9Ba0VZT0dpNjZESWJVSG8vMWlYeQozTHQ3VGl0bk9RSURBUUFCbzM4d2ZUQU9CZ05WSFE4QkFmOEVCQU1DQmFBd0hRWURWUjBsQkJZd0ZBWUlLd1lCCkJRVUhBd0lHQ0NzR0FRVUZCd01CTUF3R0ExVWRFd0VCL3dRQ01BQXdIUVlEVlIwT0JCWUVGTTJ0RnNUTy83RysKa2JsWTg1NEFOaHcvdVNEZE1COEdBMVVkSXdRWU1CYUFGSjdlYjNYaUZHS3IyNjdMQnR0VGdna1g5Sm1uTUEwRwpDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ08zQ0lwcmpGQmgzQ1p1UUJhKy9hY0k3U2phcTRXMUhVRXhFKytoR001CjZzRWxURVFnVzcrWGtJekdrY3FLVENGQllSQnFDWUwwYmVhWmhtTHhZZUpuS1o5UXIydUt4aGxhck9HNEYzb20KamhPRG0rRlpZNnZoTWtjVlRVNlBQY0NSTmFTWjh1YVVTWnU2SFlWSlJEQnp1TGVocEVmYUF6K0NYd0M0NGduVgppN2VUQ0sxTmd4NnV5cmhDc1FIVFNoU0w4ejNTemJOaU9CN05ZN2xIL3BsemV5ZzdtNnJScUhmaGtORGR6K0ZWCjgzUGVSRTU0UEwvTmFCME4rVFVweml3SThmOU1rWW9GTUFReG9jVmlzQzlXNmxESUt0VTcwMmRHVE1SM2Nrb2UKcnFiVXFPaHNBNFJRYVpuYXZmLzUyUmVCWE8wVG9PNzJjS1VBMXJEK1FXMzAKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
    client-key-data: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb2dJQkFBS0NBUUVBbm9IWklLRCtSWU1MOGhDZ3VsUGszTW9wdUxTNWZzakRZZktyM01yNjRlUFZFcTdrCi9mVWRyWU9hMnVnZ1RtdUtnaFRmV2hMOUdtcnJVdHZSdlRnQlQ3R2ZvdStNbmtiblFBWGt3a2JaUlFYcFBWemkKRlBqanNFbDRLcnZ3alIrRnhQOVluNnpmREZJaUQyZ3FBRyswTUN6QWxTMzJCK01PTWJaYkQ1dGkxT2RacG52QwpWOGgvRjM4emRxb2JKVEhHd1RRV1V4MVZNTk41YTV4Q09hNmNQdVdCWmo0SjZocFRxbTlmaFhMQkNSdUlnSzRSClFhUHFRd0phRGJvWTI2ZFVNd1VxZmlYOFYyeXZRZ0N6cCtiemg5emZrcWxZK0VpWVRCMjFrb2V2TlpDaTVMSGkKTVVZbHNWaG9Ba0VZT0dpNjZESWJVSG8vMWlYeTNMdDdUaXRuT1FJREFRQUJBb0lCQUZqLzA2aU1mUGtPMGVCRApFZHhOU3MzbC9YTW1scGpucFQwVUF3ZmdPT29wQVBTU215VTFRa3F4QUh3MXBoNGlLQTFPSnZMdWdvc1l5YlVtCmxDZklrSVBzMmhPa3FiSWRZYThESUNVdG5zVXd3bnVmOFptUS9sZDNpUytGZzFYYUEwUlBrN1ZrWFlFUGhPeGQKc21lNFVOWlQ2blpZN2pJVGZWN1FZMlRwL0o1SnZoMGl0bmpHR2IyWE4zME9xN3VVYTBXbDZGb0lZNzVIWWRNTQphODhieEd5elBpcmVrZGZvUmFCeCt3ZGhLbVlON05zTjZNM21rREtOM1Bvc2RvdmgrMDRLbGhNUkRMalFJbUxNCkxOckdQVk5vc2FsY2hkQ2YrUEt1ajFDeSs2Tmt4ZkUrOUY2TFFjUXFPVTNrcXQrZVF2TExNcTJvbVBLUU4yZDAKR3BJV2RPRUNnWUVBMFZtTmN5WFZxZlUvQUFMYUtGWjJUeU5ZT2xQTXp1Y3o5NUQ1cStBQnJURHlLU2FGUzdzVAplbTYzdTN4QU41dUwvWDlLakkxTmFJMXhpQUtPR3ovR2dzN3g1aXROSGU5aTY4aVNmSU5BalhHd2VBd1BsVkx2CjlVQ0dwcFdZYndYUCsxN2IzRXc3K1NvaFdyQlV1L2hQL09NMnQvYi9ObDhWSEc3anJrLzBCTFVDZ1lFQXdkUDEKWk9zS05FTzhFV3JXTjlVSXdLTERIdUdobWhHQU9uSUhpalR5TDZBTU93QlcwNWY5M1EzNHRKSHB2Y3FBclQyUApnOG1XdEVyRFVTSE1zS1kyWkxsVy9BczVtVmJaUUhFTTdycXBOV3NvcDNXVk1UeWxlTXhsb3dJWU1scUZUWUFZCjZNcGVuVmhsS29LbVRJMjZUaXhKbGxvQUhrV21WM1E3bXJGOUR2VUNnWUFmOU4rV3VDdkphZHBZRWhkakdPK3UKWE9MVzVIdmJDWWZ4UG53ZU5HK05GRytpd0hLUWdOb1VVbHBSa0VIdE94MC9jUExjU2FXTFZDd0Vhdjl1UVduNApCY2IvTDVUeUFOekV5VFV6TklYaUVYeXlsb1M2Y3BLV2lXY0Vmc2xxQ1NVYVpmeUJ3RkZYVTRzTDRPYk9XclU3CkVTUUZLUHNFUGJkblE3WVZvYmJLRVFLQmdCeFF3SnFiazRRTEdTQmFRUzBxMi9wNFRKVG9WVmxTa1M3NGxZMWwKS3JRMloxTC9PNi94bGs2Q3lnQm5DSVNIWHNEd0sxVVBVQXJLbVRueS9Cb2FUZnZzNzM0bWphV1BBSEhma2dvVwpEcjRWQjMxZk9ncFZWNzhMN1JVaEt6Ty84WlZlejBUQ3U0dTA3Q0tIcjQramJNSWF5aTFDdkoydmd4dG5pWVdSCnhEazVBb0dBU25MdzB4MUlsRWJXWHNacCs4Z1hMSG1seldob0pWRGI1YXNYU1U5Z2EwK3hXRk8zbElvdU5wUzAKWldWR3FNdithVE1WUmJDYXhkbGRXekdCMEx0Mk5nK0xVN1J4MGxFS0dRT1l5K2RDM2hNNzRZRlNqZEZFWHZ0MwppNGdYTFVmWGV3WFdBbS9uTGc2TmswcXByRnNsOU9heXlQcE80S2J4ckJNSWloUW9maU09Ci0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg==" \
    | tee workshop_config.yaml
```


## Using The Workshop Cluster

---

```bash
export LB_IP=$(kubectl -n ingress-nginx get svc \
    -o jsonpath="{.items[0].status.loadBalancer.ingress[0].ip}")

echo $LB_IP

# Only letters, numbers, dash (`-`) and underscore (`_`) charters
NAMESPACE=[...] # Make it unique

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