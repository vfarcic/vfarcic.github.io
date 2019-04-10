# Cleanup

```bash
LB_NAME=$(aws elb describe-load-balancers | jq -r \
    ".LoadBalancerDescriptions[0] \
    | select(.SourceSecurityGroup.GroupName \
    | contains (\"k8s-elb\")).LoadBalancerName")

aws elb delete-load-balancer \
    --load-balancer-name $LB_NAME

# Replace `devops24` with the name of your cluster
eksctl delete cluster -n devops24
```
