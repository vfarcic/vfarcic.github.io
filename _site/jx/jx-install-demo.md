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

curl -L https://github.com/jenkins-x/jx/releases/download/v2.0.100/jx-linux-amd64.tar.gz | tar xzv -C ~/.jx/bin

export PATH=$PATH:~/.jx/bin

echo 'export PATH=$PATH:~/.jx/bin' >> ~/.bashrc
```


## Installing jx (Windows)

---

```bash
choco install jenkins-x
```
