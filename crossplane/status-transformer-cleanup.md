## Cleanup

```bash
chmox +x examples/destroy.nu

./examples/destroy.nu

yq --inplace \
    '.spec.package = "xpkg.upbound.io/devops-toolkit/dot-sql:v0.8.132"' \
    config.yaml

exit
```
