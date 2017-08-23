## Hands-On Time

---

# Auto-Scaling


## Scaling Down Services

---

```bash
open "http://$(docker-machine ip swarm-1)/monitor/alerts"

open "http://$(docker-machine ip swarm-1)/jenkins/blue/organizations/jenkins/service-scale/activity"

docker stack ps -f desired-state=running go-demo

# Wait for 10 minutes

open "http://$(docker-machine ip swarm-1)/jenkins/blue/organizations/jenkins/service-scale/activity"

open "http://slack.devops20toolkit.com/"

open "https://devops20.slack.com/messages/C59EWRE2K/"
```


## Scaling Up Services

---

```bash
for i in {1..30}; do
    DELAY=$[ $RANDOM % 6000 ]
    curl "http://$(docker-machine ip swarm-1)/demo/hello?delay=$DELAY"
done

open "http://$(docker-machine ip swarm-1)/monitor/alerts"

open "http://$(docker-machine ip swarm-1)/jenkins/blue/organizations/jenkins/service-scale/activity"

docker stack ps -f desired-state=running go-demo
```
