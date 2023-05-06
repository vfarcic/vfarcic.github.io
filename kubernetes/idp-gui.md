# Graphical User Interface


<!-- .slide: data-background-image="../img/products/port.png" data-background-size="contain" -->


# Port

```bash
# Open https://app.getport.io/dev-portal in a browser

cat port/environment-blueprint.json

# Copy the output

# `+ Add` > `Custom blueprint`
# Replace the default JSON with the one from the output.
# Click the `Save` button.
```


# Port

```bash
cat port/backend-app-blueprint.json

# Copy the output

# `+ Add` > `Custom blueprint`
# Replace the default JSON with the one from the output.
# Click the `Save` button.
```


# Port

```bash
# Click the "Help" item from the left-hand menu and select
#   "Credentials".

# Replace `[...]` with the "Client ID"
export CLIENT_ID=[...]

# Replace `[...]` with the "Client Secret"
export CLIENT_SECRET=[...]

cat argocd/port.yaml | sed -e "s@CLIENT_ID@$CLIENT_ID@g" \
    | sed -e "s@CLIENT_SECRET@$CLIENT_SECRET@g" \
    | tee infra/port.yaml
```


# Port

```bash
git add .

git commit -m "Port"

git push
```


# Port

```bash
cat port/backend-app-action.json

# Copy the output

# Select `...` in the `Backend App` > `Actions`
# Replace the default JSON with the one from the output.
# Click the `Save` button.
```


# Checklist

* ~Control plane~
* ~User-friendly interfaces~
* ~Syncronization From Git With GitOps~
* ~Schema management~
* ~Secrets management~
* ~Graphical User Interface (GUI)~
* CI/CD Pipeline
