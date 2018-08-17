## Hands-On Time

---

# Setting Up Ingress And Storage


## Ingress

---

```bash
kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml

kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/aws/service-l4.yaml

kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/aws/patch-configmap-l4.yaml
```


## Storage

---

```bash
echo 'kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: gp2
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
  encrypted: "true"' \
    | kubectl create -f -

kubectl patch storageclass gp2 \
    -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```
