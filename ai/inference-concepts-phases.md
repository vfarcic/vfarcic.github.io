## Prefill And Decode

* Prefill: read the whole input at once - limited by compute
* Decode: one token at a time - limited by memory bandwidth
* Matters: as soon as inputs get long or vary in size

Note:
When a model answers a question, it's really doing two separate jobs, and they stress the hardware in completely different ways. Same request, two completely different constraints. Which is why a long input and a long answer make your GPU struggle in different places, and why nearly everything clever in inference is aimed at one or the other.


<!-- .slide: data-background="img/inference-concepts/07-01.png" data-background-size="contain" data-background-color="black" -->

Note:
The first job is reading the input. And the input is everything that got sent - the system prompt, the tool definitions, the whole conversation so far - not just the sentence somebody typed. The engine works through all of it in one go, in parallel. That's prefill, and what limits it is raw arithmetic. The GPU is doing as much maths as it possibly can, as fast as it can.


<!-- .slide: data-background="img/inference-concepts/07-02.png" data-background-size="contain" data-background-color="black" -->

Note:
The second job is writing the answer, and this one is stubbornly sequential. The model produces a token...


<!-- .slide: data-background="img/inference-concepts/07-03.png" data-background-size="contain" data-background-color="black" -->

Note:
...looks at what it just wrote, produces the next one. It can't go faster by doing more at once, because token two doesn't exist until token one does.


<!-- .slide: data-background="img/inference-concepts/07-04.png" data-background-size="contain" data-background-color="black" -->

Note:
That's decode, and it isn't limited by arithmetic at all. To produce each token it has to haul the entire model out of memory. 16 gigabytes, for one token.


<!-- .slide: data-background="img/inference-concepts/07-05.png" data-background-size="contain" data-background-color="black" -->

Note:
And again, for the next one. The GPU spends most of that time waiting on memory rather than calculating. So one phase is limited by compute and the other by memory bandwidth.


## Speculative Decoding

* A small model guesses the next few tokens
* The big model checks them all in one pass
* Matters: when a single request feels slow

Note:
Speculative decoding is aimed squarely at decode. When does it matter? When a single request feels slow - which, notice, is a different question from everything else in this talk. It's the one thing here that helps one person rather than fifty.


<!-- .slide: data-background="img/inference-concepts/07-06.png" data-background-size="contain" data-background-color="black" -->

Note:
If the trouble is that tokens only arrive one at a time, you bring in a second, much smaller model to guess the next few. Small models are fast, so guessing is cheap.


<!-- .slide: data-background="img/inference-concepts/07-07.png" data-background-size="contain" data-background-color="black" -->

Note:
Then you let the big model check all of those guesses at once. Checking several tokens is one pass, not several, because it's reading rather than writing.


<!-- .slide: data-background="img/inference-concepts/07-08.png" data-background-size="contain" data-background-color="black" -->

Note:
It keeps every guess up to the first wrong one, and redoes from there. When the guesses are right - and for predictable text they often are - you've had several tokens for the price of one.


```yaml [6-7]
containers:
  - name: vllm
    args:
      - --model
      - Qwen/Qwen3-8B
      - --speculative-config
      - '{"method": "draft_model", "model": "Qwen/Qwen3-0.6B", "num_speculative_tokens": 4}'
```

Note:
In vLLM it's one setting. A tiny model from the same family as the draft - it has to speak the same vocabulary - and how many tokens it gets to guess ahead. Guess too far, and you waste work on guesses that get thrown away.
