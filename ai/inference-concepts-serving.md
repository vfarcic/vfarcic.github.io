## Continuous Batching

* Many requests in the same pass
* A finished request leaves, a waiting one takes its seat
* Matters: at your second concurrent user

Note:
A GPU is very good at doing many things at once, and fairly ordinary at doing one thing quickly. So the way to get value out of one is to work on several requests in the same pass. That's batching, and it comes in two flavours that behave nothing alike. When does it start to matter? At your second concurrent user. Literally the second one.


<!-- .slide: data-background="img/inference-concepts/04-01.png" data-background-size="contain" data-background-color="black" -->

Note:
The old way is to collect a handful of requests, run them together, wait for all of them to finish, and then pick up the next handful. It works. But if one person asked a yes-or-no question and another asked for a thousand-word essay, the yes-or-no finished ages ago, and its seat in that batch has been sitting empty ever since. Doing nothing, until the essay is done. Meanwhile everybody else is waiting outside.


<!-- .slide: data-background="img/inference-concepts/04-02.png" data-background-size="contain" data-background-color="black" -->

Note:
The modern way is continuous batching. Same essay, still running.


<!-- .slide: data-background="img/inference-concepts/04-03.png" data-background-size="contain" data-background-color="black" -->

Note:
But a request that finishes leaves straight away, and a waiting one takes its place. The batch turns over constantly, no seat sits empty, and nobody is waiting on a stranger's essay. That's the difference between a queue that drains and a queue that only grows.


## Paging

* KV cache handed out in small, fixed-size blocks
* No more reserving the maximum per request
* Matters: as soon as requests vary in length

Note:
The other half of serving many people is fitting them. Every conversation needs room in that KV cache, and you don't know up front how much. When does this one matter? As soon as requests vary much in length, which in practice means immediately.


<!-- .slide: data-background="img/inference-concepts/04-04.png" data-background-size="contain" data-background-color="black" -->

Note:
The obvious approach is to reserve the most a conversation could possibly need, per request, in advance. Which wastes an enormous amount, because hardly anyone uses their maximum. You end up with a card that's almost entirely reserved and almost entirely empty at the same time.


<!-- .slide: data-background="img/inference-concepts/04-05.png" data-background-size="contain" data-background-color="black" -->

Note:
Paging is the fix. Instead of one big reservation per conversation, the cache gets handed out in small fixed-size blocks, as and when they're needed. Conversations interleave, nobody holds room they aren't using, and more of them fit. If you've ever wondered how your laptop runs more programs than it has memory for, it's the same trick. That's what paged attention means.


```yaml [5-6|7-10]
containers:
  - name: vllm
    args:
      - --model
      - Qwen/Qwen3-8B
      - --max-num-seqs
      - "64"
      - --gpu-memory-utilization
      - "0.90"
      - --max-model-len
      - "8192"
```

Note:
You don't switch either of these on in vLLM. Continuous batching and paging are simply how it works. What you do set are their limits. Max num seqs is how many seats the batch has. GPU memory utilization is how much of the card the engine may take, and whatever the weights leave of it becomes the pool of cache blocks. Max model len is the longest conversation it will accept. Those three numbers decide how many people you serve before they start queueing.
