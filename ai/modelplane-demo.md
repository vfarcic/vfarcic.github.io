<!-- .slide: id="demo" -->
## Inspect the GPU fleet

```sh
cat "$PROVIDER/cluster-classes.yaml"

cat "$PROVIDER/clusters.yaml"

kubectl get inferenceclasses,inferenceclusters
```

Note:
At this point the control plane is up. That's the cluster where Modelplane itself runs, and from here it manages everything else. In this demo it happens to be a local KinD cluster, but it doesn't have to be. The control plane can run anywhere. Before the talk, I also prepared the GPU fleet, because provisioning real clusters is not something we want to wait for on stage. What we're looking at now is the platform side of that split. We're not deploying models yet. We're describing the fleet those models will eventually land on.
There are two building blocks to get straight here, and the pattern is one Kubernetes already uses. Think of a StorageClass. You define a kind of storage once, then reference it by name from a claim. An InferenceClass is the same move, but for GPU hardware. You define the recipe once, and then reference it by name. The only real twist is scope. The class lives up on the control plane, so a single recipe is shared by clusters across the whole fleet.
Look at a single class and it splits cleanly into two parts. The provisioning part says how to build this kind of node pool on a cloud. The devices part describes the hardware itself. The selected provider gives us a smaller L4 and a larger GPU class. The cloud-specific details change, but the hardware contract is the same idea.
Each cluster then lists its node pools, and every pool simply points back at one of those classes by name, along with how many nodes it wants and which zones to run them in. And notice that you only ever declare the GPU pools. Modelplane injects a separate system pool to run the serving stack, so you don't have to decide where all the supporting plumbing lives.
Listing the clusters gives us the state of the whole fleet. Ready means the platform is prepared to serve; it does not mean a model is already running. The model is the developer's half of the story, and that's where we're going next.
*Run from modelplane-demo with .env sourced. Show the chosen provider's manifests and real status. This fleet was provisioned beforehand; do not reapply infrastructure on stage.*


<!-- .slide: id="demo-deploy" -->
## Declare what the model needs

```sh
cat inference.yaml

kubectl --namespace a-team apply --filename inference.yaml
```

Note:
Now let's switch to the developers. This is their half of the story, and there's surprisingly little to it. Here's exactly what a developer hands to Modelplane to get a model running on the fleet.
The first object here is the ModelDeployment. In it, you say which model you want to run, the engine that's going to serve it, and how many replicas you'd like. That's the shape of it. The replica's configuration sits inside a template, just as it does in a Kubernetes Deployment.
And notice that the engine's template is an ordinary Kubernetes pod template. You bring your own engine. In this case, that's the vLLM image, along with the arguments that tell it to load Qwen. Modelplane composes the serving workload and routing around it. The engine flags still belong to the developer; the control plane does not decide your quantization or parallelism strategy for you.
Now, I picked a tiny half-billion-parameter model purely because it's cheap to serve. The fleet might need to run much bigger models on serious GPUs, but Qwen is an affordable stand-in for demonstrating the orchestration without making this demo cost a fortune.
The one part worth slowing down on is the nodeSelector. It's a CEL expression that states, in code, the hardware this model needs: here, a GPU with at least twenty GiB of memory. That expression gets matched against the devices each hardware class published when we described the fleet. This, right here, is where the two halves finally meet. The developer says what the model needs, the platform side already said what the hardware offers, and the scheduler lines the two up.
The second object, the ModelService, does something simple but important. It selects the deployment's reachable endpoints and gives them one stable model name at the gateway. The replicas can live in different clusters without making the caller select one.
And this is that split from the beginning finally showing up in the manifests. The platform side owns the classes and the clusters. The developer, over here in their own namespace, just declares a model and the GPU it needs, without naming a cluster or instance type. One person can wear both hats, sure, but the API keeps those concerns apart.
So let's apply that manifest into the developer's namespace. While the image is being pulled and the model is loading, let's pull back and look at the platform underneath it.
*Inspect the manifest, then apply it. Leave startup running and advance into the first diagram. Each requested replica is a complete serving instance within one cluster, not one model split across regions.*


<!-- .slide: id="diagram-control-plane" data-background="img/modelplane/diag-13-01.png" data-background-size="contain" data-background-color="black" -->

Note:
At the center sits the control plane, the cluster where Modelplane runs. This is the management side of the system. It's where we declare the fleet and the models, and where reconciliation connects what we asked for to what's actually there.
Crossplane is the foundation underneath that. It provides the APIs and composition framework; Modelplane's functions schedule and compose the inference resources, and providers act on the infrastructure and workload clusters. We're applying the same control-plane pattern platform teams already use for infrastructure, one level up across an inference fleet.
*The model is starting in the background. This diagram describes the prepared platform, not infrastructure newly created by the model apply.*


<!-- .slide: id="diagram-hardware-contract" data-background="img/modelplane/diag-13-02.png" data-background-size="contain" data-background-color="black" -->

Note:
We defined our hardware as reusable classes, the blessed GPU recipes. That devices section is a contract, written in the style of Kubernetes Dynamic Resource Allocation, or DRA. It describes the GPU in the same terms a driver reports on a real node, and it's what the model selects against when it asks for hardware.
The platform team publishes what the hardware offers without needing to know every model that will run on it. The developer describes the requirement without needing to know every machine the platform team can provision. That's the point of putting a contract between them.


<!-- .slide: id="diagram-fleet" data-background="img/modelplane/diag-13-03.png" data-background-size="contain" data-background-color="black" -->

Note:
Then we registered three clusters that reference those classes, spread across different regions. Each icon here is a cluster in the fleet, not a single node. This run uses the cloud we selected in setup, but nothing forces an entire fleet to use just one provider.
A real fleet can be a mix: managed cloud clusters and clusters running on your own hardware, all under one control plane. And the labels aren't just decoration. They feed placement later on. A workload can be restricted to a region or tier without naming an individual cluster.
For clusters you already operate, bring-your-own adds the serving layer without taking over how you create the infrastructure. You still have to meet its Kubernetes, GPU-driver, pool-label, and connectivity requirements. It is a way to add fleet inference to the infrastructure you've already built.


<!-- .slide: id="diagram-serving-stacks" data-background="img/modelplane/diag-13-04.png" data-background-size="contain" data-background-color="black" -->

Note:
Modelplane provisioned each cluster with its GPU pool and serving stack. And it's worth pausing on how much that short spec is hiding: networking, identities, node pools, the gateway plumbing, device binding, the works. Those clusters didn't come up bare.
On each cluster, the serving layer is ready for the engine the developer brings. A single-node engine becomes a Deployment. When a model needs several nodes, the Standard stack uses LeaderWorkerSet; the Dynamo stack can use Grove and KAI Scheduler for gang scheduling. That is cluster-level serving underneath the fleet-level control plane.
The engine still runs the model. The control plane handles the topology, placement, and resources around it. You don't replace vLLM with a control plane any more than you replace an application with Kubernetes.


<!-- .slide: id="diagram-fleet-status" data-background="img/modelplane/diag-13-05.png" data-background-size="contain" data-background-color="black" -->

Note:
And every cluster reports its serving address and state back to the control plane, so the fleet can be managed from one place. That's the platform side done. The fleet is up, and the developer's declaration is now being matched against it.
These dashed lines are the management loop. They're not model requests taking a detour through my laptop. The control plane reconciles the declared state; the inference gateways and engines carry the request traffic. Keeping those two paths separate is important.
It's also why deployment isn't the end of the job. Capacity, readiness, and endpoints change. The platform has to keep connecting what the workload needs to what the fleet can provide, not just run a successful installation script once.


<!-- .slide: id="demo-placement" -->
## Inspect the placement

```sh
kubectl --namespace a-team get modeldeployments,modelreplicas

kubectl --namespace a-team get modelendpoints,modelservices
```

Note:
Now let's see what Modelplane actually did with that declaration. These replicas are the complete serving instances it placed on the fleet. The developer didn't name these clusters. The scheduler matched the hardware requirement against the capacity the platform team published and chose where the replicas could fit.
Look at readiness as well as synchronization. We asked for two replicas; if they're still starting, or if one cannot get the resources it needs, the deployment can be below that desired state. GPUs are genuinely hard to get hold of, and that's part of why this is a fleet problem rather than just a serving-engine problem.
The fleet scheduler's accounting is deliberately conservative: it reasons about compatible pools and node capacity. The cluster's own scheduler and DRA make the device allocation on the actual nodes. This isn't a promise of perfect GPU packing or automatic movement to the cheapest cluster every time the fleet changes.
*Describe the actual cluster pair and conditions on screen. Do not reproduce the manuscript's recorded one-replica failure as an expected result. If startup is still running, inspect again after continuing the explanation.*


<!-- .slide: id="demo-ready" -->
## Inspect the routing

```sh
kubectl --namespace a-team get modelservices,modelroutes
```

Note:
Placement is only half the story. We have serving instances somewhere out on the fleet. An application still needs a way to reach them without keeping track of all those locations.
The service selects reachable endpoints, and the composed routes put that service onto the gateway. A replica still loading its model isn't a backend we should send requests to. As replicas become ready, their endpoints join the service; if they become unhealthy, those endpoints are withdrawn.
That's a different decision from scheduling. Scheduling decides where the workload runs. Routing decides where a request goes. The stable service connects the two without exposing every change to the caller.
*Check model, service, and route readiness before the request. If they are not ready, keep explaining and return to the outputs rather than blocking the talk on the rehearsal guide's long waits.*


<!-- .slide: id="demo-endpoint" -->
## One front door

```sh
export ADDRESS=$(kubectl get inferencegateway default \
  --output jsonpath='{.status.endpoints.openAI}')

echo "$ADDRESS"
```

Note:
So let's put the whole thing to the test. First, we grab the address Modelplane assigned to the inference gateway and stash it in a variable so we can point at it easily.
That's the thing to focus on: a single entry point for models whose replicas are living out on the fleet. The gateway runs on an inference cluster, not on this local control cluster. On AWS we prepared it in the east cluster; on Google it's in the central cluster.
The application gets a base URL and a model name, a-team/qwen. It doesn't need an inventory of our clusters. And that model name is separate from the name vLLM uses for its backend: the gateway translates it when it selects an endpoint.
*Keep ADDRESS in this shell. It is read from the gateway, not from the old per-service address field used by the manuscript.*


<!-- .slide: id="demo-request" -->
## Send a standard request

```sh
curl --fail --silent --show-error \
  --connect-timeout 10 --max-time 180 \
  "$ADDRESS/chat/completions" \
  --header 'Content-Type: application/json' \
  --data '{
    "model": "a-team/qwen",
    "messages": [{
      "role": "user",
      "content": "What is Crossplane in one sentence?"
    }],
    "max_tokens": 100
  }' | jq .
```

Note:
And now the actual test. Normally you'd connect an agent, an application, or really anything else to this endpoint and let it talk to the model. But for simplicity here, we'll just use curl to send a completely ordinary OpenAI chat-completions request and see what comes back.
The model we're naming is our service, a-team/qwen. The gateway resolves that name and sends the request to a ready backend. jq just makes the JSON easier to read; it doesn't change the request or how inference is served.
And there it is. A standard chat completion, served by Qwen running out on a remote cluster, and reached through one endpoint. Our request found a model somewhere out on the fleet and came back to us through one single door.
*Inspect the actual response before saying the path worked. Generated wording can differ from the manuscript; a response does not prove that every replica received traffic.*


<!-- .slide: id="diagram-developer" data-background="img/modelplane/diag-14-01.png" data-background-size="contain" data-background-color="black" -->

Note:
So let's pull back and look at the whole loop we just ran. A developer declared a model and the GPU it needs. That's the developer's responsibility: the model, the engine, and the requirements. They didn't pick an instance type or maintain a list of clusters.


<!-- .slide: id="diagram-placement" data-background="img/modelplane/diag-14-02.png" data-background-size="contain" data-background-color="black" -->

Note:
The scheduler took that declaration, matched it against the hardware classes the platform side had published, and placed replicas out across the fleet, onto clusters that fit and had capacity. Notice it didn't just drop one on every cluster. We asked for a number of replicas, and the scheduler found places for those replicas.
That's the placement half of the story. One complete replica stays within a cluster; this is not tensor parallelism stretched across a wide-area network. If that serving instance needs several nodes, its gang stays together within the cluster's pool.
*The drawing uses clusters 1 and 3 as an illustration. Relate it to the actual pair inspected earlier, not literal region numbers.*


<!-- .slide: id="diagram-front-door" data-background="img/modelplane/diag-14-03.png" data-background-size="contain" data-background-color="black" -->

Note:
Then, at request time, a call came in to one inference endpoint. The application didn't ask which region had a free GPU. It named the service it wanted and sent the same kind of request it would send to an OpenAI-compatible API anywhere else.
The gateway is the front door. Its location in this drawing is conceptual; in this setup it runs on an inference cluster. It is managed by the control plane, but the request isn't being served by the control plane.


<!-- .slide: id="diagram-request-routing" data-background="img/modelplane/diag-14-04.png" data-background-size="contain" data-background-color="black" -->

Note:
The inference gateway routed the call out to a cluster holding a ready replica, and the cluster's serving layer took it to the engine. That's the routing half of the story. The fleet placement and the request path are different mechanisms, connected by the service's endpoints.
The important part for the caller is what it didn't have to do. It didn't discover those replicas or change its model name when the backend changed. The platform takes responsibility for that connection.


<!-- .slide: id="diagram-response" data-background="img/modelplane/diag-14-05.png" data-background-size="contain" data-background-color="black" -->

Note:
And the model served its response back through that same one door. Describe the fleet, deploy a model, reach it through one endpoint, with Modelplane placing the replicas out wherever compatible GPU capacity is available.
The engine generated the tokens. The control plane operated the fleet around it. That's the boundary: model execution and optimization still belong to the serving engine and its configuration. Providing a usable internal service is the platform's job.
Now let's change something underneath that service and see what the application has to change.


<!-- .slide: id="demo-scale" -->
## Change capacity, keep the service

```sh
kubectl --namespace a-team scale modeldeployment qwen-demo \
  --replicas=3

kubectl --namespace a-team get modelreplicas,modelendpoints

curl --fail --silent --show-error \
  --connect-timeout 10 --max-time 180 \
  "$ADDRESS/chat/completions" \
  --header 'Content-Type: application/json' \
  --data '{
    "model": "a-team/qwen",
    "messages": [{
      "role": "user",
      "content": "What is Crossplane in one sentence?"
    }],
    "max_tokens": 100
  }' | jq .
```

Note:
Deploying a model is only the beginning. Here we're asking for another complete serving instance. The same reconciliation loop finds compatible capacity, composes the extra replica, and makes its endpoint available once it's ready. The existing replicas can keep serving while that work happens.
And look at the client. It's exactly the same curl command. Same address, same model name, same request. That's what it means to turn inference into an internal service. The application consumes a contract, not a particular GPU cluster.
There are limits to what this shows. Healthy replicas keep their placements; a new cluster doesn't make the scheduler shuffle everything around for a globally optimal result. And a successful request while the new replica starts proves the service is still reachable, not that the new replica answered or that all regions received traffic.
*Launch scaling, explain the reconciliation and stable interface while it runs, then inspect the actual endpoints. Send the same request using the existing ADDRESS. Do not claim the third replica is serving until its readiness confirms that.*
