# What's Missing?


```md
Create a PostgreSQL database in AWS.
```

```md
I'll help you create a PostgreSQL database in AWS. Let me
  create a todo list to track this task and then provide you
   with the steps.
...
```


```md
Option 1: Amazon RDS (Recommended)

Amazon RDS for PostgreSQL is a managed service that handles
maintenance, backups, and scaling.

Steps:
1. AWS Console: Go to RDS in AWS Console
2. Create Database: Click "Create database"
3. Engine: Select PostgreSQL
4. Template: Choose production, dev/test, or free tier
5. Settings:
  - DB instance identifier (e.g., my-postgres-db)
  - Master username (e.g., postgres)
  - Master password
...
```


```md
Option 2: EC2 Self-Managed

Install PostgreSQL on an EC2 instance for full control.

Steps:
1. Launch EC2 instance (Ubuntu/Amazon Linux)
2. SSH into instance
3. Install PostgreSQL:
sudo apt update
sudo apt install postgresql postgresql-contrib
4. Configure PostgreSQL
5. Set up security groups for port 5432
```


<!-- .slide: data-background="img/idp-problem-intent.jpeg" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/idp-solution-workflows.jpeg" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/idp-problem-capabilities.jpeg" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/idp-problem-patterns.jpeg" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/idp-problem-policies.jpeg" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/idp-problem-context.jpeg" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/idp-solution-context-workflows-learning.jpeg" data-background-size="contain" data-background-color="black" -->
