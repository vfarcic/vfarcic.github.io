<!-- .slide: data-background="img/ai-useless.png" data-background-size="cover" data-background-color="black" -->

Note:
Here's the harsh reality: your AI agent is **completely useless** for infrastructure management, enabling development teams, and increase software delivery speed and you probably don't even realize it yet.

You've probably tried throwing ChatGPT or Claude at your DevOps problems, thinking AI will magically solve your infrastructure challenges. Maybe you got some generic responses that looked helpful on the surface. But when you actually tried to implement those suggestions, you discovered the painful truth - the AI has no clue about your environment, your standards, or your constraints.

Most organizations are making the same critical mistake: they're treating AI like a search engine instead of building it into their platform properly. They ask vague questions, get generic answers, and wonder why their "AI transformation" isn't working.

But here's what changes everything: when you build AI into your Internal Developer Platform the right way, with proper context management, organizational learning, and intelligent workflows, you get something completely different. You get an AI system that actually understands your infrastructure, follows your patterns, enforces your policies, and delivers solutions that work in your specific environment.

In this talk, I'm going to show you the **five fundamental problems** that make most AI implementations worthless, and then walk you through building the essential components that solve every single one of them. By the end, you'll have a complete blueprint for an AI-powered IDP that actually works.

Today we're exploring the essential components you need to build when integrating AI into Internal Developer Platforms. We're not just talking about throwing ChatGPT at your infrastructure problems and hoping for the best. We're talking about creating a proper AI-powered system that actually understands your organization, follows your patterns, and enforces your policies.

So let me start with a simple question: what happens when you give an AI agent a vague request without proper context or guidance?


# Let's create a Platform Agent

<!-- .slide: data-background="img/agents-to-platforms.png" data-background-size="contain" data-background-color="black" -->

Note:
At the end of the day we want to automate our platform tasks, so let's add a platform agent to do this. 
The next section should look into what happens if you agent just send the prompts to OpenAI, or any other LLM.


# But wait a minute, where is that LLM hosted?

```md

- Public LLM: $$$$$$

- Private LLM: :( :(

```


# Hosting Private LLMs

<!-- .slide: data-background="img/vllm.png" data-background-size="contain" data-background-color="black" -->

Note:
With VLLM you can not only host your models inside Kubernetes clusters, but also scaled them up for production and train and fine tune models. 100% recomended for you to check this.


# Public LLMs, but under control

<!-- .slide: data-background="img/envoy-ai-gateway.png" data-background-size="contain" data-background-color="black" -->

Note: 
If you work for a company where calling external services and sending data outside of your company is not a problem, calling public LLM services is ok. But I strongly recommend you to check the Envoy AI Gateway project as having a proxy between your applications and public services can help you not only to route traffic to different services, but also filter and apply quotas for cost or SLO related reasons.


# Let's give a try

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

Note:
First of all, that intent was insufficient. No one, be it human or AI can do the right thing without knowing more about it. What are we trying to accomplish? Why are we doing it? What is the the problem?


<!-- .slide: data-background="img/idp-problem-capabilities.jpeg" data-background-size="contain" data-background-color="black" -->

Note:
Next, we need to know what can and what cannot be done. Do we run on-prem or do we use one of the hyperscalers? If we do, which one? Which services can and which ones cannot be used? Is there a control plane?


<!-- .slide: data-background="img/idp-problem-patterns.jpeg" data-background-size="contain" data-background-color="black" -->

Note:
Then we need to know the patterns. If we have no clue about our naming conventions, our preferred architectures, our deployment strategies, or any of the tribal knowledge that lives in our documentation, wiki pages, code repositories, and Slack conversations, we will surely fail to assemble the correct components.


<!-- .slide: data-background="img/idp-problem-policies.jpeg" data-background-size="contain" data-background-color="black" -->

Note:
Similarly, we need to know company patterns. Do we use a specific region? Can we use latest images?


<!-- .slide: data-background="img/idp-problem-context.jpeg" data-background-size="contain" data-background-color="black" -->

Note:
Then there is the problem of context overload. If we are given too much information, we get blocked. We cannot be insufficient data, but we cannot be overloaded with data either.


<!-- .slide: data-background="img/idp-solution-context-workflows-learning.jpeg" data-background-size="contain" data-background-color="black" -->

Note:
Those problems are the same no matter whether a person or AI tries to do something. We've been trying to solve those issues on the human level for decades, and now we need to apply the same to AI. We need to figure out how to manage context, how to have some kind of a structured process (workflows), and we need to figure out how AI can learn things that are specific to our company.

So what do we actually need to solve these problems? Three fundamental components: proper context management, workflows, and learning.

Let me be clear about what "proper" context management means. It's not the constant accumulation of everything that's ever been said or done. That's a recipe for disaster. Instead, it means starting with a fresh context for every interaction, but populating that context with all the relevant data that specific task needs and nothing more.

Workflows should guide both people and AI towards the right solution instead of relying on incomplete user intents and the AI's unpredictable decision-making process. You can't just throw a vague request at an AI and expect it to magically understand what you really need.

Learning is how you teach AI about your organizational data: patterns, policies, best practices, and everything else that makes your environment unique. But here's the catch: AI models can't actually learn in the traditional sense. Everything you teach it gets lost when the conversation ends. AI is like a person with severe short-term memory loss, or like a goldfish that forgets everything after a few seconds.

So teaching it everything upfront is a complete waste of time. Instead, you should teach it only the parts that are relevant to specific situations, based on the user's intent, the current workflow step, and other contextual factors. Think of it as temporary, just-in-time learning.

What we're covering today is really the culmination of subjects we've explored in previous videos. This is where we're putting quite a few hard-learned lessons together into a cohesive system.

All in all, we'll explore three types of learning that are crucial for IDPs: capabilities, patterns, and policies. We'll also dive into context management and workflows. When you combine all these components properly, you get a complete, AI-powered Internal Developer Platform that actually works.