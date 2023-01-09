# Declarative Infrastructure


## Desired State

```bash
cat main.tf
```

* It's (more or less) declarative
* Both humans and machines can (more or less) find out what the desired state is


## Drift-Detection

```bash
devops-catalog-code/terraform-eks/simple

terraform apply --var min_node_count=4
```


## Reconciliation

```
yes
```


# What's Missing?


## What's Missing?

# Actual State

```bash
terraform show
```


## What's Missing?

# Continuous
# Drift-Detection


## What's Missing?

# Continuous Reconciliation


## What's Missing?

# Discovery

```bash
cat variables.tf
```


## What's Missing?

# Shift-left


## What Do We Need?

* Continuous drift-detection and reconciliation
* API for discovery
* API extensions for shift-left
