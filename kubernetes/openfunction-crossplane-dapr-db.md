## Database-as-a-Service
### Database Server with Everything

```sh
cat db/aws-2.yaml
```

[dot-sql](https://marketplace.upbound.io/configurations/devops-toolkit/dot-sql)


## Database-as-a-Service

```sh
export KUBECONFIG=$PWD/kubeconfig-cp.yaml

kubectl --namespace a-team apply --filename db/aws-2.yaml

crossplane beta trace sqlclaim my-db-2 --namespace a-team

kubectl --namespace a-team delete --filename db/aws-2.yaml

crossplane beta trace sqlclaim my-db --namespace a-team
```


## Database-as-a-Service

```sh
export PGUSER=$(kubectl --namespace a-team \
    get secret my-db --output jsonpath="{.data.username}" \
    | base64 -d)

export PGPASSWORD=$(kubectl --namespace a-team \
    get secret my-db --output jsonpath="{.data.password}" \
    | base64 -d)

export PGHOST=$(kubectl --namespace a-team \
    get secret my-db --output jsonpath="{.data.endpoint}" \
    | base64 -d)
```


## Database-as-a-Service

```sh
kubectl run postgresql-client --rm -ti --restart='Never' \
    --image docker.io/bitnami/postgresql:16 \
    --env PGPASSWORD=$PGPASSWORD --env PGHOST=$PGHOST \
    --env PGUSER=$PGUSER --command -- sh

psql --host $PGHOST -U $PGUSER -d postgres -p 5432

\l

\c my-db

\dt
```


## Database-as-a-Service

```sh
exit

exit

kubectl --namespace a-team get secrets

kubectl --namespace a-team get pushsecrets
```


## Database-as-a-Service

```sh
export KUBECONFIG=$PWD/kubeconfig.yaml

kubectl --namespace production \
    get externalsecrets.external-secrets.io

kubectl --namespace production get secrets

kubectl --namespace production get components
```
