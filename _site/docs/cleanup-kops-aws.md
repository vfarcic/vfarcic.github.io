# Cleanup

```bash
kops delete cluster --name $NAME --yes

aws s3api delete-bucket --bucket $BUCKET_NAME
```
