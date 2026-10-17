## Weights

* Parameters x bytes per parameter
* 8 billion x 2 bytes = 16 GB, on the card
* Matters: immediately - no fit, no service

Note:
Everything the engine holds on that card is one of two things, and the two behave nothing alike. The first is the weights. A weight is a number that came out of training. There are billions of them, and a number takes up room. At the precision most models ship at, two bytes each. So the arithmetic isn't complicated. 8 billion parameters, 2 bytes apiece, 16 gigabytes. And those 16 gigabytes have to sit on the card itself, right next to the thing doing the maths. Not in the machine's ordinary RAM. On the card.


## KV Cache

* The running record of every conversation
* Grows with length, and with every extra person
* Matters: later - how much later depends on your users

Note:
The second cost is not like that at all. When a model writes a sentence, it looks back at everything that came before it. Every token, every time. Recomputing all of that for every new word would be ridiculous, so the engine keeps those intermediate values and reuses them. That's the KV cache. Same card, same memory, sitting right next to the weights and competing with them for room.


<!-- .slide: data-background="img/inference-concepts/03-01.png" data-background-size="contain" data-background-color="black" -->

Note:
Take the NVIDIA L4 as an example. About the cheapest datacenter GPU you can rent, and 23 gigabytes of memory on the card. 16 of them are gone before anybody has asked a single question. But here's the thing about that 16. It never changes. One user or a thousand users, the weights cost exactly the same. You load them once and you're done thinking about them.


<!-- .slide: data-background="img/inference-concepts/03-02.png" data-background-size="contain" data-background-color="black" -->

Note:
What's left is where the KV cache lives. And it grows in two directions at once. It grows as a conversation gets longer, because there's more to remember.


<!-- .slide: data-background="img/inference-concepts/03-03.png" data-background-size="contain" data-background-color="black" -->

Note:
And it grows with every extra person having a conversation at the same time, because every one of them needs their own. Ten people deep in long conversations need ten times the cache of one. One cost is fixed. The other one multiplies. The weights matter immediately - if they don't fit, you haven't got a service at all. The cache matters later, and that second one is what almost nobody thinks about until they're already past it.
