## Prefix Caching

* Keep the work already done on the opening tokens
* Skip ahead to the part that's genuinely new
* Matters: if you're running agents - every request

Note:
Before a model can answer anything, it has to read the question. All of it. And the question is usually a great deal bigger than whatever the person actually typed. There's a system prompt. There are tool definitions. In a chat, there's the entire conversation so far, resent from the beginning on every single turn. When does it matter? The moment your requests have something in common at the front. Which, if you're building anything agentic, is every request you will ever send.


<!-- .slide: data-background="img/inference-concepts/06-01.png" data-background-size="contain" data-background-color="black" -->

Note:
So if you're running an agent, every request it sends opens with the same tokens. Thousands of them. And in a session that's been going for a while, hundreds of thousands, because all of it goes back, every time. And the engine dutifully works through the whole lot, from scratch.


<!-- .slide: data-background="img/inference-concepts/06-02.png" data-background-size="contain" data-background-color="black" -->

Note:
Then the next request turns up, starting exactly the same way. Without prefix caching, the engine works through all of it again, as though it had never seen any of it before in its life. Prefix caching is the engine noticing. It hangs on to the work it already did on that opening stretch.


<!-- .slide: data-background="img/inference-concepts/06-03.png" data-background-size="contain" data-background-color="black" -->

Note:
And skips ahead to the part that's genuinely new. For a chatbot where everybody types something different, this does very little. For agents, where every request opens with the same enormous wall of context, it's the biggest single lever available.


```yaml [6]
containers:
  - name: vllm
    args:
      - --model
      - Qwen/Qwen3-8B
      - --enable-prefix-caching
```

Note:
In current vLLM, this is on by default, so the flag is mostly there to make it explicit. The catch is that it only helps when the request lands on a replica that already has that prefix cached. Keep that in mind; it comes back when we get to the gateway.
