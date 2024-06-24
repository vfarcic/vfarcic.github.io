<!-- .slide: data-background-image="img/console/rethink-portals.png" data-background-opacity="1.0" -->
### Rethinking Developer Portals

Note:
* Current consoles are cumbersome
* Manual configurations are redundant
* Too smart


<!-- .slide: data-background-image="img/console/manual-configuration.png" data-background-opacity="0.5" -->
### The Manual Configuration Dilemma

Note:
* Repetitive form designs
* Ignoring API discoverability
* Time-consuming tasks


<!-- .slide: data-background-image="img/console/api-discovery.png" data-background-opacity="0.5" -->
### Embracing Schema Discovery

Note:
* APIs expose schemas
* Consoles should "discover" not "dictate"
* Focus on API creation, not configuration


<!-- .slide: data-background="../img/background/hands-on.jpg" -->
### Discovery In Action

Note:
* Open [data sources](https://app.getport.io/settings/data-sources) and select `k8s-exporter`.
* Click the `Resync` button and wait for a few moments.
* Open [data models](https://app.getport.io/settings/data-model) screen and show `Sqlclaim`.
* Open [Self-service](https://app.getport.io/self-serve) page and show `Create`, `Update`, and `Delete` actions.


### Crafting Self-Service Actions

```json
{
  "identifier": "create_sqlclaim",
  ...
  "trigger": {
    "type": "self-service",
    "operation": "CREATE",
    "userInputs": {
      "properties": {
        ...
        "compositionRef__name": {
          "type": "string",
          "visible": true
        },
        ...
```


### Crafting Self-Service Actions

* `Edit property` of `compositionRef__name`, set the `Title` to `Composition`, change the `Type` to `Select`, add options `aws-postgresql`, `azure-postgresql`, and `google-postgresql`, and click the `Save` button.


### Crafting Self-Service Actions

* `Edit property` of `parameters__size`. Set the `Title` to `Size`, change the `Type` to `Select`, add options `small`, `medium`, and `large`, and click the `Save` button.


### Crafting Self-Service Actions

* Select the `Backend` button from the top menu, type the `Organization`, set `Repository` to `port-crds-demo`, set `Workflow file name` to `gitops.yaml`, and click the `Save` field.


### Crafting Self-Service Actions

* Do the same for `Update Sqlclaim` and `Delete Sqlclaim`.


<!-- .slide: data-background-image="img/console/developer-self-service.png" data-background-opacity="0.5" -->
### Empowering Developers with Self-Service


* Click the `Create` button in `Create Sqlclaim`
* Pick a composition.
* Use `silly-demo` as both the `id` and the `sqlclaim Name`
* Set `a-team` as the `Namespace`
* Specify the version of the database (set `15` if using Google Cloud, `16.2` if using AWS, `11` if using Azure, or any value if not using any hyperscaler)
* Click the `Execute` button.


<!-- .slide: data-background-image="img/console/behind-the-scene.png" data-background-opacity="0.5" -->
### Unveiling the Magic Behind the Scenes


<!-- .slide: data-background-color="black" data-background-image="img/console/diag-01-00.png" data-background-size="contain" -->


<!-- .slide: data-background-color="black" data-background-image="img/console/diag-01-01.png" data-background-size="contain" -->


<!-- .slide: data-background-color="black" data-background-image="img/console/diag-01-02.png" data-background-size="contain" -->


<!-- .slide: data-background-color="black" data-background-image="img/console/diag-01-03.png" data-background-size="contain" -->


<!-- .slide: data-background-color="black" data-background-image="img/console/diag-01-04.png" data-background-size="contain" -->


<!-- .slide: data-background-color="black" data-background-image="img/console/diag-01-05.png" data-background-size="contain" -->


<!-- .slide: data-background-color="black" data-background-image="img/console/diag-01-06.png" data-background-size="contain" -->


<!-- .slide: data-background-color="black" data-background-image="img/console/diag-01-07.png" data-background-size="contain" -->


<!-- .slide: data-background-color="black" data-background-image="img/console/diag-01-08.png" data-background-size="contain" -->


<!-- .slide: data-background-color="black" data-background-image="img/console/diag-01-09.png" data-background-size="contain" -->


<!-- .slide: data-background-color="black" data-background-image="img/console/diag-01-10.png" data-background-size="contain" -->


<!-- .slide: data-background="../img/background/hands-on.jpg" -->
### Unveiling the Magic Behind the Scenes

```sh
kubectl get crds

kubectl get crds | grep devops

kubectl explain appclaims.devopstoolkitseries.com --recursive

cat .github/workflows/gitops.yaml

git pull

ls -1 apps/

cat apps/a-team-SQLClaim-silly-demo.yaml
```


<!-- .slide: data-background="../img/background/hands-on.jpg" -->
### Unveiling the Magic Behind the Scenes

```sh
echo "http://argocd.127.0.0.1.nip.io"
```

* Open the URL in a browser.
* Use `admin` as the username and `admin123` as the password.
* Show the `a-team` Application.

```sh
crossplane beta trace sqlclaim silly-demo --namespace a-team
```