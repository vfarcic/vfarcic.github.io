<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Apps Need To Be Developed

<div class="label">Hands-on Time</div>


## Apps Need To Be Developed

```bash
cd ../silly-demo

cat okteto.yaml

okteto context use

# Choose `a-team-gke`

okteto up --namespace dev

ls -1

go run .
```


## Apps Need To Be Developed

```bash
# In a separate terminal session
curl -X POST "localhost:8080/video?id=wNBG1-PSYmE&title=Kubernetes%20Policies%20And%20Governance%20-%20Ask%20Me%20Anything%20With%20Jim%20Bugwadia"

# In a separate terminal session
curl -X POST "localhost:8080/video?id=VlBiLFaSi7Y&title=Scaleway%20-%20Everything%20We%20Expect%20From%20A%20Cloud%20Computing%20Service%3F"

# In a separate terminal session
curl "localhost:8080/videos" | jq .

# ctrl+c

exit

okteto destroy --namespace dev
```


## Permanent Environments

# Use GitOps
