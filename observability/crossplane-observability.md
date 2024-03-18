<!-- .slide: data-background="img/restaurant-blind-folds.png" -->


<!-- .slide: data-background="img/frustrated-dev.webp" -->


#### Dynatrace State of Observability Report

* Growing complexity
* Explosion of data
* Configuring monitoring detracts from innovation
* Few applications are fully instrumented

<div style="display: flex; flex-direction: column; align-items: center; gap: 8px; margin-top: 48px">
    <img style="width: 130px; height: 130px; margin: 0" src="./img/qr-state-of-observability.svg"/>
    <a style="font-size: small" href="https://www.dynatrace.com/info/reports/state-of-observability-2024/" target="_blank">State of Observability 2024</a>
</div>


#### Puppet State of DevOps Report

## Observability as a key goal of Platform Engineering

<div style="display: flex; flex-direction: column; align-items: center; gap: 8px; margin-top: 48px">
    <img style="width: 130px; height: 130px; margin: 0" src="./img/qr-state-of-devops.svg"/>
    <a style="font-size: small" href="https://www.puppet.com/resources/state-of-platform-engineering" target="_blank">State of DevOps 2023</a>
</div>


<!-- .slide: data-background="img/restaurant-observability.webp" -->


<img src="../img/products/dynatrace.svg" alt="Dynatrace Logo" style="width: 70%"/>



<!-- .slide: data-background="../img/background/hands-on.jpg" -->
## Hands-on Time

# Observability


## Crossplane CLI

```sh
cat cluster/aws.yaml
crossplane beta trace clusterclaim cluster --namespace a-team

cat db/aws.yaml
crossplane beta trace sqlclaim my-db --namespace a-team

cat app.yaml
crossplane beta trace appclaim silly-demo --namespace a-team
```


### Dynatrace Kubernetes App
<img style="margin: 0" src="./img/kubernetes-app.png">


### Cluster Dashboards
<img style="margin: 0" src="./img/cluster-dashboards.png">


### Clouds App
<img style="margin: 0" src="./img/clouds-app.png">


## App Dashboard
<img style="margin: 0" src="./img/app-dashboard.png">


## Generate load

https://app.ddosify.com


## App Traces
<img style="margin: 0" src="./img/app-traces.png">


## Automatic problem notification
<img style="margin: 0" src="./img/notification.png">
