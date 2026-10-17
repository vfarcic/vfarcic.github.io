## Inference Engine

* Between a model on disk and whoever is asking
* Load, remember, schedule, compute, serve
* Matters: the moment you deploy anything

Note:
You've used one, whether or not you've ever run one. If you've started Ollama on your laptop, that was an engine. If you've deployed vLLM, same. And if you've never touched either, every request you've ever sent to Anthropic or OpenAI still landed on an engine at the far end. Somebody is running it. It just isn't you.


<!-- .slide: data-background="img/inference-concepts/02-01.png" data-background-size="contain" data-background-color="black" -->

Note:
Start with somebody asking a question. These days, they're rarely asking the model directly. They ask an agent, or an app, or some piece of code that sits in front of it.


<!-- .slide: data-background="img/inference-concepts/02-02.png" data-background-size="contain" data-background-color="black" -->

Note:
And that agent turns one question into requests, plural. It reads files, calls tools, checks its own work, and every step is another request. One person is rarely one request. Those requests land on the engine. It speaks HTTP, so your code can talk to it roughly the way it talks to OpenAI.


<!-- .slide: data-background="img/inference-concepts/02-03.png" data-background-size="contain" data-background-color="black" -->

Note:
And on the other side of the engine, a model sitting on a disk. An inference engine is the program that sits between a model on a disk and somebody, or something, asking a question. That's the whole category.


<!-- .slide: data-background="img/inference-concepts/02-04.png" data-background-size="contain" data-background-color="black" -->

Note:
And the answers flow back the same way. The engine streams tokens to the agent, the agent decides what to do with them, often by sending yet another request, and eventually the person gets their answer.


<!-- .slide: data-background="img/inference-concepts/02-05.png" data-background-size="contain" data-background-color="black" -->

Note:
Its job list is short, and nearly everything else in this talk attaches to one of these. It loads the weights onto the GPU. Weights are just the numbers that came out of training, billions of them. Separately from those weights, it remembers - it keeps a running record of every conversation in progress. That record is the expensive part. Not the model. The record. It schedules - decides which request gets worked on next, and how many to work on at the same time. It computes - runs the actual arithmetic. And it serves the answers back. Load, remember, schedule, compute, serve. Engines differ, and how they differ is a whole other talk, but that job description doesn't change.


```yaml [5-6|7-9]
containers:
  - name: vllm
    image: vllm/vllm-openai:v0.27.1
    args:
      - --model
      - Qwen/Qwen3-8B
    resources:
      limits:
        nvidia.com/gpu: 1
```

Note:
In Kubernetes, an engine is just a container in a Deployment. This is vLLM. Which model to load, and one GPU to load it onto. That's enough to get an OpenAI-compatible endpoint. Everything else in this talk is about what happens after this works.


<!-- .slide: data-background="img/inference-concepts/02-06.png" data-background-size="contain" data-background-color="black" -->

Note:
The engine doesn't work alone, though, so before we climb inside it, here's the whole machine in one picture. At the bottom, kernels - not the operating-system kind. These are the little pieces of code that do the actual arithmetic. Everybody benchmarks them and almost nobody chooses them, so that's the last you'll hear about kernels today.


<!-- .slide: data-background="img/inference-concepts/02-07.png" data-background-size="contain" data-background-color="black" -->

Note:
Above them, the engine. The five things we just went through.


<!-- .slide: data-background="img/inference-concepts/02-08.png" data-background-size="contain" data-background-color="black" -->

Note:
Above that, a control plane, which deploys and manages engines, because sooner or later you have more than one.


<!-- .slide: data-background="img/inference-concepts/02-09.png" data-background-size="contain" data-background-color="black" -->

Note:
And on top, a gateway, routing traffic across models and replicas. Most of this talk lives in the engine. Not because the rest doesn't matter - we climb back out at the end - but because almost every word you'll hear thrown around, batching, paging, prefix caching, quantization, lives in there. And none of it makes sense until you know what the engine is trying to do.
