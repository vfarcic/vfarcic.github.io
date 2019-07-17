docker container run --rm -it -v $PWD:/repos vfarcic/git \
    git clone https://github.com/vfarcic/go-demo-2.git

export DOCKER_HUB_USER=[...]

open "http://$CLUSTER_DNS/jenkins/credentials/store/system/domain/_/newCredentials"

# Add `docker`
