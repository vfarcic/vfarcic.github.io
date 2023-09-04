# Before
## Declarative
## Infrastructure


# Console?


# Console?

## How do you...

* ... document what you did? Screnshots? Wiki?
* ... reliably reproduce it? Type slowly?
* ... collaborate on it? Screenshare?
* ... keep up with changes and updates? Change logs?


# CLI?

```bash
# Do NOT run this
eksctl create cluster --name dot --region us-east1 \
    --nodes-min 1 --nodes-max 10 --nodes 1
```


# CLI?

## How do you...

* ... document what you did? Shell scripts?
* ... reliably reproduce it? Re-run the scripts?
* ... collaborate on it? Markdown docs?
* ... keep up with changes and updates? If/else statements?


# There's More

## How do you...

* ... know what the desired state is?
* ... know what the current state is?
* ... detect a drift between those states?
* ... reconcile the drift between those states?


# Desired State

## What something should be


# Actual State

## What something is


# Drift

## The difference between
## the desired and the actual state


# Reconciliation

## Removal of the drift between
## the desired and the actual state


# How Do We...

## ... make the states readable by humans and machines?


# Declarative

* JSON
* YAML
* HCL
* ...


# How about...

* Python?
* Go?
* Java?
* JavaScript?
* ...


## Programming Languages

# Bad for deducing the desired state


## Programming Languages

# OK for creating declarative specs
