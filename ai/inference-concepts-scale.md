## Sharding

* One model split across several GPUs
* Tensor parallelism or pipeline parallelism
* Matters: when the model won't fit

Note:
Two more, and then we're done. The first is what happens when the model doesn't fit on one card at all. We've been talking about 8 billion parameters on a 23 gigabyte GPU. The models people actually want are a great deal larger than that - large enough to need a rack, not a card. When does it matter? When your model won't fit, which is something you work out before you deploy rather than after.


<!-- .slide: data-background="img/inference-concepts/09-01.png" data-background-size="contain" data-background-color="black" -->

Note:
One model, too big for any single card.


<!-- .slide: data-background="img/inference-concepts/09-02.png" data-background-size="contain" data-background-color="black" -->

Note:
So you split the model across several GPUs. That's sharding, and there's more than one way to slice it. You can cut every layer across all the cards, or you can hand different cards different layers. Tensor parallelism and pipeline parallelism, if you want the words for them.


<!-- .slide: data-background="img/inference-concepts/09-03.png" data-background-size="contain" data-background-color="black" -->

Note:
They have very different consequences for how much those cards have to talk to each other. Cut every layer and the cards talk constantly, so they want to sit in the same machine. Hand out whole layers and they talk less, so they can spread further. That is a talk of its own.


```yaml [6-7|10]
containers:
  - name: vllm
    args:
      - --model
      - Qwen/Qwen3-32B
      - --tensor-parallel-size
      - "4"
    resources:
      limits:
        nvidia.com/gpu: 4
```

Note:
In vLLM, tensor parallelism is one argument, and it has to match the number of GPUs you ask Kubernetes for. Four cards, one model, one engine.


## Autoscaling

* Scale on queue depth and KV cache usage, not CPU
* A new GPU node starts empty: the cold-start wall
* Matters: the first time you look at a GPU bill

Note:
The second is that your traffic isn't constant. Nobody's is. And a GPU is far too expensive to leave sitting idle all night on the off chance.


<!-- .slide: data-background="img/inference-concepts/09-04.png" data-background-size="contain" data-background-color="black" -->

Note:
So you scale, on signals particular to this work: how deep the queue is, how full the KV cache is. Not CPU usage, which tells you almost nothing here.


<!-- .slide: data-background="img/inference-concepts/09-05.png" data-background-size="contain" data-background-color="black" -->

Note:
The queue grows, and a new replica gets created. The catch is real, though. A GPU node that scales up starts completely empty.


<!-- .slide: data-background="img/inference-concepts/09-06.png" data-background-size="contain" data-background-color="black" -->

Note:
It has to pull a container image, often around eight gigabytes for an engine...


<!-- .slide: data-background="img/inference-concepts/09-07.png" data-background-size="contain" data-background-color="black" -->

Note:
...then the weights, before it can answer anybody. And by the time it's ready, the spike that triggered it may be long over. That's the cold-start wall, and it's why scale-to-zero is harder than it sounds.


```yaml [12-16]
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: qwen3-8b
spec:
  scaleTargetRef:
    name: qwen3-8b
  minReplicaCount: 1
  maxReplicaCount: 4
  triggers:
    - type: prometheus
      metadata:
        serverAddress: http://prometheus.monitoring:9090
        query: sum(vllm:num_requests_waiting)
        threshold: "5"
```

Note:
This is KEDA scaling a vLLM Deployment. The interesting part is the query. Not CPU. The number of requests vLLM itself says are waiting in its queue. When that goes past five, add a replica.


## Disaggregation

* Prefill and decode on different machines
* Each matched to what its phase needs
* Matters: possibly never

Note:
One last word to leave you with: disaggregation. It's the most interesting idea in inference at the moment, and it needs just about everything in this talk to make sense.


<!-- .slide: data-background="img/inference-concepts/09-08.png" data-background-size="contain" data-background-color="black" -->

Note:
Remember the two phases? Reading the input is limited by compute. So run it on machines picked for compute.


<!-- .slide: data-background="img/inference-concepts/09-09.png" data-background-size="contain" data-background-color="black" -->

Note:
Writing the answer is limited by memory bandwidth, so run that on different machines, picked for bandwidth. What travels between them is the KV cache - the record of what was read - so decode can pick up exactly where prefill left off.


<!-- .slide: data-background="img/inference-concepts/09-10.png" data-background-size="contain" data-background-color="black" -->

Note:
Each phase gets hardware matched to what it actually needs, and neither one is stuck waiting behind the other. It's also a lot of moving parts, which is why it lives at the top of most people's list of things they may never need.
