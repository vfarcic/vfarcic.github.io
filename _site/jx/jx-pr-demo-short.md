## Hands-On Time

---

# Creating And Previewing Pull Requests


## Creating a PR

---

```bash
cd jx-go

git checkout -b my-pr

cat main.go | sed -e "s@http example@http PR@g" | tee main.go

git add . && git commit -m "This is a PR"

git push --set-upstream origin my-pr

jx create pullrequest --title "My PR" --body "What I can say?" \
    --batch-mode
```


## Merging a PR

---

* Post a comment with `/meow`
* Post a comment with `/assign @YOUR_GITHUB_USER`
* Post a comment with `/close`
* Post a comment with `/reopen`
* Post a comment with `/lgtm`

```bash
jx get activity -f jx-go/master -w

curl "$STAGING_ADDR"
```
