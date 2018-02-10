# Cleanup

```bash
aws cloudformation delete-stack --stack-name devops22

aws cloudformation describe-stacks --stack-name devops22 | \
  jq -r ".Stacks[0].StackStatus"
```
