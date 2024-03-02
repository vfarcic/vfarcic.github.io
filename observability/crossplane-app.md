# App

```sh
cat app/*.yaml

kubectl --namespace production apply --filename app/

curl "http://sillydemo.$INGRESS_IP.nip.io"

curl -X POST \
    "http://sillydemo.$INGRESS_IP.nip.io/video?id=1&title=An%20Amazing%20Video"

curl "http://sillydemo.$INGRESS_IP.nip.io/videos" | jq .

echo "http://sillydemo.$INGRESS_IP.nip.io"
```

* Generate load on https://app.ddosify.com
