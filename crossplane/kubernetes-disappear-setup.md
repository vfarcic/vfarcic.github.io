<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Setup

<div class="label">Hands-on Time</div>


## Setup Control Plane

```bash
git clone https://github.com/vfarcic/devops-toolkit-crossplane

cd devops-toolkit-crossplane

# Create a control plane in https://cloud.upbound.io
#   and connect to it using CLI
```


## Setup AWS

```bash
# Replace `[...]` with access key ID
export AWS_ACCESS_KEY_ID=[...]

# Replace `[...]` with secret access key
export AWS_SECRET_ACCESS_KEY=[...]

echo "[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
" >aws-creds.conf

kubectl --namespace upbound-system create secret \
    generic aws-creds --from-file creds=./aws-creds.conf
```


## Setup AWS

```bash
kubectl apply --filename crossplane-config/provider-aws.yaml

kubectl apply \
    --filename crossplane-config/provider-config-aws-up.yaml

# Re-run the previous command if the output is
#   `unable to recognize ...`
```


## Setup Configurations

```bash
# Open https://marketplace.upbound.io/configurations?query=dot

# `Run in Upbound` the following configurations:
# - dot-kubernetes
# - dot-application
# - dot-gitops
```
