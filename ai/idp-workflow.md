# Workflows
## (Demo)


[user]
```md
Create a PostgreSQL database in AWS.
```

[agent]
```md
I'll help you create a PostgreSQL database in AWS using Kubernetes. Let me
use the dot-ai recommendation tool to get the best approach for deploying
PostgreSQL.
...
I can help you create a PostgreSQL database in AWS! To provide the best
recommendations, I need to clarify a few key details about your requirements:

Primary Questions:
1. Deployment Type: Are you looking for a managed AWS service like RDS?
2. Environment: What environment is this for - development, staging, ...
3. Performance: What are your expected performance requirements ...
4. Availability: Do you need high availability with automatic failover, ...

Additional Considerations:
...
Could you provide details on these key points so I can give you the most
appropriate solution for your PostgreSQL database setup in AWS?
```


[user]
```md
It should be managed PostgreSQL DB in AWS (RDS), there should be DB schema
management, and it should be publicly accessible.
```

[agent]
```md
I found 4 solutions for creating a managed PostgreSQL RDS database in AWS
with schema management and public accessibility. Here are your options:

Solution Options:

1. DevOps Toolkit Managed PostgreSQL (Score: 95) Uses Organizational Patterns
- Resources: SQLS (devopstoolkit.live/v1beta1)
- Benefits: Complete PostgreSQL solution with built-in schema management, ...
- Pattern Used: DevOps Toolkit DB pattern for simplified database deployments

2. AWS RDS with Crossplane Schema Management (Score: 90) Uses Organizational
Patterns
- Resources: RDS Instance, Schema, ProviderConfig, InternetGateway
- Benefits: Direct AWS RDS control with dedicated schema management and ...
- Pattern Used: AWS public services pattern
...
```


[user]
```md
1
```

[agent]
```md
Perfect! I've selected the DevOps Toolkit Managed PostgreSQL solution. Now
I need some required configuration details:

Required Configuration:

1. Database Name: What name would you like for your PostgreSQL database? ...
2. Namespace: Which namespace should the database be deployed to? ...
3. Size: What size database do you need? Options: small, medium, large
4. Region: Policy requirement: Databases in AWS should run in us-east-1
region.

Please provide your choices for these required settings.
```


[user]
```md
1. my-db, 2. a-team, 3. small, 4. us-east-1
```

[agent]
```md
Great! Now for the basic configuration options:

Basic Configuration (Optional):

1. Databases: Which databases should be created in your PostgreSQL instance?
  - Options: app, users, inventory, analytics, logs
  - You can select multiple databases
2. PostgreSQL Version: Which version would you prefer?
  - Options: 15 (recommended), 14, 13, 12
3. Secret Management: Do you want to enable automated secret management ...
  - Recommended for production environments

You can provide your choices for these settings, or say "skip" to proceed to
advanced configuration.
```


[user]
```md
1. db-01, db-02; 2. 15; 3. No
```

[agent]
```md
Perfect! Now for the advanced configuration options:

Advanced Configuration (Optional):

1. Crossplane Composition: Do you want to use a specific composition for your
database? Leave empty for default composition
2. Composition Updates: How should composition updates be handled?
Options: Automatic, Manual
3. External Secret Store: Which external secret store should be used for
credential management? e.g., vault-store, aws-secrets-manager
4. Secret Pull Cluster: Should secrets be pulled to a specific cluster?
5. Secret Pull Namespace: Which namespace should receive the pulled secrets?
Options: a-team, atlas-operator, b-team, etc.
6. Schema Definitions: Do you have specific SQL schemas to initialize with
your databases?

You can provide your choices for these settings, or say "skip" to proceed
```


[user]
```md
6. Write a sample schema for me.
```

[agent]
```md
Now, would you like to configure the remaining advanced settings, or say
"skip" to proceed to the final open configuration stage?

Remaining Advanced Options:
1. Crossplane composition (leave empty for default)
2. Composition updates (Automatic/Manual)
3. External secret store
4. Secret pull cluster
5. Secret pull namespace
```


[user]
```md
skip
```

[agent]
```md
Final Configuration Stage - Open Requirements:

Is there anything else about your PostgreSQL requirements or constraints that
would help us provide better recommendations?

Examples:
- Specific performance requirements
- Backup needs
- Network security constraints
- Compliance requirements
- Connection limits
- Monitoring preferences

You can provide any additional requirements, or say "N/A" if you have no
additional requirements to proceed with generating the manifests.
```


[user]
```md
N/A
```

[agent]
```md
Excellent! Your PostgreSQL database manifests have been generated
successfully. Here's what was created:

Generated Resources:

Primary Resource: SQL Database

- Name: my-db
- Namespace: a-team
- Type: DevOps Toolkit SQL resource
- Size: small
- Region: us-east-1
- PostgreSQL Version: 15
...


[agnnt]
```md
Database Configuration:

- Databases: db-01, db-02
- Schema Management: Built-in with sample schemas
- Secret Management: Disabled (as requested)
- Public Accessibility: Enabled

Sample Schemas Included:

- db-01: app schema with users and products tables
- db-02: analytics schema with events table

The manifests are ready for deployment. Would you like me to
deploy them to your cluster now, or would you prefer to review
them first?

To deploy, I can run: kubectl apply with the generated manifests.
```


[user]
```md
Deploy them
```

[agent]
```md
Deployment Successful!

Your PostgreSQL database has been deployed successfully to the a-team
namespace. Here's what was created:

Deployed Resources:
...
Database Details:
...

The database is now provisioning in AWS. You can monitor its status with:
`kubectl get sql my-db -n a-team`

The DevOps Toolkit will handle the AWS RDS provisioning, schema creation,
and make the database publicly accessible as requested.
```
