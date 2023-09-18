# Declarative Infrastructure


## Desired State

```bash
cd devops-catalog-code/terraform-eks/simple

cat main.tf
```

* It's (more or less) declarative
* Both humans and machines can (more or less) find out what the desired state is


## Drift-Detection

```bash
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

* Discovery
* On-demand
* Managed
* Self-service


## What Do We Need?

* API (Discovery, On-demand)
* Continuous drift-detection and reconciliation (Managed)
* API extensions (Self-service)
