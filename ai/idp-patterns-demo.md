# Patterns
## (Demo)


[user]
```md
List patterns
```

[agent]
```md
Here are the available organizational patterns:

  ID: 9cdb8e4f-afa9-414f-a1c0-196b2bd894c5
  - Description: DevOps Toolkit DB
  - Triggers: 11
  - Resources: 1
  - Created: 2025-08-25T23:39:03.636Z
  - Created By: a-team

  ID: dedcafc2-f488-4295-95ad-46086b5bf048
  - Description: Azure ResourceGroup
  - Triggers: 1
  - Resources: 1
  - Created: 2025-08-15T10:32:40.505Z
  - Created By: a-team
```


[user]
```md
Create a pattern
```

[agent]
```md
What deployment capability does this pattern provide? I need a
  capability name (2-4 words).

  Examples:
  - Specific: "Horizontal scaling", "Database persistence", "SSL
  termination"
  - Broad/Organizational: "Application networking", "General
  security", "Basic monitoring"

  Both specific and broad patterns are fine. What capability
  describes your pattern?
```


[user]
```md
AWS public services
```

[agent]
```md
What types of infrastructure should this apply to?

Examples by domain:
- Applications: web applications, microservices, APIs, ...
- Databases: databases, SQL databases, NoSQL, data stores, ...
- Networking: load balancers, ingresses, services, network ...
- Storage: persistent volumes, storage classes, backup systems
- Security: secrets, certificates, authentication, ...
- Infrastructure: clusters, nodes, compute resources, ...

  Please provide infrastructure type keywords separated by commas
  (avoid field names like 'image', 'tag', or specific values like
  'latest').
```


[user]
```md
AWS public services
```

[agent]
```md
Here's the expanded list of infrastructure types for your "AWS public
services" pattern:

AWS public services, public cloud services, managed services, serverless
services, cloud-native services, hosted services, platform services, SaaS
offerings, managed infrastructure, cloud resources, AWS managed services,
public cloud resources, external services, third-party services, cloud APIs,
managed databases, serverless functions, container services, analytics
services, ML services, AI services, compute services, storage services,
networking services, security services, monitoring services, integration
services

Please select which ones you want to keep for your pattern
triggers. You can:
- Choose any combination from the list above
- Add your own custom triggers
- Keep them all
```


[user]
```md
All
```

[agent]
```md
Which Kubernetes resources should be suggested for AWS public services?
Please list the resource types you want this pattern to suggest, separated
by commas. For example: Deployment, Service, ConfigMap or StatefulSet,
PersistentVolumeClaim, Secret.
```

[user]
```md
internetgateways.ec2.aws.m.upbound.io
```

[agent]
```md
Why does this combination of resources work well together for AWS public
services? This helps others understand when and why to use this pattern.
```


[user]
```md
Write it for me
```

[agent]
```md
Tool use                                                            
                                                                    
dot-ai - manageOrgData(dataType: "pattern", operation: "create",  sessionId:
"pattern-1756581858189-909c1cbe", step: "created-by", response:
"This pattern provides the foundational AWS networking infrastructure needed
for public-facing services. Internet gateways enable outbound internet
connectivity for resources in public subnets and allow inbound traffic from
the internet to reach publicly accessible services. This is essential for web
applications, APIs, load balancers, and any AWS services that need to
communicate with external systems or be accessible from the internet. The
pattern ensures proper network routing and connectivity for cloud-native
applications deployed on AWS.") (MCP)                                                             
                                                                    
Do you want to proceed?                                             
> 1. Yes                                                            
  2. Yes, and don't ask again for dot-ai - manageOrgData commands in...
  3. No, and tell Claude what to do differently (esc)
```


[agent]
```md
What is your name or team identifier? This helps track pattern
  ownership and allows others to contact you with questions.
```

[user]
```md
> a-team
```

[agent]
```md
Please review your pattern:

Description: AWS public services
Triggers: AWS public services, public cloud services, managed services, ...
Suggested Resources: internetgateways.ec2.aws.m.upbound.io
Rationale: This pattern provides the foundational AWS networking ...
Created By: a-team

Does this look correct? Type 'confirm' to create the pattern, or 'modify' to
make changes.
```


[user]
```md
> Confirm
```

[agent]
```md
Pattern Created Successfully!

Pattern ID: 70645609-c3e4-4139-bb56-cfb85e7e0536
Description: AWS public services
Triggers: AWS public services, public cloud services, managed services, ...
Resources: internetgateways.ec2.aws.m.upbound.io

The pattern is now ready to enhance AI recommendations. When users ask for
deployments matching your triggers, this pattern will suggest the specified
Kubernetes resources.
```
