# Installing jx CLI

---

# Install [doctl](https://github.com/digitalocean/doctl)
```bash
doctl auth init


kubectl config use do-nyc1-jx-rocks
```

# Install NGINX Ingress controller
```bash
kubectl apply \
  -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/1cd17cd12c98563407ad03812aebac46ca4442f2/deploy/mandatory.yaml .
  
kubectl apply \
   -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/1cd17cd12c98563407ad03812aebac46ca4442f2/deploy/provider/cloud-generic.yaml

export LB_IP=$(kubectl -n ingress-nginx \
    get svc -o jsonpath="{.items[0].status.loadBalancer.ingress[0].ip}")

echo $LB_IP # It might take a while until LB is created. Repeat the `export` command if the output is empty.
```

# Install jx 


The command that follows uses `-b` to run in the batch mode and it assumes that this is not the first time you create a cluster with `jx`.
If that's not the case and this is indeed the first time you're creating a `jx` cluster, it will not have some of the default values like GitHub user and the installation might fail.
Please remove `-b` from the command if this is NOT the first time you're creating a cluster with `jx`.

## Static
```bash
jx install \
    --provider kubernetes \
    --external-ip $LB_IP \
    --domain jenkinx.$LB_IP.nip.io \
    --default-admin-password=admin \
    --ingress-namespace ingress-nginx \
    --ingress-deployment nginx-ingress-controller \
    --default-environment-prefix jx-rocks \
    --git-provider-kind github \
    -b
```
## Serverless
```bash
jx install \
    --provider kubernetes \
    --external-ip $LB_IP \
    --domain $DOMAIN \
    --default-admin-password=admin \
    --ingress-namespace ingress-nginx \
    --ingress-deployment nginx-ingress-controller \
    --default-environment-prefix tekton \
    --git-provider-kind github \
    --namespace cd \
    --prow \
    --tekton \
    -b
```

# Destroy the cluster 
```bash
doctl kubernetes cluster \
    delete jx-rocks \
    -f
```
# TODO: Delete the volumes

# TODO: Delete the LB