## Setup

```bash
# Minikube: https://gist.github.com/2a6e5ad588509f43baa94cbdf40d0d16

git clone \
    https://github.com/vfarcic/devops-catalog-code.git

cd devops-catalog-code

kubectl create namespace argocd

helm repo add argo \
    https://argoproj.github.io/argo-helm

helm upgrade --install \
    argocd argo/argo-cd \
    --namespace argocd \
    --version 1.6.2 \
    --set server.ingress.hosts="{argocd.$INGRESS_HOST.xip.io}" \
    --values argo/argocd-values.yaml \
    --wait

export PASS=$(kubectl --namespace argocd \
    get pods \
    --selector app.kubernetes.io/name=argocd-server \
    --output name \
    | cut -d'/' -f 2)

argocd login \
    --insecure \
    --username admin \
    --password $PASS \
    --grpc-web \
    argocd.$INGRESS_HOST.xip.io

echo $PASS

argocd account update-password

open http://argocd.$INGRESS_HOST.xip.io

cd ../

mkdir argocd-15-min

cd argocd-15-min

mkdir helm

echo "apiVersion: v1
description: Production environment
name: devops-toolkit
version: \"1.0.0\"" | tee helm/Chart.yaml

mkdir helm/templates

echo "apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: devops-toolkit
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  source:
    path: helm
    repoURL: https://github.com/vfarcic/devops-toolkit.git
    targetRevision: HEAD
    helm:
      values: |
        image:
          tag: latest
        ingress:
          host: devops-toolkit.$INGRESS_HOST.xip.io
      version: v3
  destination:
    namespace: production
    server: https://kubernetes.default.svc
  syncPolicy:
    automated:
      selfHeal: true
      prune: true" | tee helm/templates/devops-toolkit.yaml

cat helm/templates/devops-toolkit.yaml \
    | sed -e "s@devops-toolkit@devops-paradox@g" \
    | tee helm/templates/devops-paradox.yaml

echo "apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: production
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  source:
    path: helm
    repoURL: https://github.com/vfarcic/argocd-15-min.git
    targetRevision: HEAD
  destination:
    namespace: production
    server: https://kubernetes.default.svc
  syncPolicy:
    automated:
      selfHeal: true
      prune: true" | tee apps.yaml

git init

gh repo create --public --confirm

git add .

git commit -m "Initial commit"

git push --set-upstream origin master
```

## Do

### The Objectives And The Principles Behind GitOps

GitOps assumes that a version control system (VCS) is the only source of truth. But, since all version controls worth talking about are based on Git, the name is GitOps and not VCSOps. Therefore, I'll start using Git instead of VCS throughout the rest of this expose even though, theoretically, you could apply GitOps principles with, let's say, SVN or Perforce. You would need to put extra effort, but it is doable.

What does it mean that Git is the only source of truth? To many, that sounds like a question with an obvious answer. Yet, many are not really applying that seemingly simple logic. So, let's start with a simple question. Why would Git be the only source of truth?

Everything we do today is **defined as code**, at least among software engineers. Now, before you start wondering what a software engineer is, let me give a simple definition. If your work is related to the development of software, you are a software engineer. It does not matter whether you write code of an application, if you are testing, if you are deploying apps, working on infrastructure, or operating a system. You are a software engineer and, as such, you write code.

What you are not doing is clicking buttons. You do not execute all the tests manually by clicking links and filling in fields on a web page. You are not managing infrastructure through some UI. If you are doing stuff without writing code, you are in the wrong industry. You should write code. Actually, that is not correct. You **MUST be writing code**, or consider a different profession. You are hopefully young and, if code scares you, there is still time to change your calling. You can become a lawyer, a real estate agent, or whatever makes you more comfortable. If you choose to stay in the software industry, you are choosing to write code.

The only acceptable usage of UIs is for informational purposes. They are useful when observing the state of something. They are great for correlating metrics through dashboards. They are helpful when searching through logs to find the cause of an issue. But, when it comes to defining something, we write code instead of clicking buttons.

Code can be many different things, and people differ in their interpretation of what is and what isn't code. So, let me simplify that for you. Code is something that can be interpreted by machines. If you write applications in Java, Go, Python, or any other programming language, you are writing code. That much is clear, isn't it? If you are writing executable tests, they are code as well. If you are writing build scripts, they are also code. Heck, even if all you do is write YAML files, that's also code. If it can be interpreted by machines, it is code.

Now that we established that everyone, you included, either writes code or is planning to change the profession, the logical outcome is that all that is stored in a version control system and that the only one that makes sense today is Git. If everything we do related to machines is defined as code, and all the code is stored in Git, it stands to reason that **Git is the only source of truth**.

The code of our applications is in Git, the tests are in Git, the configurations are in Git, and everything else is in Git. Even the documentation is today stored in Git so that machines can convert it into HTML, PDFs, or whichever other formats our users expect.

That means that, among other things, the full definition of any aspect of our systems is in Git. So, how do we operate the systems? By making changes to Git. Hence, the expression GitOps means that the operations are performed through Git.

So, the two fundamental principles of GitOps are:

* Everything is described as code
* Git is the only source of truth

All that means is that **we (humans) are defining the desired state**, while machines are making sure that the actual state becomes the same as the desired one. **Machines are converging the actual into the desired state.** As a result, **you are not touching clusters**, especially production. All you can and should do is change the desired state by modifying files and pushing those changes to Git.

### The Demo

```bash
kubectl create namespace production

cat helm/templates/devops-toolkit.yaml

cat helm/templates/devops-paradox.yaml

cat apps.yaml

kubectl apply --filename apps.yaml

open http://argocd.$INGRESS_HOST.xip.io

open http://devops-toolkit.$INGRESS_HOST.xip.io

cat helm/templates/devops-toolkit.yaml \
    | sed -e "s@latest@2.9.17@g" \
    | tee helm/templates/devops-toolkit.yaml

git add .

git commit -m "New release"

git push

watch 'kubectl --namespace production get \
    deployment devops-toolkit-devops-toolkit \
    --output jsonpath="{.spec.template.spec.containers[0].image}"'
```

### Diagram

## Destroy

```bash
minikube delete

gh repo view

# Delete the repo

cd ..

rm -rf argocd-15-min
```
