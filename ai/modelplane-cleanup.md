<!-- .slide: id="destroy" -->
## Destroy

```sh
./dot.nu destroy
```

Note:
Run from modelplane-demo after the talk or validation session. The saved run identifies the provider and manifests. Keep Docker and the local control plane running until managed-resource deletion completes. Destroy removes models, gateway, and fleet, waits for cloud resources to disappear, then removes KinD. For Google, it also marks this run's dedicated project for deletion. It never deletes an arbitrary default project. If cleanup stalls, retain the control plane, inspect the dependencies, and rerun destroy.
