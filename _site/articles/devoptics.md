* Value stream > Each phase is a job?
* CD is typically not archived by **a single job or pipeline** > Single pipeline per product/microservice. From the DORA report: "Loosely coupled architectures and teams are the strongest predictor of continuous delivery.", "High performers: Deployment frequency - On demand (multiple deploys per day)", 
* Insights into **server workloads** > Prometheus
* **Number of runs waiting to start** > CJE
* **Lenght of build request queues** > CJE
* Run completion status - successful, **failed**, etc > Fix the failed build immediatelly
* Optimal time for maintenance/upgrades > Rolling updates in k8s (except Jenkins)
* Expose **infrastructure inefficiencies** > How?
* Allow automation constraints to be uncovered and removed > How?
* When a build succeeds that includes an **artifact from a preceding gate**, tickets from the preceding gate move to the successful gate > Which types of artifact are tracked? Container images? Documentation states that, in case of pipelines, only those with `archiveArtifacts` are used. `devOpticsConsumes` sounds like too much coupling.
* https://go.cloudbees.com/docs/cloudbees-documentation/devoptics-user-guide/value_streams/#devoptics-value-stream > Uses old pipeline views. Why?