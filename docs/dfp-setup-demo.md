## Hands-On Time

---

# Docker Flow Proxy


## Docker Flow Proxy

---

```bash
curl -L -o proxy.yml https://goo.gl/NRJa95

cat proxy.yml

docker network create -d overlay proxy

docker stack deploy -c proxy.yml proxy

docker stack ps proxy
```
