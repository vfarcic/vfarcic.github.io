<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Creating A Jenkins X Cluster

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
export CLUSTER_NAME=[...]

export AWS_ACCESS_KEY_ID=[...] # Replace [...] with the AWS Access Key ID

export AWS_SECRET_ACCESS_KEY=[...] # Replace [...] with the AWS Secret Access Key

export AWS_DEFAULT_REGION=us-west-2
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
# Use default answers except in the case specified below.
# Answer with `n` to `Would you like to register a wildcard DNS ALIAS to point at this ELB address?`

jx create cluster eks -n $CLUSTER_NAME -r $AWS_DEFAULT_REGION \
    --node-type t2.xlarge --nodes 3 --nodes-min 3 --nodes-max 6 \
    --default-admin-password=admin \
    --default-environment-prefix $CLUSTER_NAME \
    --git-provider-kind github --prow --tekton

# If you get stuck with the `waiting for external loadbalancer to be created and update the nginx-ingress-controller service in kube-system namespace`, you probably encountered a bug.
# To fix it, open the AWS console and remove the `kubernetes.io/cluster/$CLUSTER_NAME` tag from the security group `eks-cluster-sg-*`.
```
