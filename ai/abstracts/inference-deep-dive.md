# LLM Fits, But It Still Can't Serve More Then Four People: The VRAM Math Behind Self-Hosted Inference

I put a model on a GPU. It fit, with room to spare. It loaded, it answered instantly, and for about ten minutes I looked like a genius. Then the third person asked it something, and the answers just stopped coming. The third. Not the three hundredth. Same GPU, same model, same prompt. The only thing that changed was how many people were talking to it at once.

"Does the model fit?" is the check everybody runs before they deploy, and it tells you almost nothing about how many people you can serve. Weights are the easy part: parameters times bytes per parameter, and everyone gets that far. What nobody puts in the spreadsheet is the **KV cache** — the intermediate state the model keeps so it doesn't recompute the whole conversation for every new token. It lives in the same VRAM as the weights, it grows with the length of each conversation, and it grows again with every person having one at the same time. It is usually the smallest slice on the card, and it is the slice that decides your real user ceiling.

In this session, we'll do the arithmetic on paper, and then watch a real GPU disagree with us on camera. We'll put an 8 billion parameter model on a single NVIDIA L4 in a Kubernetes cluster, throw a hundred concurrent requests at it, and watch throughput collapse to a fraction of a request per second — while every single request returns HTTP 200. If you were watching error rates, you'd be looking at a perfectly healthy service. Then we'll go back to the engine's startup logs and find the line that predicted the whole thing before a single request arrived: maximum concurrency, **2.79x**. Under three conversations. That number was sitting there the whole time.

Then we fix it, without buying anything. **Quantization** is usually sold as a way to make a model fit. That's backwards. This model already fit. We shrink the weights to buy conversation space, and because the cache is the smallest slice on the card, cutting the weights by a third roughly triples the cache — and the users along with it. Then we aim the same trick directly at the cache itself and double it again. Four lines of configuration take us from under three concurrent conversations to over sixteen, on the same card, with the same model.

We'll also be honest about the parts that don't fit on a slide. What quantization actually costs you (a fraction of a percent on chat and summarisation, and rather more on multi-step maths and code generation — which is probably exactly what you intend to run on it), why no engine turns it on by default, why 4 bits is fine and 2 bits falls off a cliff, and why the measured throughput never quite matches the ceiling the engine prints. By the end of the talk the constraint has moved: we stop running out of memory and start running out of arithmetic, and more cache space stops helping. Knowing which of those two walls you're standing against is most of the job.

This is not a talk about which inference engine to pick, or about the control plane and gateway layers above it. It's the one layer down that everything else assumes you already understand — and it's the one that decides whether your self-hosted model serves your company or three of your colleagues.

## Short Abstract

I put an 8 billion parameter model on a GPU. It fit with room to spare. Then the third user showed up and the answers stopped coming.

"Does it fit?" is the wrong question. Weights are the easy part; the **KV cache** — the conversational memory shared by everyone talking to the model at once — is the slice nobody budgets for, and it's the one that sets your real user ceiling. In this session, we'll work out the VRAM arithmetic, deploy a model on a single NVIDIA L4 in Kubernetes, and watch a hundred concurrent requests grind it to a fraction of a request per second while every request still returns 200 OK. Then we'll find the line in the engine's startup logs that predicted it: maximum concurrency, 2.79x.

Then we'll fix it live. Quantization isn't for making models fit — it's for buying conversation space. Four lines of configuration take us from under three concurrent conversations to over sixteen, on the same card, with the same model. We'll cover what that costs in accuracy, why it isn't on by default, and how to tell when you've stopped being short of memory and started being short of compute.

## Benefits to the CNCF Ecosystem

Self-hosted inference is landing on Kubernetes whether the ecosystem is ready for it or not, and most of the guidance available today stops at "request a GPU and set replicas." This session gives platform engineers the capacity model underneath that: how to read an inference engine's startup output, how to translate VRAM into a number of concurrent users, and how to tell whether a GPU node pool is memory-bound or compute-bound before committing budget to more of them.

Everything is demonstrated on Kubernetes (CNCF Graduated), with the cluster itself managed by Flux (CNCF Graduated) so the setup behaves like a real environment rather than a pile of shell commands. The inference engine (vLLM) is community-governed rather than CNCF, but the operational lessons — capacity planning, load behaviour under concurrency, and reading saturation signals correctly — transfer to any serving stack the community adopts. It also arms platform teams to push back on the most expensive mistake in the space right now: buying more GPUs to solve a problem that four lines of configuration would have fixed.

## Key takeaways:

* Why inference is a memory management problem rather than a compute one, and why "does the model fit" is the wrong question to ask about a GPU
* What the KV cache actually is, why it's shared by everyone talking to the model at once, and why its size — not the model's — sets your concurrent user ceiling
* Which line in your inference engine's startup logs tells you your real user ceiling, before a single request arrives
* Why a service can be completely saturated while returning 100% successful responses, and what a queue looks like in a latency distribution
* Why quantization is about buying conversation space rather than making models fit, and why shrinking the weights by a third can triple the number of users
* What quantization actually costs in accuracy, where that cost shows up (code generation and multi-step reasoning), why 4 bits is fine and 2 bits isn't, and why no engine enables it by default
* How to tell when the constraint has moved from memory to compute, and more cache space has stopped buying you anything
