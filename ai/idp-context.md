<!-- .slide: data-background="img/idp-problem-context.jpeg" data-background-size="contain" data-background-color="black" -->

Note:
Here's a critical problem that can make or break your AI-powered infrastructure: context management. What exactly is context, and why does it matter so much?


<!-- .slide: data-background="img/idp-solution-context.jpeg" data-background-size="contain" data-background-color="black" -->

Note:
We need to provide AI with all the information it needs, but not more than that. Everything else that is information needed to find information should be in a separate context.


<!-- .slide: data-background="img/context-00.png" data-background-size="contain" data-background-color="black" -->

Note:
We're dealing with massive amounts of data: hundreds of Kubernetes resources, each with potentially enormous schemas, plus all our patterns, policies, user intents, and everything else. If you keep piling all of this into your AI's context (0), it quickly becomes garbage. And that garbage gets compacted into even bigger garbage until the whole system becomes completely useless.

This is a fundamental problem with how most people approach AI in infrastructure. They dump everything into the context and wonder why performance degrades, costs skyrocket, and responses become increasingly inaccurate.


<!-- .slide: data-background="img/context-01.png" data-background-size="contain" data-background-color="black" -->

Note:
Here's the solution: instead of building on top of previous context, each interaction in this MCP system starts with a completely **fresh context** (1). The agent inside the MCP gets exactly the relevant information it needs for the specific task at hand, no matter when that information was originally fetched or created. 

No accumulated garbage. No bloated context windows. No degraded performance. Just clean, relevant data for each interaction.


<!-- .slide: data-background="img/context-02.png" data-background-size="contain" data-background-color="black" -->

Note:
And here's a crucial optimization: use code, not agents, to fetch information in predictable situations (2). When you know exactly what data you need and where to get it, don't waste time and money asking an AI to fetch it. Direct code execution is faster, less expensive, more reliable, and completely deterministic.
