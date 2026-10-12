<!-- .slide: id="cleanup-jfrog" -->
## Cleanup

```sh
cd ../dot-agent-deck

git worktree remove --force ../dot-agent-deck-jfrog

git branch --force demo/jfrog-curation origin/demo/jfrog-curation

npm config delete //devreleplus.jfrog.io/artifactory/api/npm/dot/:_authToken
```

Note:
Run on the laptop after the talk or a rehearsal, from the demo worktree. Removing the worktree discards the demo's uncommitted changes. Resetting demo/jfrog-curation to the pushed branch drops anything the agent committed onto it, so the next run still starts with the vulnerable axios. Close any pull request the agent opened from the demo without merging it, and delete the agent's branch, so nothing from the JFrog setup reaches main. The last command removes the JFrog token from the user-level ~/.npmrc; before setup, the laptop had no ~/.npmrc.
