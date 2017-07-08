## Hands-On Time

---

# CI with Docker


# Unit Tests & Build

---

```bash
ssh -i devops21.pem ubuntu@$(terraform output ci_public_ip)

git clone https://github.com/vfarcic/go-demo.git

cd go-demo

cat docker-compose-test-local.yml

docker-compose -f docker-compose-test.yml run --rm unit

ll | grep go-demo
```


# Building Images

---

```bash
cat Dockerfile

cat docker-compose-test-local.yml

docker-compose -f docker-compose-test-local.yml build app

docker images
```


# Combining Testing and Building

---

```bash
git checkout multi-stage-builds

cat Dockerfile

docker image build -t go-demo .
```


# Staging tests

---

```bash
cat docker-compose-test-local.yml

docker-compose -f docker-compose-test-local.yml \
  up -d staging-dep

docker-compose -f docker-compose-test-local.yml ps

docker-compose -f docker-compose-test-local.yml \
  run --rm staging

docker-compose -f docker-compose-test-local.yml down

docker-compose -f docker-compose-test-local.yml ps
```


# Registry

---

```bash
cat docker-compose-local.yml

docker-compose -f docker-compose-local.yml up -d registry

docker pull alpine

docker tag alpine localhost:5000/alpine

docker push localhost:5000/alpine

docker tag go-demo localhost:5000/go-demo:1.0

docker push localhost:5000/go-demo:1.0

ll docker/registry/v2/repositories/go-demo
```


# Cleanup

---

```bash
exit

terraform destroy -target aws_instance.ci -force
```