<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Working With Pull Requests And Preview Environments

<div class="label">Hands-on Time</div>

Note:
Let's see whether we can walk through a full development lifecycle, accomplish all the goals, and not introduce any new user-facing tool. It's only about writing code and interacting with Git. Let's see whether we can do everything without dispurting anyone in any form or way.


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating a PR

```bash
cd jx-go

git checkout -b my-pr

cat main.go | sed -e "s@http example@http PR@g" | tee main.go

git add . && git commit -m "This is a PR"

git push --set-upstream origin my-pr

jx create pullrequest --title "My PR" --body "What I can say?" \
    --batch-mode
```

Note:
I will simulate development of a new feature all the way until it is running in production.

What do we do first?

I'll start by creating a new branch.

Further on, I'll simulate development by changing the output of the application. Since I'm freak about automation and since I love using terminal for almost everything, I'll do that through `sed`.

Now, let's assume that I finished working on the feature. The next step would be to push the changes to Git.

Finally, the last step, is to create a pull request. I'll use a command for that. I already stated that I love doing as much as possible through terminal. Nevertheless, the effect would be the same if I went to GitHub and clicked a few buttons.

Let's open the pull request in browser.


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Merging a PR

* Post a comment with `/meow`
* Post a comment with `/assign @YOUR_GITHUB_USER`
* Post a comment with `/close`
* Post a comment with `/reopen`
* Post a comment with `/lgtm`

```bash
jx get activity --filter jx-go/master --watch

jx get activity --filter environment-jx-demo-staging/master --watch

curl "$STAGING_ADDR"
```

Note:
What do we do when a new pull request is created? Part of the process is automated and Jenkins X is already building, testing, packaging, deploying, and doing all the good things it should do. Nevertheless, there are some manual actions we should perform. Someone might want to review the code and it is a common practice that a PR should be approved before being merged to master.

No matter the process we might adopt for merging pull requests, one thing is almost certain. We want to capture the communication happening during PR reviews. Who is assigned to a PR? What is wrong with the code? Who closed it, and who reopened it?

We could perform some actions, and record the communication separately. But that would be duplication of work. For example, if we write "can you review this PR for me", we should not have to click the "assign" button. The system should be able to figure out that the PR should be assigned. That's where ChatOps comes in. It allows us to convert chat into operations, and operations into chat. It merges the need for actions with the need for traceability.

Let's see it in action. But, before we do, let me stress that, in the interest of being fast, I will skip writing messages like "can you please review this", and jump straight into slash command that the system can interpret.

To begin with, no pull request should be ever reviewed without a kitten. So, let's meow. And we can see, a moment later, that there is a random picture of a kitten. We could woof instead it cats are not your thing, or, if reality is not something you strive for, it could be a unicorn. Anyway, let's get back to the serious part of ChatOps.

Next, we might want to assign it to someone. If I type `/assign @vfarcic`, we can see that's the person the pull request was assigned to. There was no need to click any button nor to select anything from a drop down list.

Next, we'll assumed that `vfarcic` reviewed the code, and commented that the changes are terrible. Imagine that I wrote that text and that it ended with `/close`. As a result, a moment later, the PR was closed automatically.

Similarly, we can `/reopen` it.

There are many other slash commands we could write in our comments, and we don't have time to go through all of them.

Now, all that left is to approve the pull request. We can do that by typing `lgtm` (short for "looks good to me").

The result is probably not what you expected. The system came back to us by creating a new comment statingthat I cannot LGTM my own PR. Though that, we can see that it does not execute the commands blindly, but rather that it is evaluating whether they comply with whichever rules we defined. In this case, it's clear that I would need to assign my PR to someone else.

I'll skip looking for someone else, and merge it manually. That's not what I would normally do, but, in this case, I don't have much time left and there is one more piece of the puzzle I'd like to show.
