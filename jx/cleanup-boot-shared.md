## Cleanup

```bash
cd ..

hub delete -y $GH_USER/environment-$CLUSTER_NAME-staging

hub delete -y $GH_USER/environment-$CLUSTER_NAME-production

hub delete -y $GH_USER/environment-$CLUSTER_NAME-dev

hub delete -y $GH_USER/jx-go

hub delete -y $GH_USER/jx-serverless
```


## Cleanup

```bash
hub delete -y $GH_USER/jx-prow

hub delete -y $GH_USER/jx-knative
```


## Cleanup

```bash
rm -rf ~/.jx/environments/$GH_USER/environment-$CLUSTER_NAME-*

rm -rf jx-go

rm -rf jx-serverless

rm -rf jx-prow

rm -rf jx-knative

rm -rf environment-$CLUSTER_NAME-*
```

<!--
unset KUBECONFIG

rm kubeconfig

cd terraform-gke

terraform destroy
-->