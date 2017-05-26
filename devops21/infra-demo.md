## Hands-On Time

---

# Immutable

# infrastructure

# as code


# Prerequisites

---

* [Git](https://git-scm.com/)
* [AWS account](https://aws.amazon.com/)
* [AWS CLI](https://aws.amazon.com/cli/)
* [Packer](https://www.packer.io/)
* [Terraform](https://www.terraform.io/downloads.html)
* [jq](https://stedolan.github.io/jq/)
* GitBash (if Windows)


# Environment variables

---

```bash
export AWS_ACCESS_KEY_ID=[...]

export AWS_SECRET_ACCESS_KEY=[...]

export AWS_DEFAULT_REGION=us-east-1

export TF_VAR_aws_access_key=[...]

export TF_VAR_aws_secret_key=[...]

export TF_VAR_aws_default_region=us-east-1
```


# Build images

![The flow of the Packer process](../img/diags/cloud-architecture-images.png)


# Build images

---

```bash
git clone https://github.com/vfarcic/cloud-provisioning.git

cd cloud-provisioning/terraform/aws-full

aws ec2 create-key-pair --key-name devops21 \
  | jq -r '.KeyMaterial' >devops21.pem

chmod 400 devops21.pem

cat packer-ubuntu-docker-compose.json

packer build -machine-readable packer-ubuntu-docker-compose.json \
  | tee packer-ubuntu-docker-compose.log
```


# Create VM Instances

![The flow of the Terraform process](../img/diags/cloud-architecture-instances.png)


# Create VM Instances

---

```bash
export TF_VAR_ci_ami_id=$(grep 'artifact,0,id' \
  packer-ubuntu-docker-compose.log | cut -d: -f2)

cat docker.tf

terraform plan -target aws_instance.ci -var ci_count=1

terraform apply -target aws_instance.ci -var ci_count=1

terraform refresh

ssh -i devops21.pem ubuntu@$(terraform output ci_public_ip) \
    docker version

ssh -i devops21.pem ubuntu@$(terraform output ci_public_ip) \
    docker-compose version
```
