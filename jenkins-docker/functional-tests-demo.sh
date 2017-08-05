ssh -i workshop.pem docker@$CLUSTER_IP

curl -o go-demo-2.yml https://raw.githubusercontent.com/vfarcic/go-demo-2/master/stack.yml

export HUB_USER=[...]

docker stack deploy -c go-demo-2.yml go-demo-2

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/go-demo-2/activity"

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
    SERVICE_PATH = "/demo-${env.BUILD_NUMBER}"
    HOST_IP = [...] // This is AWS DNS
    HUB_USER = [...] // This is Docker Hub user
  }
  stages {
    stage("build") {
      steps {
        script {
          def dateFormat = new SimpleDateFormat("yy.MM.dd")
          currentBuild.displayName = dateFormat.format(new Date()) + "-" + env.BUILD_NUMBER
        }
        git "https://github.com/vfarcic/go-demo-2.git"
        sh "docker image build -t ${env.HUB_USER}/go-demo-2:beta-${currentBuild.displayName} ."
        withCredentials([usernamePassword(
          credentialsId: "docker",
          usernameVariable: "USER",
          passwordVariable: "PASS"
        )]) {
          sh "docker login -u $USER -p $PASS"
        }
        sh "docker push ${env.HUB_USER}/go-demo-2:beta-${currentBuild.displayName}"
      }
    }
    stage("functional") {
      steps {
        sh "TAG=beta-${currentBuild.displayName} docker stack deploy -c stack-test.yml go-demo-2-beta-${currentBuild.displayName}"
        sh "docker image build -f Dockerfile.test -t ${env.HUB_USER}/go-demo-2-test:${currentBuild.displayName} ."
        sh "docker image push ${env.HUB_USER}/go-demo-2-test:${currentBuild.displayName}"
        sh "TAG=${env.BUILD_NUMBER} docker-compose -p go-demo-2-${env.BUILD_NUMBER} run --rm functional"
      }
    }
  }
  post {
    always {
      sh "docker stack rm go-demo-2-beta-${currentBuild.displayName}"
      sh "docker system prune -f"
    }
  }
}' | pbcopy

# TODO: Change [...]
