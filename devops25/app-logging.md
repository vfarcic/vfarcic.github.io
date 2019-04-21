```bash
PT_HOST=logs7.papertrailapp.com

PT_PORT=17221

cat logging/fluentd-papertrail.yml | sed -e "s@NNNNN@$PT_PORT@g" \
    | sed -e "s@logsN.papertrailapp.com@$PT_HOST@g" \
    | kubectl apply -f -

kubectl -n logging \
  rollout status ds fluentd-papertrail
```


<!-- .slide: data-background="../img/background/why.jpg" -->
# A long time ago in a galaxy far, far away...

---


<!-- .slide: data-background="../img/background/logs.jpeg" -->
## You were writing logs to files

---


<!-- .slide: data-background="../img/background/logs.jpeg" -->
## You realized that you cannot be
# in many places
## at the same time

---


<!-- .slide: data-background="../img/background/logs.jpeg" -->
## You learned that they were supposed to be
# sent to stdout
## all along

---


<!-- .slide: data-background="../img/products/elk.png" -->
## You adopted
# centralized logging

---

```bash
open "https://papertrailapp.com/"
```


<!-- .slide: data-background="../img/background/angry.jpg" -->
## You learned that logging cannot be used to
# prevent problems

---