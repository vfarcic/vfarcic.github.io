## Kubernetes Functions With OpenFunction

```sh
cat function.yaml

kubectl --namespace production apply --filename function.yaml

kubectl --namespace production get functions

kubectl --namespace production get functions

export APP_URL="http://openfunction-demo.production.$INGRESS_IP.nip.io"

curl "$APP_URL"

curl -X POST \
    "$APP_URL/video?id=1&title=An%20Amazing%20Video"
```


## Kubernetes Functions With OpenFunction

```sh
curl "$APP_URL/videos" | jq .

kubectl --namespace production get pods

kubectl --namespace production get pods

curl "$APP_URL/videos" | jq .

kubectl --namespace production get pods

cat video.go
```
