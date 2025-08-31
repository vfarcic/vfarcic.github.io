# Policies
## (Demo)


[user]
```md
List policies
```

[agent]
```md
Here are the available policy intents:

ID: 65c8d83d-f377-4664-b55c-89566a225784
- Description: Databases in Azure should always run in the us-east1 region
- Triggers: db, postgresql, azure, databases, data store, sql database, ...
- Rationale: Ensures data residency compliance and reduces latency for ...
- Deployed Policy: policy-65c8d83d-f377-4664-b55c-89566a225784 (applied...

ID: 7a95808e-1829-4084-b06f-0ef538fd48eb
- Description: Applications must NEVER use the latest tag.
- Triggers: app, application, applications, app deployment, application ...
- Rationale: Using the 'latest' tag creates unpredictable deployments and ...
- Deployed Policy: policy-7a95808e-1829-4084-b06f-0ef538fd48eb (applied...

Total: 2 policy intents found
```


[user]
```md
Create a policy
```

[agent]
```md
Please describe the policy intent you want to create. What should this policy
enforce or ensure in your Kubernetes deployments?

Examples:
- "All containers must have resource limits defined"
- "Images must be from trusted registries only"
- "Pods must not run as root user"
- "All services must have network policies"

What policy requirement do you want to enforce?
```


[user]
```md
Databases in AWS should always run in the us-east-1 region
```

[agent]
```md
What types of infrastructure should this apply to? Think about the categories
of resources and systems this covers, not technical implementation details.

Examples by domain:
- Applications: web applications, microservices, APIs, frontends, backends
- Databases: databases, SQL databases, NoSQL, data stores, persistent storage
- Networking: load balancers, ingresses, services, network policies, DNS
- Storage: persistent volumes, storage classes, backup systems
- Security: secrets, certificates, authentication, authorization, RBAC
- Infrastructure: clusters, nodes, compute resources, cloud resources

Please provide infrastructure type keywords separated by commas (avoid field
names like 'image', 'tag', or specific values like 'latest').
```


[user]
```md
AWS DB
```

[agent]
```md
Here's the expanded list of infrastructure types for your "AWS databases"
policy:

AWS DB, RDS, database, databases, data store, SQL database, NoSQL database,
Aurora, DynamoDB, ElastiCache, DocumentDB, Neptune, Redshift, persistent
storage, data warehouse, cache, in-memory database, graph database, time
series database, backup systems, database clusters, read replicas

Please select which ones you want to keep for your policy triggers. You can:
- Choose any combination from the list above
- Add your own custom triggers
- Keep them all

What triggers would you like for this policy?
```


[user]
```md
All of those
```

[agent]
```md
Why is this policy important for your organization? Please explain the
rationale behind this policy requirement - what risks does it mitigate
or what benefits does it provide?
```


[user]
```md
Write it for me
```

[agent]
```md
Tool use                                                            
                                                                    
dot-ai - manageOrgData(dataType: "policy", operation: "create", sessionId:
"policy-1756582341290-78820a05", step: "created-by", response: "Ensures data
residency compliance and reduces latency for US-based applications. Running
AWS databases in us-east-1 provides optimal performance for primary
workloads, meets regulatory requirements for data locality, and maintains
consistency with existing infrastructure deployments. This policy helps
control costs by keeping data within the same region as compute resources and
simplifies disaster recovery planning.") (MCP)

Do you want to proceed?
> 1. Yes
  2. Yes, and don't ask again for dot-ai - manageOrgData commands in
  /Users/viktorfarcic/code/dot-ai-demo
  3. No, and tell Claude what to do differently (esc)
```


[agent]
```md
Who should be credited as the creator of this policy intent? (This can be
your name, team name, or organization.)
```


[user]
```md
a-team
```

[agent]
```md
Policy Namespace Scope

Your policy can be applied cluster-wide or limited to specific namespaces.

Available Namespaces in Your Cluster:

a-team, atlas-operator, b-team, crossplane-system, default, ingress-nginx,
kube-node-lease, kube-public, kube-system, kyverno, local-path-storage

Choose the scope for your policy:

1. Apply to all namespaces (cluster-wide enforcement)
2. Apply only to specific namespaces (inclusive list)
3. Apply to all namespaces EXCEPT specific ones (exclusion list)

Your choice: [Type your selection]
```


[user]
```md
2. a-team, b-team
```

[agent]
```md
Please review your policy intent:

Description: Databases in AWS should always run in the us-east-1 region
Triggers: AWS DB, RDS, database, databases, data store, SQL database, ...
Rationale: Ensures data residency compliance and reduces latency for ...
Created By: a-team

I've also generated a Kyverno ClusterPolicy that enforces this requirement:
...
```


[agent]
```md
...
  apiVersion: kyverno.io/v1
  kind: ClusterPolicy
  metadata:
    ...
  spec:
    background: false
    validationFailureAction: Enforce
    rules:
    - name: require-aws-rds-resources-us-east-1
      match:
        any:
        - resources:
            kinds:
            - rds.aws.m.upbound.io/v1beta1/Cluster
            - rds.aws.m.upbound.io/v1beta1/GlobalCluster
            ...
```


[agent]
```md
Choose what to do:

1. Apply Kyverno policy to cluster - Store policy intent AND eploy
enforcement to cluster
2. Store policy intent only - Save for AI guidance without cluster enforcement
3. Cancel - Do nothing

Warning: Option 1 will deploy active policy enforcement to your cluster.
```


[user]
```md
> Show complete Kyverno policy
```

[agent]
```md
Here's the complete Kyverno policy YAML:

# MANDATORY SCHEMA-BY-SCHEMA ANALYSIS
#
# clusters.rds.aws.m.upbound.io: HAS spec.forProvider.region - MUST generate rule
# globalclusters.rds.aws.m.upbound.io: HAS spec.forProvider.region - MUST generate rule
# instances.rds.aws.m.upbound.io: HAS spec.forProvider.region - MUST generate rule
# clusterinstances.rds.aws.m.upbound.io: HAS spec.forProvider.region - MUST generate rule
# dbsnapshotcopies.rds.aws.m.upbound.io: HAS spec.forProvider.region - MUST generate rule
# clustersnapshots.rds.aws.m.upbound.io: HAS spec.forProvider.region - MUST generate rule
# dbinstanceautomatedbackupsreplications.rds.aws.m.upbound.io: HAS spec.forProvider.region - MUST generate rule
# optiongroups.rds.aws.m.upbound.io: HAS spec.forProvider.region - MUST generate rule
# parametergroups.rds.aws.m.upbound.io: HAS spec.forProvider.region - MUST generate rule
# snapshots.rds.aws.m.upbound.io: HAS spec.forProvider.region - MUST generate rule
# clusterparametergroups.rds.aws.m.upbound.io: HAS spec.forProvider.region - MUST generate rule
...
```


[agent]
```md
...
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-aws-databases-us-east-1-region
  ...
spec:
  background: false
  validationFailureAction: Enforce
  rules:
  - name: require-aws-rds-resources-us-east-1
    match:
      any:
      - resources:
...
```


[agent]
```md
...
          kinds:
          - rds.aws.m.upbound.io/v1beta1/Cluster
          - rds.aws.m.upbound.io/v1beta1/GlobalCluster
          - rds.aws.m.upbound.io/v1beta1/Instance
          - rds.aws.m.upbound.io/v1beta1/ClusterInstance
          - rds.aws.m.upbound.io/v1beta1/DBSnapshotCopy
          - rds.aws.m.upbound.io/v1beta1/ClusterSnapshot
          - rds.aws.m.upbound.io/v1beta1/DBInstanceAutomatedBackups...
          - rds.aws.m.upbound.io/v1beta1/OptionGroup
          - rds.aws.m.upbound.io/v1beta1/ParameterGroup
          - rds.aws.m.upbound.io/v1beta1/Snapshot
          - rds.aws.m.upbound.io/v1beta1/ClusterParameterGroup
          - rds.aws.m.upbound.io/v1beta1/ClusterEndpoint
          - rds.aws.m.upbound.io/v1beta1/SubnetGroup
          - rds.aws.m.upbound.io/v1beta1/InstanceState
...
```


[agent]
```md
...
    validate:
      cel:
        expressions:
        - expression: >-
            has(object.spec.forProvider.region) &&
object.spec.forProvider.region == 'us-east-1'
          message: "AWS RDS resources must be deployed in the us-east-1 ...
        - expression: >-
            has(object.spec.initProvider.region) ?
object.spec.initProvider.region == 'us-east-1' : true
          message: "AWS RDS resources must be deployed in the us-east-1 ...
...
```


[agent]
```md
...
Choose what to do:

1. Apply Kyverno policy to cluster - Store policy intent AND deploy
enforcement to cluster
2. Store policy intent only - Save for AI guidance without cluster enforcement
3. Cancel - Do nothing

Warning: Option 1 will deploy active policy enforcement to your cluster.
```

* If something is wrong and we got only, let's say, 80% of the Kyverno policy, that still very helpful. We can save it, update it ourselves or with an agent, and then apply it.


[user]
```md
Apply Kyverno policy to cluster
```

[agent]
```md
Policy Applied to Cluster Successfully!

Policy ID: 62cb97c8-e75a-4ec0-bec8-404dfbebf4e2
Description: Databases in AWS should always run in the us-east-1 region
Deployed Policy: policy-62cb97c8-e75a-4ec0-bec8-404dfbebf4e2
Kyverno File: /app/tmp/sessions/policy-sessions/62cb97c8-e75a-4ec0-bec8-...

Apply Output:
clusterpolicy.kyverno.io/require-aws-databases-us-east-1-region created

The policy intent has been stored in the database and the Kyverno policy has
been successfully applied to your cluster. This policy will now enforce that
all AWS database resources in the a-team and b-team namespaces must be
deployed in the us-east-1 region.
```