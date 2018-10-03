## Hands-On Time

---

# Setting Up Ingress And Storage


## Ingress

---

```bash
kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml

kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/aws/service-l4.yaml

kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/aws/patch-configmap-l4.yaml
```


## Ports

---

```bash
CP_SG=$(aws ec2 describe-security-groups \
    --filter "Name=group-name,Values=eksctl-$NAME-cluster-ControlPlaneSecurityGroup-*" \
    | jq -r '.SecurityGroups[0].GroupId')

NG_SG=$(aws ec2 describe-security-groups \
    --filter "Name=group-name,Values=eksctl-devops25-nodegroup-0-SG-*" \
    | jq -r '.SecurityGroups[0].GroupId')

echo $CP_SG $NG_SG

aws ec2 authorize-security-group-egress --group-id $CP_SG \
    --ip-permissions IpProtocol=tcp,FromPort=443,ToPort=443,UserIdGroupPairs="[{GroupId=$NG_SG,Description='Metrics Server'}]"

aws ec2 authorize-security-group-ingress --group-id $NG_SG \
    --protocol tcp --port 443 --source-group $CP_SG
```


## ELB IP

---

```bash
LB_HOST=$(kubectl -n ingress-nginx get svc ingress-nginx \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

export LB_IP="$(dig +short $LB_HOST | tail -n 1)"

echo $LB_IP

# Repeat the `export` command if `LB_IP` is empty
```
