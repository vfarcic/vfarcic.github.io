<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Testing In Production

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 1</div>
<div class="label">Hands-on Time</div>

## Installing jx (MacOS)

```bash
brew tap jenkins-x/jx

brew install jx
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 1</div>
<div class="label">Hands-on Time</div>

## Installing jx (Linux)

```bash
mkdir -p ~/.jx/bin

curl -L "https://github.com/jenkins-x/jx/releases/download/$(curl --silent "https://github.com/jenkins-x/jx/releases/latest" | sed 's#.*tag/\(.*\)\".*#\1#')/jx-linux-amd64.tar.gz" | tar xzv -C ~/.jx/bin

export PATH=$PATH:~/.jx/bin

echo 'export PATH=$PATH:~/.jx/bin' >> ~/.bashrc
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 1</div>
<div class="label">Hands-on Time</div>

## Installing jx (Windows)

```bash
choco install jenkins-x
```
