<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Promoting Releases To Production

<div class="label">Hands-on Time</div>

Note:
We're almost finished. We developed a new feature, we created a pull request, and we let Jenkins X build it, test, deploy it to a temporary environment, and do whatever else we should do automatically. We reviewed it, we approved it, and we merged it to the master branch. As you already know, the staging environment is already configured to have automated promotions, so the new release should already be running in staging. After we merged the changes, Git notified the cluster and, as a result, Jenkins X run a pipeline that executed all the steps we need to run before and after deploying to staging. All that is left is to use to promote it to production.


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Promoting To Production

```bash
jx get applications -e production

jx get applications -e staging

VERSION=[...]

jx promote jx-go --version $VERSION --env production --batch-mode
```

Note:
Let's see what's running in production right now.

Don't be confused by seeing `jx-go`. Even though it is listed, there is no release number, meaning that not a single release of that application was deployed to production.

For us to promote a release of an application, we need to know the version that we want to promote. Assuming that we want to move forward the one currently running in staging, we can get the required info from there.

We can see that the release `0.0.2` of `jx-go` is currently running in the staging environment. Let's promote that one to production by executing `jx promote`.

Now, you might be expecting that command to deploy the release to production. But that is not what it's doing. Instead, it created a pull requests with the changes to the repository that holds the desired state of the production environment. Then, it waits until that pull requests it processed by monitoring the pipeline run initiated by the creation of that PR.

Let's open that pull request and see what's inside.
 
Two files were changed and most of the differences are related to re-formatting the information. They are not important. What matters is that the pull request added `jx-go` version `0.0.2` to the list of the dependencies.

Once the pipeline is successful, it merged the pull request. That springs up yet another pipeline which will converge the actual into the desired state of the production environment. Since we added a specific release of `jx-go` to the list of dependencies, it will soon be running in production.


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Promoting To Production

```bash
jx get applications --env production

PROD_ADDR=[...]

curl "$PROD_ADDR"

cd ..
```

Note:
Let's output again the list of the applications running in production.

We can see that the release `0.0.2` of `jx-go` is still not running. That probably means that the pipeline did not yet finished executing, so we'll wait for a few moments.

Waiting... And waiting... And waiting...

Let's try again.

This time, we can see that `jx-go` is running in production.

To be on the safe side, I'll copy the auto-generated address of the application, and send a request.

Now only that we received the output but, judging by the message, we can confirm that it comes from the release `0.0.2`.

Hurray!

Now, think about all that. Imagine that Jenkins X does not exist. How would you design the whole system in a way that not a single new user-facing tool is introduced? How would you help you developers to continue doing what they do best (to write code) and to use the tools they know (like Git), while still providing all the automated processes they need? How long would it take you to pick all the right tool, to create all the definition, and to write a pipeline that ties all that together into a single GitOps process? If the answer is "more time than I would like to spend", then Jenkins X might be a good platform to try.

There is much more to Jenkins X than what I just presented. Nevertheless, even this small demonstration show the power and the simplicity it combines.
