## Hands-On Time

---

# Collecting And Querying Logs


## Logs Through kubectl

---

```bash
GD5_ADDR=go-demo-5.$LB_IP.nip.io

helm upgrade -i go-demo-5 \
    https://github.com/vfarcic/go-demo-5/releases/download/0.0.1/go-demo-5-0.0.1.tgz \
    --namespace go-demo-5 --set ingress.host=$GD5_ADDR

kubectl -n go-demo-5 rollout status deployment go-demo-5

curl "http://$GD5_ADDR/demo/hello"

kubectl -n go-demo-5 describe sts go-demo-5-db

kubectl -n go-demo-5 logs go-demo-5-db-0 -c db

kubectl -n go-demo-5 logs -l app=go-demo-5
```


## Exploring Centralized Logging Through Papertrail

---

```bash
open "https://papertrailapp.com/"
```

* Register or log in

```bash
open "https://papertrailapp.com/start"
```

* Click the *Add systems* button.

```bash
PT_HOST=[...]

PT_PORT=[...]

cat logging/fluentd-papertrail.yml

cat logging/fluentd-papertrail.yml \
    | sed -e "s@logsN.papertrailapp.com@$PT_HOST@g" \
    | sed -e "s@NNNNN@$PT_PORT@g" \
    | kubectl apply -f - --record
```


## Exploring Papertrail

---

```bash
kubectl -n logging \
  rollout status ds fluentd-papertrail
```

* Go back to Papertrail UI

```bash
cat logging/logger.yml

kubectl create -f logging/logger.yml

kubectl logs random-logger
```

* Go back to Papertrail UI
* Type *random-logger* in the *Search* field
* Press the enter key


## Exploring Papertrail

---

* Click the *Search tips* button
* Click the *Full Syntax Guide* link

```bash
kubectl delete -f logging/fluentd-papertrail.yml
```


## GCP StackDriver (GKE Only)

---

```bash
kubectl -n kube-system describe ds -l k8s-app=fluentd-gcp

kubectl -n kube-system logs -l k8s-app=fluentd-gcp -c fluentd-gcp
```

* Open the link from the log entry
* Click the *ENABLE* button

```bash
open "https://console.cloud.google.com/logs/viewer"
```

* Type *random-logger* in *Filter by label or text search* field
* Select *GKE Container* from the drop-down list


## AWS CloudWatch (EKS Only)

---

```bash
PROFILE=$(aws iam list-instance-profiles \
  | jq -r ".InstanceProfiles[].InstanceProfileName" \
  | grep eksctl-$NAME-nodegroup-0)

echo $PROFILE

ROLE=$(aws iam get-instance-profile \
  --instance-profile-name $PROFILE \
  | jq -r ".InstanceProfile.Roles[] | .RoleName")

echo $ROLE

cat logging/eks-logs-policy.json

aws iam put-role-policy --role-name $ROLE --policy-name eks-logs \
  --policy-document file://logging/eks-logs-policy.json
```


## AWS CloudWatch (EKS Only)

---

```bash
aws iam get-role-policy --role-name $ROLE --policy-name eks-logs

cat logging/fluentd-eks.yml

kubectl apply -f logging/fluentd-eks.yml

kubectl -n logging get pods

open "https://$AWS_DEFAULT_REGION.console.aws.amazon.com/cloudwatch/home?#logStream:group=/eks/$NAME/containers"
```

* Type *random-logger* in the *Log Stream Name Prefix* field
* Press the enter key

```bash
kubectl delete -f logging/fluentd-eks.yml

aws iam delete-role-policy --role-name $ROLE --policy-name eks-logs

aws logs delete-log-group \
  --log-group-name "/eks/devops25/containers"
```


## Azure Log Analytics (AKS Only)

---

```bash
az aks enable-addons -a monitoring -n devops25-cluster \
  -g devops25-group

kubectl -n kube-system get deployments

open "https://portal.azure.com"
```

* Click the *All services* item
* Type *log analytics* in the *Filter* field
* Click the *Log Analytics* item
* Click the workspace
* Click the menu item *Logs* in the *General* section
* Type the query that follows in *Type your query here...* field

```
ContainerLog | where Name contains "random-logger"
```


## Azure Log Analytics (AKS Only)

---

* Click the *Run* button
* Expand the *Columns* list
* Click the *SELECT NONE* button
* Select *LogEntry*, *Name*, and *TimeGenerated* fields
* Contract the *Columns* list

```bash
az aks disable-addons -a monitoring -n devops25-cluster \
  -g devops25-group
```


## EFK

---

```bash
cat logging/es-values.yml

helm upgrade -i elasticsearch stable/elasticsearch \
    --version 1.14.1 --namespace logging \
    --values logging/es-values.yml

kubectl -n logging rollout status deployment elasticsearch-client

helm upgrade -i fluentd stable/fluentd-elasticsearch \
    --version 1.4.0 --namespace logging \
    --values logging/fluentd-values.yml

kubectl -n logging rollout status ds fluentd-fluentd-elasticsearch

kubectl -n logging logs -l app=fluentd-fluentd-elasticsearch
```


## EFK

---

```bash
cat logging/kibana-values.yml

KIBANA_ADDR=kibana.$LB_IP.nip.io

helm upgrade -i kibana stable/kibana --version 0.20.0 \
    --namespace logging --set ingress.hosts="{$KIBANA_ADDR}" \
    --values logging/kibana-values.yml

kubectl -n logging rollout status deployment kibana

open "http://$KIBANA_ADDR"
```


## EFK

---

* Click the link to *Explore on my own*
* Click the *Management* item from the left-hand menu
* Click the *Index Patterns* link
* Type `logstash-*` into the *Index pattern* field
* Click the *> Next step* button
* Select *@timestamp* from the *Time Filter field name*
* Click the *Create index pattern* button
* Click the *Discover* item from the left-hand menu
* Type the query that follows into the *Search* field

```
kubernetes.pod_name: "random-logger"
```


## EFK

---

* Click the *Refresh* (or *Update*) button
* Click the *Add* button next to the *log* field
* Expand one entry

```bash
helm delete kibana --purge

helm delete fluentd --purge

helm delete elasticsearch --purge

kubectl -n logging delete pvc \
  -l release=elasticsearch,component=data

kubectl -n logging delete pvc \
  -l release=elasticsearch,component=master
```
