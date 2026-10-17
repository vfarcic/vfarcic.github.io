## Quantization

* Fewer bits per weight
* The room goes to the KV cache
* Matters: once you pay for the card

Note:
If the weights are the fixed cost, the obvious question is whether they have to be that big. They don't. Every weight is a number, stored at some precision. Quantization stores it at less. Think of it as rounding - a value kept to a lot of decimal places gets kept to fewer, and takes less room as a result. When does it start to matter to you? Roughly as soon as you're serving anybody at all on hardware you'd actually want to pay for.


<!-- .slide: data-background="img/inference-concepts/05-01.png" data-background-size="contain" data-background-color="black" -->

Note:
Here's our L4 again, drawn to scale. 23 gigabytes on the card. An 8 billion parameter model at 16 bits takes 16 of them before anybody has asked a single question. What's left over is the KV cache, the running record of every conversation in progress, and it's the smallest slice on the card.


<!-- .slide: data-background="img/inference-concepts/05-02.png" data-background-size="contain" data-background-color="black" -->

Note:
Now store the same weights at 8 bits instead of 16. Halve the bits and you roughly halve the weights. On that 16 gigabyte model, that's 8 gigabytes handed back. Same model, same card.


<!-- .slide: data-background="img/inference-concepts/05-03.png" data-background-size="contain" data-background-color="black" -->

Note:
And here's the part that isn't obvious. The space you get back doesn't go to the model. It goes to the KV cache. Which is the thing that decides how many people you can serve at the same time. The cache was the smallest slice, so a modest cut to the weights more than doubles it. So quantization isn't really about making a model fit. This model already fit. It's about what's left over once it has.


```yaml [7-8|9-10]
containers:
  - name: vllm
    image: vllm/vllm-openai:v0.27.1
    args:
      - --model
      - Qwen/Qwen3-8B
      - --quantization
      - fp8
      - --kv-cache-dtype
      - fp8
```

Note:
And this is all it takes in vLLM. Same Deployment, same model, two lines. Quantization fp8 stores the weights at 8 bits, converted as the engine loads them. And while we're at it, kv-cache-dtype fp8 aims the same trick at the cache itself, so every token in that cache takes half the space it did before. On a single L4, those four lines take this model from under three full-length conversations to over sixteen. It does cost you something. It's small, and it lands harder on some kinds of work than others - code and multi-step reasoning more than chat. That's a whole talk by itself.
