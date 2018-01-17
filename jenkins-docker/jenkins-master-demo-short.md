## Hands-On Time

---

# Jenkins Master Service


## Jenkins Service

---

```bash
source creds

echo "admin" | docker secret create jenkins-user -

echo "admin" | docker secret create jenkins-pass -

curl -o jenkins.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/jenkins/vfarcic-jenkins-df-proxy-aws.yml

cat jenkins.yml

docker stack deploy -c jenkins.yml jenkins
```


## What Did We Get?

---

* Immutable (excluding state)<!-- .element: class="fragment" -->
* Fully Automated<!-- .element: class="fragment" -->
* High Availability<!-- .element: class="fragment" -->
* Fault Tolerance<!-- .element: class="fragment" -->


## Simulating Failure

---

```bash
exit

open "http://$CLUSTER_DNS/jenkins"

# Create a job

open "http://$CLUSTER_DNS/jenkins/exit"

open "http://$CLUSTER_DNS/jenkins"

ssh -i workshop.pem docker@$CLUSTER_IP
```
