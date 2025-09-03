# AI Policy Extraction


[user]
```md
Create a policy
```

[agent]
```md
Please describe the policy intent you want to create. What should this
policy enforce or ensure in your Kubernetes deployments?

  Examples:
  - "All containers must have resource limits defined"
  - "Images must be from trusted registries only"
  - "Pods must not run as root user"
  - "All services must have network policies"

  What policy requirement do you want to enforce?
```


[user]
```md
Databases in Google Cloud (GCP) should always run in the us-east1 region,
those in Azure should always run in the eastus region, and those in AWS
should run in the us-east-1 region.
```

[agent]
```md
What types of infrastructure should this apply to? Think about the
categories of resources and systems this covers, not technical
implementation details.

Examples by domain:
- Applications: web applications, microservices, APIs, frontends, backends
- Databases: databases, SQL databases, NoSQL, data stores, persistent storage
- Networking: load balancers, ingresses, services, network policies, DNS
- Storage: persistent volumes, storage classes, backup systems
- Security: secrets, certificates, authentication, authorization, RBAC
- Infrastructure: clusters, nodes, compute resources, cloud resources

  Please provide infrastructure type keywords separated by commas
  (avoid field names like 'image', 'tag', or specific values like
  'latest').
```


[user]
```md
GCP DB, Google DB, AWS DB, Azure DB
```

[agent]
```md
Here's a complete list of infrastructure types for your database region
policy:

GCP DB, Google DB, AWS DB, Azure DB, Cloud SQL, RDS, Cosmos DB, database
instances, data stores, SQL databases, NoSQL databases, managed databases,
database services, persistent storage, data warehouses, BigQuery, Redshift,
Azure SQL, DynamoDB, Firestore, Cloud Spanner, DocumentDB, database
clusters, replica sets

Please select which ones you want to keep for this policy (you can choose
any combination or add your own custom triggers). Return your final selection
as a comma-separated list.
```


[user]
```md
All of those
```

[agent]
```md
Why is this policy important for your organization? Please explain the
rationale behind this policy requirement - what risks does it mitigate or
what benefits does it provide?
```


[user]
```md
> Write it for me
```

[agent]
```md
dot-ai - manageOrgData(... response: "This policy ensures consistent
regional deployment of database resources across cloud providers to optimize
performance, reduce latency, maintain regulatory compliance, and standardize
infrastructure operations. It mitigates risks of increased latency from
cross-region traffic, potential regulatory violations, and operational
complexity from scattered resources.") (MCP)         
                                                                
Do you want to proceed?                                            
> 1. Yes
  2. Yes, and don't ask again for dot-ai - manageOrgData commands in ...
  3. No, and tell Claude what to do differently (esc)
```

[agent]
```md
Who should be credited as the creator of this policy intent?
  (This can be your name, team name, or organization.)
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

1. Apply to all namespaces (cluster-wide enforcement) - Type: all or 1
2. Apply only to specific namespaces (inclusive list) - Type: include: ...
3. Apply to all namespaces EXCEPT specific ones (exclusion list) - Type: ...
```


[user]
```md
Include a-team and b-team Namespaces
```

[agent]
```md
Please review your policy intent:

Description: Databases in Google Cloud (GCP) should always run in...
Triggers: GCP DB, Google DB, AWS DB, Azure DB, Cloud SQL, RDS, Cosmos ...
Rationale: This policy ensures consistent regional deployment of ...

I've also generated a Kyverno ClusterPolicy that enforces this requirement:
...
```


[agent]
```yaml
# MANDATORY SCHEMA-BY-SCHEMA ANALYSIS
#
# databaseinstances.sql.gcp.m.upbound.io: HAS spec.forProvider.region + ...
# databases.sql.gcp.m.upbound.io: NO region field > Can skip ...
# users.sql.gcp.m.upbound.io: NO region field > Can skip ...
# sslcerts.sql.gcp.m.upbound.io: NO region field > Can skip ...
# clusterinstances.rds.aws.m.upbound.io: HAS spec.forProvider.region + ...
# instances.rds.aws.m.upbound.io: HAS spec.forProvider.region +
# sqls.devopstoolkit.live: HAS spec.region + multi-cloud > MUST ...
# manageddatabaselogicaldatabases.database.upcloud.com: NO region field ...
# servers.dbforpostgresql.azure.m.upbound.io: HAS ...
...
```


[agent]
```yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-database-regional-compliance
  ...
spec:
  ...
      - resources:
          kinds:
          - sql.gcp.m.upbound.io/v1beta1/DatabaseInstance
          namespaces:
          - a-team
          - b-team
          operations:
          - CREATE
          ...
```


[agent]
```yaml
    validate:
      cel:
        expressions:
        - expression: >-
            !has(object.spec.forProvider.region) ||
            object.spec.forProvider.region == 'us-east1'
          message: "GCP database instances must be deployed in
the us-east1 region for compliance"
        - expression: >-
            !has(object.spec.initProvider.region) ||
            object.spec.initProvider.region == 'us-east1'
          message: "GCP database instances must be deployed in the ..."
```


[agent]
```yaml
  ...
          kinds:
          - rds.aws.m.upbound.io/v1beta1/GlobalCluster
          ...
          kinds:
          - devopstoolkit.live/v1beta1/SQL
          ...
          kinds:
          - dbforpostgresql.azure.m.upbound.io/v1beta1/Server
          ...
          kinds:
          - rds.aws.m.upbound.io/v1beta1/OptionGroup
          ...
          kinds:
          - rds.aws.m.upbound.io/v1beta1/ParameterGroup
          ...
```


[agent]
```md
Choose what to do:

1. Apply Kyverno policy to cluster - Store policy intent AND deploy
enforcement to cluster
2. Store policy intent only - Save for AI guidance without cluster
enforcement
3. Cancel - Do nothing

Warning: Option 1 will deploy active policy enforcement to your cluster.
```


[user]
```md
1
```

[agent]
```md
Policy Applied to Cluster Successfully!

Policy ID: 2e02e3a8-0d74-495a-b319-2eb8bb0defba
Description: Databases in Google Cloud (GCP) should always run in the ...
Deployed Policy: policy-2e02e3a8-0d74-495a-b319-2eb8bb0defba

The policy intent has been stored in the database and the Kyverno policy has
been applied to your cluster. The policy is now actively enforcing database
regional compliance for the a-team and b-team namespaces.

Apply output:
clusterpolicy.kyverno.io/require-database-regional-compliance created
```


[user]
```md
List policies
```

[agent]
```md
Found 3 policy intents:

1. Database Regional Compliance (ID: 2e02e3a8-0d74-495a-b319-2eb8bb0defba)
  - Description: Databases in Google Cloud (GCP) should always run in ...
  - Status: Deployed (policy-2e02e3a8-0d74-495a-b319-2eb8bb0defba)
2. No Latest Tag (ID: 7a95808e-1829-4084-b06f-0ef538fd48eb)
  - Description: Applications must NEVER use the latest tag.
  - Status: Deployed (policy-7a95808e-1829-4084-b06f-0ef538fd48eb)
3. SQL Composition Reference (ID: ef434183-7872-4d32-bf1f-dc1c3c270f21)
  - Description: sqls.devopstoolkit.live must have ...
  - Status: Deployed (policy-ef434183-7872-4d32-bf1f-dc1c3c270f21)

All policies are currently deployed and active in your cluster.
```