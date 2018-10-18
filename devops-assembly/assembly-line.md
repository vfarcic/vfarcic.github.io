# What Is
# (Software)
# Assembly Line?

---

Note:
Let's start with setting the record straight. There is no such thing as **DevOps Assembly Line**. I invented it by replacing **Software** with **DevOps**. Why did I do that? Because everything needs to put the word "DevOps" to be popular. Saying software assembly lines is boring. It sounds like something you already know, or at least you heard or it. Nevertheless, everything changes and software assembly lines are not an exception. So, in the spirit of self-marketing, the title contains **DevOps** as a way to attract your attention. Still, from now on, I'll call it what it is. It'll be the **software assembly line**.


## What Is Manufacturing Assembly Line?

---

> In the manufacturing process, parts are added in sequence until the final assembly is produced.

Note:
To understand software assembly line, we need to understand manufacturing assembly line first. After all, we (software industry) based a lot of our practices on manufacturing industry. That is terribly wrong, but that's where most of us are, so let's see what does it mean in manufacturing. Manufacturing assembly line can be described with the sentence that follows.

> In the manufacturing process, parts are added in sequence until the final assembly is produced.

That sounds straightforward. Actually, it's so easy to understand that many thought that should be the way to assemble software. Add the parts in sequence from gathering requirements, all the way until it's deployed to production. Yippee! We got a process.

The problem is that the manufacturing process differs from software development in one key aspect.


## What Is Manufacturing Assembly Line?

---

> Mass-produce a product with the same specifications and quality.

Note:
> The goal of the manufacturing assembly line is to mass-produce a product with the same specifications and quality.

The goal of an assembly line in the manufacturing industry is to create many identical copies of something. The car industry, for example, uses assembly lines to produce thousands of cars that are exactly the same. Even when there are variations, they are limited in number and are never custom. We cannot order a wheel in a different place, nor we can choose any fabric for the interior. At best, we can choose from a few pre-defined options. The software industry is entirely different


### What Is Software Assembly Line?

---

> Produce a **single** product with a **repeatable process**.

Note:
> The goal of a software company is to produce a single product with a repeatable process.

We do not have goals to mass-produce anything. We are trying to produce a **single** product with a **repeatable process**. We do not make many copies of the same product (excluding those still delivering CDs and floppy disks to their desktop customers). At least, not in a physical form.

Every release is a different product. If that's not your case, and if you do make the same release over and over again, you are probably confused and chose the wrong industry.


### What Is Software Assembly Line?

---

> Every commit is a different product.

Note:
> Every commit is a different product.

All that is not to say that there is nothing to be learned from manufacturing assembly line. It features a repeatable process. Our processes should be repeatable as well. However, almost every manufacturing assembly line involves automation and manual labor. Ours shouldn't because we do not deal with the physical world (everything is bytes). We can have a fully automated process after the creative tasks end. And that leads me to yet another significant difference.

In manufacturing, considerable investment in time, people, and money goes into manufacturing while the design is usually much cheaper. We do, for example, need to design a car, but that is only a fraction of the cost. Producing it is where the real expense lies. If the design is wrong, the cost of repeating the production and re-delivering the product to the customer is so big that it can ruin a company. In software, the design represents almost the entire cost of a release. Now, I need to clarify that by design, I want to say creative and not repeatable work that involves not only brainstorming of a solution but also coding. Every feature we deliver is a result of a massive effort in creative tasks, and almost no effort to move it (after a commit) through the assembly which, in this context, means building, testing, deploying, and other repetitive tasks. At least, that's how it should be, even though in many cases it's not. If we make a mistake in design, all we have to do is to correct it. Delivering the change to customers is almost instant, and there is no significant cost in recreating the product with the fix or redesign. The only significant note is that our costs increase with the time it took us to discover an issue.


### The Design Phase Is The Difference

---

> In manufacturing, the design is only a fraction of the cost but, if it does wrong, it cannot be fixed after it is delivered to customers.

> In software, the design is the most of the cost, and if it goes wrong, we can easily fix it only if we detect it early after it's delivered to customers.

Note:
> In manufacturing, the design is only a fraction of the cost but, if it does wrong, it cannot be fixed after it is delivered to customers.

> In software, the design is the most of the cost, and if it goes wrong, we can fix it quickly only if we detect it early after it's delivered to customers.

We tend to employ an army of people dedicated to working manually on repetitive tasks (e.g., manual testing, deployments, etc.). That is kind of silly, given that we are in the business of writing software that does things and helps others in their daily lives. And yet, we are somehow better at creating software for others, than software that will help us.

But, I might have moved too fast. Let's go back through history and find out how we got where we are, and where should we go next.