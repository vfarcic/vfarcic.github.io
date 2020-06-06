<!-- .slide: class="center" -->
<!-- .slide: data-background="data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/cleanup.jpg) center / cover" -->
## Cleanup

```bash
eksctl delete cluster -n $CLUSTER_NAME

for volume in `aws ec2 describe-volumes --output text| grep available | awk '{print $8}'`; do
    echo "Deleting volume $volume"
    aws ec2 delete-volume --volume-id $volume
done
```


<!-- .slide: class="center" -->
<!-- .slide: data-background="data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/cleanup.jpg) center / cover" -->
## Cleanup

```bash
cd ..

hub delete -y $GH_USER/environment-$CLUSTER_NAME-staging

hub delete -y $GH_USER/environment-$CLUSTER_NAME-production

hub delete -y $GH_USER/jx-go
```


<!-- .slide: class="center" -->
<!-- .slide: data-background="data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/cleanup.jpg) center / cover" -->
## Cleanup

```bash
rm -rf ~/.jx/environments/$GH_USER/environment-$CLUSTER_NAME-*

rm -rf jx-go
```
