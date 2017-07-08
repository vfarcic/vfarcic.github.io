## Hands-On Time

---

# CI with Docker


# Building Images

---

```bash
git clone https://github.com/vfarcic/go-demo.git

cd go-demo

cat Dockerfile

docker image build -t go-demo .

docker image ls
```


# Building Images

---

```bash
cat Dockerfile.big

docker image build -f Dockerfile.big -t go-demo .

docker image ls
```


## Building Images

---

```bash
cat Dockerfile.multistage

docker image build -f Dockerfile.multistage -t go-demo .

docker image ls
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