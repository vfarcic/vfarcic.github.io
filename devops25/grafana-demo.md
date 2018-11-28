## Hands-On Time

---

# Visualizing Metrics And Alerts


## Installing Grafana

---

```bash
helm inspect values stable/grafana

cat mon/grafana-values-bare.yml

GRAFANA_ADDR="grafana.$LB_IP.nip.io"

helm install stable/grafana --name grafana --namespace metrics \
    --version 1.17.5 --set ingress.hosts="{$GRAFANA_ADDR}" \
    --values mon/grafana-values-bare.yml

kubectl -n metrics rollout status deployment grafana

open "http://$GRAFANA_ADDR"

kubectl -n metrics get secret grafana \
    -o jsonpath="{.data.admin-password}" | base64 --decode; echo
```


## Installing Grafana

---

* Type *admin* as the *username*
* Paste the output as the *password*
* Click the *Add data source* icon
* Type *Prometheus* as the *Name*
* Choose *prometheus* as the *Type*
* Type *http://prometheus-server* as the *URL*
* Click *Save & Test*


## Importing Dashboards

---

```bash
open "https://grafana.com/dashboards"
```

* Click the *+* icon from the left-hand menu
* Click the *Import* link
* Type *3119* into the *Grafana.com Dashboard* field
* Click the *Load* button
* Choose *prometheus* from the *prometheus* drop-down list


## Importing Dashboards

---

* Please press the arrow next to the *Cluster filesystem usage*
* Click the *Edit* link
* Click the *Back to dashboard* button
* Click the *Settings* icon located in the top of the screen
* Click the *Variables* link in the *Settings* section
* Click the *+ New* button
* Type *device* as the variable *Name*
* Type *IO Device* as the *Label*
* Select *$datasource*
* Type the query that follows into the *Query* field

```
label_values(container_fs_usage_bytes, device)
```


## Importing Dashboards

---

* Click the *Add* button
* Click the arrow next to the *Cluster filesystem usage* graph
* Select *edit*
* Change `^/dev/xvda.$` to `$device`
* Click the *Back to dashboard* button
* Repeat the same steps fro *Used* and *Total* panels
* Click the trash icon next to *System services CPU usage*
* Click *Yes*
* Repeat the same for *System services memory usage*


## Creating Custom Dashboards

---

* Click the *+* icon
* choose to *Create Dashboard*
* Select *Graph*
* Click the *Settings*
* Type *My Dashboard* as the *Name* of the dashboard
* Set the *Tags* to *Prometheus* and *Kubernetes*
* Change the *Timezone* to *Local browser time*


## Creating Custom Dashboards

---

* Select the *Variables* section
* Click the *Add Variable* button
* Type *minCpu* as the *Name*
* Choose *Constant* as the *Type*
* Set the *Value* to *0.005*
* Change the *Hide* value to *Variable*
* Click the *Add* button, twice


## Creating Custom Dashboards

---

* Create two more variables

```
Name:  cpuReqPercentMin
Type:  Constant
Label: Min % of requested CPU
Hide:  Variable
Value: 50
 
Name:  cpuReqPercentMax
Type:  Constant
Label: Max % of requested CPU
Hide:  Variable
Value: 150
```

* Click the *Back to dashboard* icon


## Creating Custom Dashboards

---

* Click on the arrow next to *Panel Title*
* Select *Edit*
* Select *General* section
* Write *% of actual vs reserved CPU* as the *Title*
* Write the *Description* that follows

```
The percentage of actual CPU usage compared to reserved. The calculation excludes Pods with reserved CPU equal to or smaller than $minCpu. Those with less than $minCpu of requested CPU are ignored.
```


## Creating Custom Dashboards

---

* Switch to the *Metrics* tab
* Type the query that follows in the field to the right of *A*

```
sum(label_join(
    rate(
        container_cpu_usage_seconds_total{
            namespace!="kube-system",
            pod_name!=""
        }[5m]
    ), 
    "pod", 
    ",", 
    "pod_name"
)) by (pod) / 
sum(
    kube_pod_container_resource_requests_cpu_cores{
        namespace!="kube-system",
        namespace!="ingress-nginx"
    }
) by (pod) and 
sum(
    kube_pod_container_resource_requests_cpu_cores{
        namespace!="kube-system",
        namespace!="ingress-nginx"
    }
) by (pod) > $minCpu
```


## Creating Custom Dashboards

---

* Click the *Axes* tab
* Expand the *Left Y Unit*
* Select *none*, followed with *percent (0.0-1.0)*
* Uncheck the *Right Y Show* checkbox
* Select *Legend*
* Check *Options As Table*
* Check *Options To the right*
* Check *Values > Current* checkboxes


## Creating Custom Dashboards

---

* Click the *Alert* tab
* Click the *Create Alert* button
* Change the *IS ABOVE* condition to *IS OUTSIDE RANGE*
* Set the values of the next two fields to *0,5* and *1,5*
* Go *Back to dashboard*


## Creating Semaphores

---

* Please click the *Add panel* icon
* Select *Singlestat*
* Click the arrow icon next to the *Panel Title*
* Select *Edit*
* Select the *General* tab
* Type the text that follows as the *Title*

```
Pods with < $cpuReqPercentMin% || > $cpuReqPercentMax% actual compared to reserved CPU
```

* Type the text that follows as the *Description*

```
The number of Pods with less than $cpuReqPercentMin% or more than $cpuReqPercentMax% actual compared to reserved CPU
```


## Creating Semaphores

---

* Click the *Metrics* tab
* Type the expression that follows into the field next to *A*

```
sum(
    (
        sum(
            label_join(
                rate(container_cpu_usage_seconds_total{
                    namespace!="kube-system",
                    pod_name!=""}[5m]),
                    "pod", 
                    ",", 
                    "pod_name"
            )
        ) by (pod) / 
        sum(
            kube_pod_container_resource_requests_cpu_cores{
                namespace!="kube-system",
                namespace!="ingress-nginx"
            }
        ) by (pod) and
        sum(
            kube_pod_container_resource_requests_cpu_cores{
                namespace!="kube-system",
                namespace!="ingress-nginx"
            }
        ) by (pod) > $minCpu
    ) < bool ($cpuReqPercentMin / 100)
) + 
sum(
    (
        sum(
            label_join(
                rate(
                    container_cpu_usage_seconds_total{
                        namespace!="kube-system",
                        pod_name!=""
                    }[5m]
                ), 
                "pod", 
                ",", 
                "pod_name"
            )
        ) by (pod) / 
        sum(
            kube_pod_container_resource_requests_cpu_cores{
                namespace!="kube-system",
                namespace!="ingress-nginx"
            }
        ) by (pod) and 
        sum(
            kube_pod_container_resource_requests_cpu_cores{
                namespace!="kube-system",
                namespace!="ingress-nginx"
            }
        ) by (pod) > $minCpu
    ) > bool ($cpuReqPercentMax / 100)
)
```


## Creating Semaphores

---

* Click the *Options* tab
* Changing the value of the *Stat* drop-down list to *Current*
* Change the *Stat Font size* to *200%*
* Check the *Coloring Background* checkbox
* Type *1* as the *Coloring Thresholds*
* Click the red icon in *Coloring Colors*
* Replace the value with the word *red*
* Go *Back to dashboard*
* Click the *Save Dashboard* icon
* Click the *Save* button


## A Better Dashboard

---

* Click the *+* button
* Select *Import*
* Type *9132* as the *Grafana.com Dashboard*
* Press the *Load* button
* *Select a Prometheus data source*
* Click the *Import* button
