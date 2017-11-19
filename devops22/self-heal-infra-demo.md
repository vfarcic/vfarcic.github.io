## Hands-On Time

---

# Self-Healing Infra


# Fault Tolerance

---

```bash
docker service create --name test --replicas 10 alpine sleep 1000000

docker service ps test

exit

INSTANCE_ID=$(aws ec2 describe-instances \
    | jq -r ".Reservations[].Instances[] \
    | select(.SecurityGroups[].GroupName \
    | contains(\"devops22-ManagerVpcSG\")).InstanceId" | tail -n 1)

aws ec2 terminate-instances --instance-ids $INSTANCE_ID
```


# Fault Tolerance

---

```bash
aws ec2 describe-instances | jq -r ".Reservations[].Instances[] \
    | select(.SecurityGroups[].GroupName \
    | contains(\"devops22-ManagerVpcSG\")).State.Name"

CLUSTER_IP=$(aws ec2 describe-instances \
    | jq -r ".Reservations[].Instances[] \
    | select(.SecurityGroups[].GroupName \
    | contains(\"devops22-ManagerVpcSG\")).PublicIpAddress" \
    | tail -n 1)

ssh -i workshop.pem docker@$CLUSTER_IP

docker node ls

docker service ps test
```


# Fault Tolerance

---

```bash
docker service rm test
```
