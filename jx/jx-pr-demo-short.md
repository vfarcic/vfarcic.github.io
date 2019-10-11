<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Working With Pull Requests And Preview Environments

<div class="label">Hands-on Time</div>


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

jx get activity --filter environment-tekton-staging/master --watch

curl "$STAGING_ADDR"
```
