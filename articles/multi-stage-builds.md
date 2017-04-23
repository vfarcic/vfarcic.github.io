# Multi-Stage Builds

## Requirements

* Docker 17.05.0+

```
git clone https://github.com/vfarcic/go-demo.git

cd go-demo

# docker-compose -f docker-compose-test.yml run --rm unit

# TODO: Switch to multi-stage-builds branch

DOCKER_USER=vfarcic # Change to your user

docker image build -t $DOCKER_USER/go-demo:multi-stage .

docker image push $DOCKER_USER/go-demo:multi-stage


```