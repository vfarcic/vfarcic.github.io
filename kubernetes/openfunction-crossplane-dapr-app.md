## Kubernetes Functions With OpenFunction

```sh
cat function.yaml

kubectl --namespace production apply --filename function.yaml

kubectl --namespace production get functions

kubectl --namespace production get functions

export APP_URL="http://openfunction-demo.production.$INGRESS_IP.nip.io"

curl -X POST \
    "$APP_URL/video?id=1&title=An%20Amazing%20Video"

curl "$APP_URL/videos" | jq .
```


## Kubernetes Functions With OpenFunction

```sh
cat video.go

kubectl --namespace production get pods
```
