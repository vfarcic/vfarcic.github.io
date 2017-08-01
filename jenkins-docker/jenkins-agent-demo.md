## Hands-On Time

---

# Jenkins Agent Services


## Creating a Testing Cluster

---

* Open [Docker Community Edition for AWS](https://store.docker.com/editions/community/docker-ce-aws)
* Click the `Get Docker` button
* Click the `Next` button
* Type `do-not-test-in-production` as the `Stack name`
* Change the `Number of Swarm worker nodes` to `0`
* Select `workshop` as your SSH key in `Which SSH key to use`
* Select `yes` as `Enable daily resource cleanup`
* Select `no` as `Use Cloudwatch for container logging`


## Creating a Testing Cluster

---

* Select `yes` as `Create EFS prerequsities for CloudStor`
* Choose `t2.small` as `Swarm manager instance type`
* Click the `Next` button
* Click the `Next` button
* Select `I acknowledge that AWS CloudFormation might create IAM resources`
* Click the `Create button`


## Entering The Cluster

---

* Click the `Output` tab in CloudFormation Stacks screen
* Copy `DefaultDNSTarget`

```bash
TEST_CLUSTER_DNS=[...]
```

* Click the link next to *Managers*
* Select any of the nodes
* Copy of `IPv4 Public IP` IP

```bash
TEST_CLUSTER_IP=[...]

ssh -i workshop.pem docker@$TEST_CLUSTER_IP

docker node ls
```


## Running Jenkins Agents

---

```bash
curl -o jenkins.yml https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/jenkins/vfarcic-jenkins-agent.yml

echo "admin" | docker secret create jenkins-user -

echo "admin" | docker secret create jenkins-pass -

export JENKINS_URL=[...]

LABEL=test docker stack deploy -c jenkins.yml jenkins
```

TODO: Continue

