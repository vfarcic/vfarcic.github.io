open "http://localhost/jenkins/configure"

# Click `Global Pipeline Libraries` > `Add`
# Set `my-shared-library` as `Name`
# Set `workshop` as `Default version`
# Check `Load implicitly`
# Check `Modern SCM`
# Check `GitHub`
# Set `vfarcic` as `Owner`
# Set `jenkins-shared-libraries` as `Repository`
# Click `Save`

echo 'import java.text.SimpleDateFormat

pipeline {
  agent {
    label "test"
  }
  options {
    buildDiscarder(logRotator(numToKeepStr: "2"))
    disableConcurrentBuilds()
  }
  environment {
    HOST_IP = [...] // This is AWS DNS
    DOCKER_HUB_USER = [...] // This is Docker Hub user
  }
  stages {
    stage("checkout") {
      steps {
        git "https://github.com/vfarcic/go-demo-2.git"
        stash name: "compose", includes: "docker-compose.yml"
      }
    }
    stage("build") {
      steps {
        dockerBuild("go-demo-2", env.DOCKER_HUB_USER)
      }
    }
    stage("functional") {
      steps {
        dockerFunctional("go-demo-2", env.DOCKER_HUB_USER, env.HOST_IP, "/demo")
      }
    }
    stage("release") {
      steps {
        dockerRelease("go-demo-2", env.DOCKER_HUB_USER)
      }
    }
    stage("deploy") {
      agent {
        label "prod"
      }
      steps {
        unstash "compose"
        dockerDeploy("go-demo-2", env.DOCKER_HUB_USER, env.HOST_IP, "/demo")
      }
    }
  }
  post {
    always {
      dockerCleanup("go-demo-2")
    }
  }
}' | pbcopy

# Replace [...]

echo $CLUSTER_DNS


open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/go-demo-2/activity"

open "https://hub.docker.com/r/$DOCKER_HUB_USER/go-demo-2/tags"

ssh -i workshop.pem docker@$CLUSTER_IP

docker stack ps -f desired-state=running go-demo-2

exit
