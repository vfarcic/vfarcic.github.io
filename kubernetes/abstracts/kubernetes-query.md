# kubectl get all Is a Lie: Fixing Kubernetes' Broken Query Story with Vector Databases and Semantic Search

`kubectl get all` doesn't get all. It gets maybe 10% of what's actually in your cluster. Want the other 90%? You're writing bash loops, iterating over hundreds of API resource definitions, waiting forever, and still missing resources because you don't even know what to search for. The root cause is etcd — a key-value store that was never designed to answer questions like "show me all databases" or "what's running in this namespace."

In this talk, we'll expose Kubernetes' terrible querying story and then fix it. We'll sync Kubernetes metadata into a Vector database, enabling both traditional structured queries and semantic search. You'll see how a query that takes minutes of bash scripting against the Kube API returns instantly from a proper database. More importantly, you'll see how semantic search finds resources by meaning — asking "find all databases" returns StatefulSets, CloudNativePG clusters, Crossplane-managed RDS instances, and Qdrant deployments, regardless of what they're named or which API group they belong to.

## Key takeaways:

* Why `kubectl get all` is misleading and how Kubernetes' reliance on etcd makes querying fundamentally broken
* How to sync Kubernetes CRDs and resource metadata into a Vector database for instant, comprehensive querying
* The difference between exact-match querying and semantic search, and why you need both
* How AI agents combined with MCP servers can use Vector DB-backed semantic search to answer any question about your cluster
* The architecture: controllers that watch the Kubernetes API, a Vector DB (Qdrant) for storage, and an MCP server that exposes both MCP and REST protocols for any client
* Why syncing metadata (not everything) is the key to keeping the system fast and reliable
