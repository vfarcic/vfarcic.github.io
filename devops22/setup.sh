#!/usr/bin/env bash

echo "export CLUSTER_DNS=[...]
export CLUSTER_IP=[...]
export DOCKER_HUB_USER=[...]
">creds

docker node ls

curl -o visualizer.yml https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/web/docker-visualizer.yml

HTTP_PORT=8083 docker stack deploy -c visualizer.yml visualizer

curl -o proxy.yml \
  https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/proxy/docker-flow-proxy.yml

docker network create -d overlay proxy

docker stack deploy -c proxy.yml proxy

curl -o monitor.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/docker-flow-monitor-mem.yml

docker stack rm monitor

docker network create -d overlay monitor

source creds

DOMAIN=$CLUSTER_DNS docker stack deploy -c monitor.yml monitor

curl -o exporters.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/exporters-mem.yml

docker stack deploy -c exporters.yml exporter

curl -o go-demo.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/go-demo-mem.yml

docker stack deploy -c go-demo.yml go-demo

# TODO: Continue

docker service update --label-add com.df.alertName=mem \
    --label-add com.df.alertIf='container_memory_usage_bytes{container_label_com_docker_swarm_service_name="go-demo_main"} > 20000000' \
    go-demo_main

exit

open "http://$CLUSTER_DNS/monitor/config"

open "http://$CLUSTER_DNS/monitor/rules"

open "http://$CLUSTER_DNS/monitor/alerts"

open "http://$CLUSTER_DNS/monitor/graph"

# container_memory_usage_bytes{container_label_com_docker_swarm_service_name="go-demo_main"}

ssh -i workshop.pem docker@$CLUSTER_IP

docker service update --label-add com.df.alertName=mem \
    --label-add com.df.alertIf='container_memory_usage_bytes{container_label_com_docker_swarm_service_name="go-demo_main"} > 1000000' \
    go-demo_main

exit

open "http://$CLUSTER_DNS/monitor/alerts"

open "http://$CLUSTER_DNS/monitor/graph"

# container_spec_memory_limit_bytes{container_label_com_docker_swarm_service_name="go-demo_main"}

# container_memory_usage_bytes{container_label_com_docker_swarm_service_name="go-demo_main"}

ssh -i workshop.pem docker@$CLUSTER_IP

docker service update --label-add com.df.alertName=mem_limit \
    --label-add com.df.alertIf='container_memory_usage_bytes{container_label_com_docker_swarm_service_name="go-demo"}/container_spec_memory_limit_bytes{container_label_com_docker_swarm_service_name="go-demo"} > 0.8' \
    go-demo_main

exit

open "http://$CLUSTER_DNS/monitor/alerts"

ssh -i workshop.pem docker@$CLUSTER_IP

docker service update \
    --label-add com.df.alertName.1=mem_load \
    --label-add com.df.alertIf.1='(sum by (instance) (node_memory_MemTotal) - sum by (instance) (node_memory_MemFree + node_memory_Buffers + node_memory_Cached)) / sum by (instance) (node_memory_MemTotal) > 0.8' \
    --label-add com.df.alertName.2=diskload \
    --label-add com.df.alertIf.2='(node_filesystem_size{fstype="aufs"} - node_filesystem_free{fstype="aufs"}) / node_filesystem_size{fstype="aufs"} > 0.8' \
    exporter_node-exporter

exit

open "http://$CLUSTER_DNS/monitor/alerts"

ssh -i workshop.pem docker@$CLUSTER_IP

curl -o go-demo.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/go-demo-alert-long.yml

cat go-demo.yml

docker stack deploy -c go-demo.yml go-demo

exit

open "http://$CLUSTER_DNS/monitor/alerts"

ssh -i workshop.pem docker@$CLUSTER_IP

docker service update \
    --label-add com.df.alertIf='container_memory_usage_bytes{container_label_com_docker_swarm_service_name="go-demo_main"}/container_spec_memory_limit_bytes{container_label_com_docker_swarm_service_name="go-demo_main"} > 0.05' \
    go-demo_main

exit

open "http://$CLUSTER_DNS/monitor/alerts"

ssh -i workshop.pem docker@$CLUSTER_IP

curl -o go-demo.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/go-demo-alert-info.yml

cat go-demo.yml

docker stack deploy -c go-demo.yml go-demo

exit

open "http://$CLUSTER_DNS/monitor/alerts"

ssh -i workshop.pem docker@$CLUSTER_IP

curl -o go-demo.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/go-demo-alert.yml

cat go-demo.yml

docker stack deploy -c go-demo.yml go-demo

curl -o exporters.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/exporters-alert.yml

cat go-demo.yml

docker stack deploy -c exporters.yml exporter

exit

open "http://$CLUSTER_DNS/monitor/alerts"

ssh -i workshop.pem docker@$CLUSTER_IP

########################
# alert-humans-demo.md #
########################

echo 'route:
  receiver: "slack"
  repeat_interval: 1h

receivers:
  - name: "slack"
    slack_configs:
      - send_resolved: true
        text: "Something horrible happened! Run for your lives!"
        api_url: "https://hooks.slack.com/services/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"
' | docker secret create alert_manager_config -

curl -o alert-manager.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/alert-manager-slack.yml

cat alert-manager.yml

docker stack deploy -c alert-manager.yml alert-manager

source creds

curl -H "Content-Type: application/json" \
    -d '[{"labels":{"alertname":"My Fancy Alert"}}]' \
    $CLUSTER_IP:9093/api/v1/alerts

docker stack rm alert-manager

curl -o monitor.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/docker-flow-monitor-slack.yml

cat monitor.yml

DOMAIN=$CLUSTER_DNS docker stack deploy -c monitor.yml monitor

exit

open "http://$CLUSTER_DNS/monitor/flags"

ssh -i workshop.pem docker@$CLUSTER_IP

docker service update \
    --label-add com.df.alertIf=@service_mem_limit:0.1 go-demo_main

exit

open "http://$CLUSTER_DNS/monitor/alerts"

ssh -i workshop.pem docker@$CLUSTER_IP

docker service update \
    --label-add com.df.alertIf=@service_mem_limit:0.8 go-demo_main

exit

open "http://$CLUSTER_DNS/monitor/alerts"

ssh -i workshop.pem docker@$CLUSTER_IP

docker service rm monitor_alert-manager

docker secret rm alert_manager_config

source creds

echo "route:
  group_by: [service]
  receiver: 'slack'
  repeat_interval: 1h

receivers:
  - name: 'slack'
    slack_configs:
      - send_resolved: true
        title: '[{{ .Status | toUpper }}] {{ .GroupLabels.service }} service is in danger!'
        title_link: 'http://$CLUSTER_DNS/monitor/alerts'
        text: '{{ .CommonAnnotations.summary}}'
        api_url: 'https://hooks.slack.com/services/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'
" | docker secret create alert_manager_config -

curl -o monitor.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/docker-flow-monitor-slack.yml

cat monitor.yml

DOMAIN=$CLUSTER_DNS docker stack deploy -c monitor.yml monitor

docker service update \
    --label-add com.df.alertIf=@service_mem_limit:0.1 go-demo_main

exit

open "http://$CLUSTER_DNS/monitor/alerts"

ssh -i workshop.pem docker@$CLUSTER_IP

docker service update \
    --label-add com.df.alertIf=@service_mem_limit:0.8 \
    go-demo_main

##############################
# self-heal-services-demo.md #
##############################


docker service scale go-demo_main=5

CONTAINER_ID=$(docker container ls -q \
    -f "label=com.docker.swarm.service.name=go-demo_main" \
    | tail -n 1)

docker container exec -it $CONTAINER_ID pkill go-demo

docker stack ps -f desired-state=Running go-demo

docker stack ps go-demo

# TODO

###############################
# self-adapt-services-demo.md #
###############################


curl -o jenkins.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/jenkins.yml

cat jenkins.yml

echo "admin" | docker secret create jenkins-user -

echo "admin" | docker secret create jenkins-pass -

export SLACK_IP=$(ping -c 1 devops20.slack.com \
    | awk -F'[()]' '/PING/{print $2}')

docker stack deploy -c stacks/jenkins.yml jenkins

exit

open "http://$CLUSTER_DNS/jenkins"

open "http://$CLUSTER_DNS/jenkins/computer"

open "http://$CLUSTER_DNS/jenkins/newJob"

# Type *service-scale* as the item name
# Select *Pipeline* as job type
# Click the *OK* button
# Select the *Trigger builds remotely* checkbox
# Type *DevOps22* as the *Authentication Token*
# Type the script that follows inside the *Pipeline Script* field

# Groovy

#pipeline {
#  agent {
#      label "prod"
#  }
#  parameters {
#    string(
#      name: "service",
#      defaultValue: "",
#      description: "The name of the service that should be scaled"
#    )
#    string(
#      name: "scale",
#      defaultValue: "",
#      description: "Number of replicas to add or remove."
#      )
#  }
#  stages {
#    stage("Scale") {
#      steps {
#        script {
#          def inspectOut = sh script: "docker service inspect $service",
#            returnStdout: true
#          def inspectJson = readJSON text: inspectOut.trim()
#          def currentReplicas = inspectJson[0].Spec.Mode.Replicated.Replicas
#          def newReplicas = currentReplicas + scale.toInteger()
#          sh "docker service scale $service=$newReplicas"
#          echo "$service was scaled from $currentReplicas to $newReplicas replicas"
#        }
#      }
#    }
#  }
#}

# Click the *Save* button
# Click the *Open Blue Ocean* link located in the left-hand menu.
# Click the *Run* button

curl -X POST "http://$CLUSTER_DNS/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=2"

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/service-scale/activity"

ssh -i workshop.pem docker@$CLUSTER_IP

docker stack ps -f desired-state=Running go-demo

exit

curl -X POST "http://$CLUSTER_DNS/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=-1"

ssh -i workshop.pem docker@$CLUSTER_IP

docker stack ps -f desired-state=Running go-demo

curl -o go-demo.yml \
  https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/go-demo-scale.yml

cat go-demo.yml

docker stack deploy -c go-demo.yml go-demo

exit

open "http://$CLUSTER_DNS/jenkins/job/service-scale/configure"

# groovy

#pipeline {
#  agent {
#      label "prod"
#  }
#  parameters {
#    string(
#      name: "service",
#      defaultValue: "",
#      description: "The name of the service that should be scaled"
#    )
#    string(
#      name: "scale",
#      defaultValue: "",
#      description: "Number of replicas to add or remove."
#    )
#  }
#  stages {
#    stage("Scale") {
#      steps {
#        script {
#          def inspectOut = sh script: "docker service inspect $service",
#            returnStdout: true
#          def inspectJson = readJSON text: inspectOut.trim()
#          def currentReplicas = inspectJson[0].Spec.Mode.Replicated.Replicas
#          def newReplicas = currentReplicas + scale.toInteger()
#          def minReplicas = inspectJson[0].Spec.Labels["com.df.scaleMin"].toInteger()
#          def maxReplicas = inspectJson[0].Spec.Labels["com.df.scaleMax"].toInteger()
#          if (newReplicas > maxReplicas) {
#            error "$service is already scaled to the maximum number of $maxReplicas replicas"
#          } else if (newReplicas < minReplicas) {
#            error "$service is already descaled to the minimum number of $minReplicas replicas"
#          } else {
#            sh "docker service scale $service=$newReplicas"
#            echo "$service was scaled from $currentReplicas to $newReplicas replicas"
#          }
#        }
#      }
#    }
#  }
#}

curl -X POST "http://$CLUSTER_DNS/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=1"

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/service-scale/activity"

ssh -i workshop.pem docker@$CLUSTER_IP

docker stack ps -f desired-state=Running go-demo

exit

curl -X POST "http://$CLUSTER_DNS/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=1"

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/service-scale/activity"

open "http://$CLUSTER_DNS/jenkins/configure"

# Scroll to *Global Slack Notifier Settings*
# Enter *devops20* in the *Team Subdomain* field
# Enter *2Tg33eiyB0PfzxII2srTeMbd* in the *Integration Token* field
# Click the *Apply* button
# Click the *Test Connection* button

open "http://slack.devops20toolkit.com"

open "https://devops20.slack.com/messages/C59EWRE2K/team/U2ZLK8MLM"

open "http://$CLUSTER_DNS/jenkins/job/service-scale/configure"

# Replace the pipeline with the one from the next slide

# groovy

#pipeline {
#    agent {
#        label "prod"
#    }
#    parameters {
#        string(
#                name: "service",
#                defaultValue: "",
#                description: "The name of the service that should be scaled"
#        )
#        string(
#                name: "scale",
#                defaultValue: "",
#                description: "Number of replicas to add or remove."
#        )
#    }
#    stages {
#        stage("Scale") {
#            steps {
#                script {
#                    def inspectOut = sh(
#                            script: "docker service inspect $service",
#                            returnStdout: true
#                    )
#                    def inspectJson = readJSON text: inspectOut.trim()
#                    def currentReplicas = inspectJson[0].Spec.Mode.Replicated.Replicas
#                    def newReplicas = currentReplicas + scale.toInteger()
#                    def minReplicas = inspectJson[0].Spec.Labels["com.df.scaleMin"].toInteger()
#                    def maxReplicas = inspectJson[0].Spec.Labels["com.df.scaleMax"].toInteger()
#                    if (newReplicas > maxReplicas) {
#                        error "$service is already scaled to the maximum number of $maxReplicas replicas"
#                    } else if (newReplicas < minReplicas) {
#                        error "$service is already descaled to the minimum number of $minReplicas replicas"
#                    } else {
#                        sh "docker service scale $service=$newReplicas"
#                        echo "$service was scaled from $currentReplicas to $newReplicas replicas"
#                    }
#                }
#            }
#        }
#    }
#    post {
#        failure {
#            slackSend(
#                    color: "danger",
#                    message: """$service could not be scaled.
#Please check Jenkins logs for the job ${env.JOB_NAME} #${env.BUILD_NUMBER}
#${env.RUN_DISPLAY_URL}"""
#            )
#        }
#    }
#}

curl -X POST "http://$CLUSTER_DNS/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=-123"

ssh -i workshop.pem docker@$CLUSTER_IP

docker service rm monitor_alert-manager

docker secret rm alert_manager_config

echo "route:
  group_by: [service]
  repeat_interval: 1h
  receiver: 'jenkins-go-demo_main'

receivers:
  - name: 'jenkins-go-demo_main'
    webhook_configs:
      - send_resolved: false
        url: 'http://$(docker-machine ip swarm-1)/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=1'
" | docker secret create alert_manager_config -

source creds

DOMAIN=$CLUSTER_DNS docker stack deploy \
    -c stacks/docker-flow-monitor-slack-9093.yml monitor

docker service scale go-demo_main=3

exit

curl -H "Content-Type: application/json" \
    -d '[{"labels":{"service":"it-does-not-matter"}}]' \
    $CLUSTER_DNS:9093/api/v1/alerts

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/service-scale/activity"

ssh -i workshop.pem docker@$CLUSTER_IP

docker service ps -f desired-state=Running go-demo_main

docker service rm monitor_alert-manager

docker secret rm alert_manager_config

source creds

echo "route:
  group_by: [service]
  repeat_interval: 1h
  receiver: 'slack'
  routes:
  - match:
      service: 'go-demo_main'
    receiver: 'jenkins-go-demo_main'

receivers:
  - name: 'slack'
    slack_configs:
      - send_resolved: true
        title: '[{{ .Status | toUpper }}] {{ .GroupLabels.service }} service is in danger!'
        title_link: 'http://$CLUSTER_DNS/monitor/alerts'
        text: '{{ .CommonAnnotations.summary}}'
        api_url: 'https://hooks.slack.com/services/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'
  - name: 'jenkins-go-demo_main'
    webhook_configs:
      - send_resolved: false
        url: 'http://$CLUSTER_DNS/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=1'
" | docker secret create alert_manager_config -

DOMAIN=$CLUSTER_DNS docker stack deploy \
    -c stacks/docker-flow-monitor-slack.yml monitor

docker service scale go-demo_main=3

docker service update \
    --label-add com.df.alertIf.1=@node_mem_limit:0.01 \
    exporter_node-exporter

exit

open "http://$CLUSTER_DNS/monitor/alerts"

open "https://devops20.slack.com/messages/C59EWRE2K/team/U2ZLK8MLM"

ssh -i workshop.pem docker@$CLUSTER_IP

docker service update \
    --label-add com.df.alertIf.1=@node_mem_limit:0.8 \
    exporter_node-exporter

docker service update \
    --label-add com.df.alertIf=@service_mem_limit:0.01 \
    go-demo_main

exit

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/service-scale/activity"

ssh -i workshop.pem docker@$CLUSTER_IP

docker service ps -f desired-state=Running go-demo_main

###############################
# instrument-services-demo.md #
###############################

open "https://github.com/vfarcic/docker-flow-swarm-listener/blob/master/metrics/prometheus.go"

open "https://github.com/vfarcic/docker-flow-swarm-listener/blob/master/main.go"

docker service create --name util --mode global --network proxy \
    alpine sleep 1000000

ID=$(docker container ls -q \
    -f "label=com.docker.swarm.service.name=util")

docker container exec -it $ID apk add --update curl

docker container exec -it $ID \
    curl "http://proxy_swarm-listener:8080/metrics"

docker service update --mount-rm /var/run/docker.sock \
    proxy_swarm-listener

docker service logs proxy_swarm-listener

docker container exec -it $ID \
    curl "http://swarm-listener:8080/metrics"

docker stack deploy -c stacks/docker-flow-proxy-mem.yml proxy

docker service rm proxy_proxy

docker stack deploy -c stacks/go-demo-scale.yml go-demo

docker service logs proxy_swarm-listener

docker container exec -it $ID \
    curl "http://swarm-listener:8080/metrics"

docker stack deploy -c stacks/docker-flow-proxy-mem.yml proxy

open "https://github.com/vfarcic/docker-flow-swarm-listener/blob/master/metrics/prometheus.go"

open "https://github.com/vfarcic/docker-flow-swarm-listener/blob/master/main.go"

docker container exec -it $ID \
    curl "http://swarm-listener:8080/metrics"

docker service rm go-demo_main

docker container exec -it $ID \
    curl "http://swarm-listener:8080/metrics"

docker stack deploy -c stacks/go-demo-scale.yml go-demo

open "https://github.com/vfarcic/go-demo/blob/master/main.go"

for i in {1..100}; do
    curl "http://$(docker-machine ip $NODE)/demo/hello"
done

docker container exec -it $ID \
    curl "http://go-demo_main:8080/metrics"

for i in {1..100}; do
    curl "http://$(docker-machine ip $NODE)/demo/random-error"
done

docker container exec -it $ID \
    curl "http://go-demo_main:8080/metrics"

for i in {1..30}; do
    DELAY=$[ $RANDOM % 6000 ]
    curl "http://$(docker-machine ip $NODE)/demo/hello?delay=$DELAY"
done

docker container exec -it $ID \
    curl "http://go-demo_main:8080/metrics"

##########################################
# self-adapt-services-instrument-demo.md #
##########################################

curl -o go-demo.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/go-demo-instrument.yml

cat stacks/go-demo.yml

docker stack deploy -c go-demo.yml go-demo

exit

open "http://$CLUSTER_DNS/monitor/config"

open "http://$CLUSTER_DNS/monitor/targets"

open "http://$CLUSTER_DNS/monitor/graph"

# http_server_resp_time_sum / http_server_resp_time_count

for i in {1..30}; do
    DELAY=$[ $RANDOM % 6000 ]
    curl "http://$CLUSTER_DNS/demo/hello?delay=$DELAY"
done

# rate(http_server_resp_time_sum[5m]) / rate(http_server_resp_time_count[5m])

# sum(rate(http_server_resp_time_sum[5m])) by (job) / sum(rate(http_server_resp_time_count[5m])) by (job)

# sum(rate(http_server_resp_time_bucket{le="0.1"}[5m])) by (job) / sum(rate(http_server_resp_time_count[5m])) by (job)

# sum(rate(http_server_resp_time_bucket{job="go-demo_main",le="0.1"}[5m])) / sum(rate(http_server_resp_time_count{job="go-demo_main"}[5m]))

for i in {1..100}; do
    curl "http://$CLUSTER_DNS/demo/random-error"
done

# sum(rate(http_server_resp_time_count{code=~"^5..$"}[5m])) by (job)

# sum(rate(http_server_resp_time_count{code=~"^5..$"}[5m])) by (job) / sum(rate(http_server_resp_time_count[5m])) by (job)

docker stack rm monitor

docker secret rm alert_manager_config

echo "route:
  group_by: [service,scale]
  repeat_interval: 5m
  group_interval: 5m
  receiver: 'slack'
  routes:
  - match:
      service: 'go-demo_main'
      scale: 'up'
    receiver: 'jenkins-go-demo_main-up'

receivers:
  - name: 'slack'
    slack_configs:
      - send_resolved: true
        title: '[{{ .Status | toUpper }}] {{ .GroupLabels.service }} service is in danger!'
        title_link: 'http://$(docker-machine ip swarm-1)/monitor/alerts'
        text: '{{ .CommonAnnotations.summary}}'
        api_url: 'https://hooks.slack.com/services/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'
  - name: 'jenkins-go-demo_main-up'
    webhook_configs:
      - send_resolved: false
        url: 'http://$(docker-machine ip swarm-1)/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=1'
" | docker secret create alert_manager_config -

DOMAIN=$CLUSTER_DNS docker stack deploy \
    -c stacks/docker-flow-monitor-slack.yml monitor

docker stack ps -f desired-state=running monitor

cat stacks/go-demo-instrument-alert.yml

docker stack deploy -c stacks/go-demo-instrument-alert.yml go-demo

open "http://$CLUSTER_DNS/monitor/alerts"

for i in {1..30}; do
    DELAY=$[ $RANDOM % 6000 ]
    curl "http://$CLUSTER_DNS/demo/hello?delay=$DELAY"
done

open "http://$CLUSTER_DNS/monitor/alerts"

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/service-scale/activity"

docker stack ps -f desired-state=running go-demo

docker stack rm monitor

docker secret rm alert_manager_config

echo "route:
  group_by: [service,scale]
  repeat_interval: 5m
  group_interval: 5m
  receiver: 'slack'
  routes:
  - match:
      service: 'go-demo_main'
      scale: 'up'
    receiver: 'jenkins-go-demo_main-up'
  - match:
      service: 'go-demo_main'
      scale: 'down'
    receiver: 'jenkins-go-demo_main-down'

receivers:
  - name: 'slack'
    slack_configs:
      - send_resolved: true
        title: '[{{ .Status | toUpper }}] {{ .GroupLabels.service }} service is in danger!'
        title_link: 'http://$(docker-machine ip swarm-1)/monitor/alerts'
        text: '{{ .CommonAnnotations.summary}}'
        api_url: 'https://hooks.slack.com/services/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'
  - name: 'jenkins-go-demo_main-up'
    webhook_configs:
      - send_resolved: false
        url: 'http://$(docker-machine ip swarm-1)/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=1'
  - name: 'jenkins-go-demo_main-down'
    webhook_configs:
      - send_resolved: false
        url: 'http://$(docker-machine ip swarm-1)/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=-1'
" | docker secret create alert_manager_config -

DOMAIN=$CLUSTER_DNS docker stack deploy \
    -c stacks/docker-flow-monitor-slack.yml monitor

cat stacks/go-demo-instrument-alert-short.yml

docker stack deploy -c stacks/go-demo-instrument-alert-short.yml \
    go-demo

open "http://$CLUSTER_DNS/monitor/alerts"

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/service-scale/activity"

docker stack ps -f desired-state=running go-demo

cat stacks/go-demo-instrument-alert-short-2.yml

docker stack deploy -c stacks/go-demo-instrument-alert-short-2.yml \
    go-demo

open "http://$CLUSTER_DNS/monitor/alerts"

for i in {1..100}; do
    curl "http://$CLUSTER_DNS/demo/random-error"
done

open "http://$CLUSTER_DNS/monitor/alerts"

open "https://devops20.slack.com/messages/C59EWRE2K/"

###########################
# self-heal-infra-demo.md #
###########################

docker service create --name test \
    --replicas 10 alpine sleep 1000000

docker service ps test

exit

INSTANCE_ID=$(aws ec2 describe-instances \
    | jq -r ".Reservations[].Instances[] \
    | select(.SecurityGroups[].GroupName \
    | contains(\"devops22-ManagerVpcSG\")).InstanceId" | tail -n 1)

aws ec2 terminate-instances --instance-ids $INSTANCE_ID

aws ec2 describe-instances | jq -r ".Reservations[].Instances[] \
    | select(.SecurityGroups[].GroupName \
    | contains(\"devops22-ManagerVpcSG\")).State.Name"

CLUSTER_IP=$(aws ec2 describe-instances \
    | jq -r ".Reservations[].Instances[] \
    | select(.SecurityGroups[].GroupName \
    | contains(\"devops22-ManagerVpcSG\")).PublicIpAddress" \
    | tail -n 1)

ssh -i devops22.pem docker@$CLUSTER_IP

docker node ls

docker service ps test

docker service rm test

############################
# self-adapt-infra-demo.md #
############################

exit

aws autoscaling describe-auto-scaling-groups | jq "."

aws autoscaling describe-auto-scaling-groups \
    | jq -r ".AutoScalingGroups[] \
    | select(.AutoScalingGroupName \
    | startswith(\"$STACK_NAME-NodeAsg-\")).AutoScalingGroupName"

aws autoscaling describe-auto-scaling-groups \
    | jq -r ".AutoScalingGroups[] \
    | select(.AutoScalingGroupName \
    | startswith(\"$STACK_NAME-NodeAsg-\")).DesiredCapacity"

ASG_NAME=$(aws autoscaling describe-auto-scaling-groups \
    | jq -r ".AutoScalingGroups[] \
    | select(.AutoScalingGroupName \
    | startswith(\"$STACK_NAME-NodeAsg-\")).AutoScalingGroupName")

aws autoscaling update-auto-scaling-group \
    --auto-scaling-group-name $ASG_NAME --desired-capacity 1

aws autoscaling describe-auto-scaling-groups \
    --auto-scaling-group-names $ASG_NAME \
    | jq ".AutoScalingGroups[0].DesiredCapacity"

aws ec2 describe-instances | jq -r ".Reservations[].Instances[] \
    | select(.SecurityGroups[].GroupName \
    | startswith(\"$STACK_NAME-NodeVpcSG\")).InstanceId"

INSTANCE_ID=$(aws ec2 describe-instances | jq -r \
    ".Reservations[].Instances[] \
    | select(.SecurityGroups[].GroupName \
    | startswith(\"$STACK_NAME-NodeVpcSG\")).InstanceId")

aws ec2 describe-instance-status --instance-ids $INSTANCE_ID \
    | jq -r ".InstanceStatuses[0].InstanceStatus.Status"

ssh -i workshop.pem docker@$CLUSTER_IP

docker node ls

exit

aws autoscaling update-auto-scaling-group \
    --auto-scaling-group-name $ASG_NAME --desired-capacity 0

ssh -i workshop.pem docker@$CLUSTER_IP

docker node ls

exit

curl "https://raw.githubusercontent.com/vfarcic/docker-aws-cli/master/Dockerfile"

curl "https://raw.githubusercontent.com/vfarcic/docker-aws-cli/master/docker-compose.yml"

ssh -i workshop.pem docker@$CLUSTER_IP

curl -o jenkins.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/jenkins-aws-secret.yml

cat jenkins.yml

source creds

echo "
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION
export STACK_NAME=devops22
" | docker secret create aws -

docker stack deploy -c jenkins.yml jenkins

exit

open "http://$CLUSTER_DNS/jenkins/configure"

open "http://$CLUSTER_DNS/jenkins/view/all/newJob"

# Type *aws-scale* as the job name
# Select *Pipeline* as the job type
# Click the *OK* button
# Click the *Build Triggers* tab
# Select the *Trigger builds remotely* checkbox
# Type *DevOps22* as the *Authentication Token*
# Type the script that follows in the *Pipeline Script* field

# groovy

#pipeline {
#  agent {
#    label "prod"
#  }
#  options {
#    buildDiscarder(logRotator(numToKeepStr: '2'))
#    disableConcurrentBuilds()
#  }
#  parameters {
#    string(
#      name: "scale",
#      defaultValue: "1",
#      description: "The number of worker nodes to add or remove"
#    )
#  }
#  stages {
#    stage("scale") {
#      steps {
#        git "https://github.com/vfarcic/docker-aws-cli.git"
#        script {
#          def asgName = sh(
#            script: "source /run/secrets/aws && docker-compose run --rm asg-name",
#            returnStdout: true
#          ).trim()
#          if (asgName == "") {
#            error "Could not find auto-scaling group"
#          }
#          def asgDesiredCapacity = sh(
#            script: "source /run/secrets/aws && ASG_NAME=${asgName} docker-compose run --rm asg-desired-capacity",
#            returnStdout: true
#          ).trim().toInteger()
#          def asgNewCapacity = asgDesiredCapacity + scale.toInteger()
#          if (asgNewCapacity < 1) {
#            error "The number of worker nodes is already at the minimum capacity of 1"
#          } else if (asgNewCapacity > 3) {
#            error "The number of worker nodes is already at the maximum capacity of 3"
#          } else {
#            sh "source /run/secrets/aws && ASG_NAME=${asgName} ASG_DESIRED_CAPACITY=${asgNewCapacity} docker-compose run --rm asg-update-desired-capacity"
#            echo "Changed the number of worker nodes from ${asgDesiredCapacity} to ${asgNewCapacity}"
#          }
#        }
#      }
#    }
#  }
#  post {
#    success {
#      slackSend(
#        color: "good",
#        message: """Worker nodes were scaled.
#Please check Jenkins logs for the job ${env.JOB_NAME} #${env.BUILD_NUMBER}
#${env.BUILD_URL}console"""
#      )
#    }
#    failure {
#      slackSend(
#        color: "danger",
#        message: """Worker nodes could not be scaled.
#Please check Jenkins logs for the job ${env.JOB_NAME} #${env.BUILD_NUMBER}
#${env.BUILD_URL}console"""
#      )
#    }
#  }
#}

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/aws-scale/activity"

ssh -i $KEY_NAME.pem docker@$CLUSTER_IP

docker node ls

exit

curl -XPOST -i \
    "http://$CLUSTER_DNS/jenkins/job/aws-scale/buildWithParameters?token=DevOps22&scale=2"

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/aws-scale/activity"

ssh -i workshop.pem docker@$CLUSTER_IP

docker node ls

exit

curl -XPOST -i \
    "http://$CLUSTER_DNS/jenkins/job/aws-scale/buildWithParameters?token=DevOps22&scale=1"

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/aws-scale/activity"

curl -XPOST -i \
    "http://$CLUSTER_DNS/jenkins/job/aws-scale/buildWithParameters?token=DevOps22&scale=-2"

ssh -i workshop.pem docker@$CLUSTER_IP

docker node ls

exit

curl -XPOST -i \
    "http://$CLUSTER_DNS/jenkins/job/aws-scale/buildWithParameters?token=DevOps22&scale=-1"

open "http://$CLUSTER_DNS/monitor"

# (sum(node_memory_MemTotal) BY (instance) - sum(node_memory_MemFree + node_memory_Buffers + node_memory_Cached) BY (instance)) / sum(node_memory_MemTotal) BY (instance)

# sum(node_memory_MemTotal) - sum(node_memory_MemFree + node_memory_Buffers + node_memory_Cached)

# sum(node_memory_MemTotal)

# (sum(node_memory_MemTotal) - sum(node_memory_MemFree + node_memory_Buffers + node_memory_Cached)) / sum(node_memory_MemTotal)

ssh -i workshop.pem docker@$CLUSTER_IP

curl -o exporters.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/exporters-aws.yml

cat exporters.yml

docker stack rm exporter

docker stack deploy -c exporters.yml exporter

exit

open "http://$CLUSTER_DNS/monitor/alerts"

# (sum(node_memory_MemTotal{job="exporter_node-exporter-manager"}) - sum(node_memory_MemFree{job="exporter_node-exporter-manager"} + node_memory_Buffers{job="exporter_node-exporter-manager"} + node_memory_Cached{job="exporter_node-exporter-manager"})) / sum(node_memory_MemTotal{job="exporter_node-exporter-manager"}) > 0.8

ssh -i workshop.pem docker@$CLUSTER_IP

docker stack rm monitor

docker secret rm alert_manager_config

source creds

echo "route:
  group_by: [service,scale,type]
  repeat_interval: 30m
  group_interval: 30m
  receiver: 'slack'
  routes:
  - match:
      type: 'node'
      scale: 'up'
    receiver: 'jenkins-node-up'
  - match:
      type: 'node'
      scale: 'down'
    receiver: 'jenkins-node-down'
  - match:
      service: 'go-demo_main'
      scale: 'up'
    receiver: 'jenkins-go-demo_main-up'
  - match:
      service: 'go-demo_main'
      scale: 'down'
    receiver: 'jenkins-go-demo_main-down'

receivers:
  - name: 'slack'
    slack_configs:
      - send_resolved: true
        title: '[{{ .Status | toUpper }}] {{ .GroupLabels.service }} service is in danger!'
        title_link: 'http://$CLUSTER_DNS/monitor/alerts'
        text: '{{ .CommonAnnotations.summary}}'
        api_url: 'https://hooks.slack.com/services/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'
  - name: 'jenkins-go-demo_main-up'
    webhook_configs:
      - send_resolved: false
        url: 'http://$CLUSTER_DNS/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=1'
  - name: 'jenkins-go-demo_main-down'
    webhook_configs:
      - send_resolved: false
        url: 'http://$CLUSTER_DNS/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=-1'
  - name: 'jenkins-node-up'
    webhook_configs:
      - send_resolved: false
        url: 'http://$CLUSTER_DNS/jenkins/job/aws-scale/buildWithParameters?token=DevOps22&scale=1'
  - name: 'jenkins-node-down'
    webhook_configs:
      - send_resolved: false
        url: 'http://$CLUSTER_DNS/jenkins/job/aws-scale/buildWithParameters?token=DevOps22&scale=-1'
" | docker secret create alert_manager_config -

DOMAIN=$CLUSTER_DNS docker stack deploy -c monitor.yml monitor

docker stack ps -f desired-state=running monitor

docker service update \
    --label-add "com.df.alertIf.2=@node_mem_limit_total_above:0.1" \
    exporter_node-exporter-manager

exit

open "http://$CLUSTER_DNS/monitor/alerts"

ssh -i workshop.pem docker@$CLUSTER_IP

docker service update \
    --label-add "com.df.alertIf.2=@node_mem_limit_total_above:0.8" \
    exporter_node-exporter-manager

docker service update \
    --label-add "com.df.alertIf.2=@node_mem_limit_total_above:0.1" \
    exporter_node-exporter-worker

exit

open "http://$CLUSTER_DNS/monitor/alerts"

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/aws-scale/activity"

ssh -i workshop.pem docker@$CLUSTER_IP

docker node ls

docker service update \
    --label-add "com.df.alertIf.2=@node_mem_limit_total_above:0.8" \
    exporter_node-exporter-worker

docker service update \
    --label-add "com.df.alertIf.3=@node_mem_limit_total_below:0.9" \
    exporter_node-exporter-worker

exit

open "http://$CLUSTER_DNS/monitor/alerts"

ssh -i workshop.pem docker@$CLUSTER_IP

docker node ls

docker service update \
    --label-add "com.df.alertIf.3=@node_mem_limit_total_below:0.05" \
    exporter_node-exporter-worker

exit

##################
# cleanup-aws.md #
##################

exit

aws cloudformation delete-stack --stack-name devops22

aws cloudformation describe-stacks --stack-name devops22 | \
  jq -r ".Stacks[0].StackStatus"
