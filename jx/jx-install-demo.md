## Hands-On Time

---

# Installing jx


## Installing jx (MacOS)

---

```bash
brew tap jenkins-x/jx

brew install jx
```


## Installing jx (Linux)

---

```bash
mkdir -p ~/.jx/bin

curl -L https://github.com/jenkins-x/jx/releases/download/v1.3.634/jx-linux-amd64.tar.gz | tar xzv -C ~/.jx/bin

export PATH=$PATH:~/.jx/bin

echo 'export PATH=$PATH:~/.jx/bin' >> ~/.bashrc
```


## Installing jx (Windows)

---

```bash
choco install jenkins-x
```


## Getting The Code

---

```bash
git clone https://github.com/vfarcic/k8s-specs.git

cd k8s-specs
```
