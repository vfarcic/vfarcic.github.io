# What is IDP?

- Services - Do something
- APIs - Single point of control and observability
- Policies - What can and cannot be done
- User Interfaces - What users use


## Do NOT reinvent the wheel

- That pattern is used in any public platform (AWS, Azure, Google Cloud, GitHub, etc.)


## Bonus?

- Notifications


## Why Kubernetes?

- Almost everything is already there


## Why Kubernetes?

- Services == Controllers
- APIs == CRDs
- User Interaces == Anything (CLI, Web UI, IDE, etc.)
- Policies == Validating Admission Policies / Kyverno
- Notifications == Kubernetes events


## Why Crossplane?

- Extends Kubernetes to act as a control plane for everything (providers)
- Creates controllers (Compositions) and custom API (XRDs)

```sh
kubectl get compositions

kubectl api-resources | grep devopstoolkit
```


## Demo

```sh
cat examples/sql.yaml

kubectl --namespace a-team apply --filename examples/sql.yaml

kubectl --namespace a-team get sqls

kubectl --namespace a-team get managed
```


## AI?

- AI needs APIs just as much as you (or more)
- Platform == predictable and declarative
- Intelligence == uses platform


## AI?

- AI alone is not enough.
- Kubernetes and Crossplane are the base.


## What's Missing?

- System prompts
- Context through semantic search
- Specialized tools
- ...


## Demo

> Open http://dot-ai-ui.127.0.0.1.nip.io in a browser

> Use `my-secret-token` as the token
