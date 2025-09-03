# Policy Enforcement


[user]
```md
Create a database in Azure
```

[agent]
```md
I need more details to provide the best database solution for Azure.
Database Type & Technology:
- What database engine do you need (MySQL, PostgreSQL, SQL Server, ...
- Do you have a specific version requirement?
Deployment Approach:
- Do you want to use managed Azure Database services (like Azure ...
- Are you planning to deploy this in Azure Kubernetes Service (AKS)?
Requirements:
- What are your expected performance requirements (concurrent ...
- Do you need high availability with automatic failover?
- Is this for development, staging, or production?
Security & Compliance:
...

Could you provide details on these points so I can recommend the most
suitable database solution for your needs?
```


[user]
```md
Publicly accessible PostgreSQL
```

[agent]
```md
I found 3 solutions for creating a publicly accessible PostgreSQL ...

Option 1: Multi-cloud PostgreSQL (Score: 98)
Resources: SQL (devopstoolkit.live/v1beta1)
- Multi-cloud abstraction with Azure support
- Built-in secret management and schema handling
- Simplified configuration
- Uses organizational pattern for PostgreSQL deployment

Option 2: Azure PostgreSQL Flexible Server (Score: 95)

Resources: ResourceGroup, FlexibleServer, FlexibleServerFirewallRule, ...
...
Option 3: Traditional Azure PostgreSQL Server (Score: 92)
...
Which solution would you like me to configure and deploy?
```


[user]
```md
1
```

[agent]
```md
Great choice! Now I need some basic configuration details for your ...

Required Configuration:

1. Database name: What should we name your PostgreSQL database? (must ...
2. Namespace: Which namespace should it be deployed to? - Options: ...
3. Database size: What size do you need? - Options: small, medium, large
4. Cloud provider composition: Since you want Azure, this should be ...
5. Region: Which Azure region? - Options: eastus, us-east-1, us-east1 ...

Please provide these details so I can configure your database solution.
```


[user]
```md
1. my-db, 2. a-team; 3. small, 4. azure-postgresql, 5. eastus
```

[agent]
```md
Perfect! Now let's configure the basic settings for your PostgreSQL database:

Basic Configuration (optional - you can skip this stage):

1. Databases to create: What databases should be created in your ...
2. PostgreSQL version: Which version would you like? - Options: 15, 14, ...
3. Secret store name: What should we name the secret store for database ...
4. Push credentials to store: Should database credentials be ...

You can provide specific answers for these settings or just say "skip" to
proceed to advanced configuration.
```


[user]
```md
1. db-01, db-02; 2. 15; 4. false
```

[agent]
```md
Great! Now let's configure the advanced settings for your PostgreSQL ...

Advanced Configuration (optional - you can skip this stage):

1. Custom SQL schemas: Do you need to run custom SQL schemas on specific ...
2. Root password key: What key should be used when pulling the root ...
3. Pull to cluster: Should credentials be pulled to a specific cluster?
4. Credential namespace: Which namespace should receive the pulled ...
5. Composition update policy: How should composition updates be handled? ...
6. Network address: Do you need to specify a custom network address for ...
7. Resource labels: Do you want to add custom labels to the database ...

You can provide specific answers for any of these settings or just say "skip"
to proceed to the final open configuration stage.
```


[user]
```md
1. Write a simple sample schema for me.
```

[agent]
```md
Would you like to configure any of the remaining advanced settings:

2. Root password key (default: root-password)
3. Pull to cluster (leave empty for default)
4. Credential namespace (default: default)
5. Composition update policy (default: Manual)
6. Network address (leave empty for automatic)
7. Resource labels (format: key1=value1,key2=value2)

Or say "skip" to proceed to the final open configuration stage.
```


[user]
```md
skip
```

[agent]
```md
Great! Now for the final open configuration stage:

Any Additional Requirements?

Is there anything else about your PostgreSQL database requirements or ...

Examples:
- Specific performance requirements
- Backup needs
- Connection limits
- Security constraints
- Integration with existing applications

You can provide additional details or just say "N/A" if you have no ...
```


[user]
```md
N/A
```

[agent]
```md
Perfect! I've generated the Kubernetes manifests for your Azure ...

- Database name: my-db
- Namespace: a-team
- Size: small
- PostgreSQL version: 15
- Region: eastus (Azure)
- Databases: db-01, db-02
- Sample schema: users and posts tables

Now I'll deploy it to your Azure Kubernetes cluster:
...
```


[user]
```md
Tool use                                                           
                                                                  
dot-ai - deployManifests(solutionId: "sol_2025-09-02T131741_1e3c6f4d5c94")
(MCP) Deploy Kubernetes manifests from generated solution with
kubectl apply --wait                                             
                                                                  
Do you want to proceed?                                            
> 1. Yes
  2. Yes, and don't ask again for dot-ai - deployManifests commands in ...
  3. No, and tell Claude what to do differently (esc)              
```

[agent]
```md
Your publicly accessible PostgreSQL database has been created with:
- Name: my-db
- Namespace: a-team
- Azure region: eastus
- PostgreSQL version: 15
- Databases: db-01, db-02
- Sample schema with users and posts tables

The deployment is complete and all components are ready. Your database ...
```


[user]
```md
Take the manifest we generated earlier with the MCP, change the region to
`westus`, and save it to `k8s/db.yaml`.
```

[agent]
```md
Done! I've saved the manifest to k8s/db.yaml with the region changed from
eastus to westus. The file contains the same PostgreSQL configuration as
before but now targets the West US Azure region.
```


[user]
```md
Apply the manifest `k8s/db.yaml` without using the MCP.
```

[agent]
```md
The deployment was blocked by a Kyverno policy that requires databases to use
specific regions. The policy only allows:
- us-east1 for GCP
- us-east-1 for AWS
- eastus for Azure

Since you want to use westus, but the policy requires eastus for Azure, the
manifest was rejected. You'll need to either:

1. Change the region back to eastus in the manifest
2. Update the Kyverno policy to allow westus

Would you like me to change the region back to eastus or help you modify the
policy?
```
