## Control Plane

* Decides what runs where, and keeps it running
* Deploys, updates, and replaces engines
* Matters: at your second model or replica

Note:
Everything so far has been inside one engine, serving one model, on one GPU. Which is a perfectly fine place to be, right up until it isn't. When do the next two start to matter? Later than most of this talk, and then all at once. One model and one replica, and you need neither of them. The moment there's a second of anything, you need both.


<!-- .slide: data-background="img/inference-concepts/08-01.png" data-background-size="contain" data-background-color="black" -->

Note:
Because sooner or later there's a second model. And a second replica of the first one. And a version you're testing before it goes anywhere near production. Now somebody has to decide what runs where, what gets updated when, and what happens when a node quietly disappears underneath you.


<!-- .slide: data-background="img/inference-concepts/08-02.png" data-background-size="contain" data-background-color="black" -->

Note:
That somebody is a control plane. It deploys engines, it manages them, and it takes the Deployment YAML you've been hand-writing away from you.


```yaml
apiVersion: serving.kserve.io/v1beta1
kind: InferenceService
metadata:
  name: qwen3-8b
spec:
  predictor:
    model:
      modelFormat:
        name: huggingface
      storageUri: hf://Qwen/Qwen3-8B
      resources:
        limits:
          nvidia.com/gpu: 1
```

Note:
This is KServe, one of several. You stop describing containers and arguments, and start describing a model: what it is, where it comes from, what it needs. The control plane picks the engine, wires up the rest, and keeps it running.


## Gateway

* Routes each request across models and replicas
* Round-robin is wrong for language models
* Matters: at your second replica

Note:
And once more than one engine is running, something has to decide which of them any given request goes to. That's a gateway.


<!-- .slide: data-background="img/inference-concepts/08-03.png" data-background-size="contain" data-background-color="black" -->

Note:
A request comes in, and lands on the gateway.


<!-- .slide: data-background="img/inference-concepts/08-04.png" data-background-size="contain" data-background-color="black" -->

Note:
Behind it, several replicas of the same model. You'd be forgiven for thinking this one's solved. We've been load balancing HTTP for 30 years. It isn't solved, and plain round-robin is actively wrong for language models. Requests aren't interchangeable.


<!-- .slide: data-background="img/inference-concepts/08-05.png" data-background-size="contain" data-background-color="black" -->

Note:
So the gateway asks something that watches the replicas - how deep their queues are, how full their caches are, which prompts they've already seen. One replica may already have your conversation warm in its cache while another has never seen you.


<!-- .slide: data-background="img/inference-concepts/08-06.png" data-background-size="contain" data-background-color="black" -->

Note:
And it sends the request to that one. Landing on the wrong one costs real money and real time. Remember prefix caching? This is where it pays off, or doesn't.


```yaml
apiVersion: inference.networking.k8s.io/v1
kind: InferencePool
metadata:
  name: qwen3-8b
spec:
  targetPorts:
    - number: 8000
  selector:
    matchLabels:
      app: qwen3-8b
  endpointPickerRef:
    name: qwen3-8b-epp
    port:
      number: 9002
```

Note:
This is the Gateway API Inference Extension. A pool sits where a Service would sit and selects the same Pods. The difference is the endpoint picker reference. A Service is a set of Pods and an assumption that any of them will do. A pool is the same set of Pods and a picker that decides which one does.
