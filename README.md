# Automatic update of Gitea
We write a script in order to keep our Gitea instance up to date automatically
by downloading the latest release from Github.

## Getting the latest release of Gitea through the Github API
As indicated in [1], we can use the github API in order to have a parsable
document containing the download links to the files we want.

`https://api.github.com/repos/go-gitea/gitea/releases/latest` points to the
latest release. In it, we can extract the download URL for all the assets of
this particular release. It is listed under `assets_url`. We get the link with
the one-liner provided in [1]:

```shell
curl -s https://api.github.com/repos/go-gitea/gitea/releases/latest 
| grep assets_url | cut -d '"' -f 4
```

We can then follow the link to the assets list. The download links for each
asset are listed under `browser_download_url`. We can get the list of all links
with:

```shell
curl -s https://api.github.com/repos/go-gitea/gitea/releases/latest 
| grep assets_url | cut -d '"' -f 4 | xargs curl -s | grep browser_download_url
```

`grep`ing for `linux-amd64.xz` returns the download links for the compressed
binary and its signatures. Which we can parse with `cut`.

```shell
curl -s https://api.github.com/repos/go-gitea/gitea/releases/latest 
| grep assets_url | cut -d '"' -f 4 | xargs curl -s | grep browser_download_url 
| grep linux-amd64.xz | while read line ; do echo $line | cut -d '"' -f 4 ; done
```

We can then pipe the links to `wget`:

```shell
curl -s https://api.github.com/repos/go-gitea/gitea/releases/latest 
| grep assets_url | cut -d '"' -f 4 | xargs curl -s | grep browser_download_url
| grep linux-amd64.xz | while read line ; do echo $line | cut -d '"' -f 4 ; done
| xargs wget -q
```

And with this, we're done, we should have downloaded:
* gitea-x.x.x-linux-amd64.xz
* gitea-x.x.x-linux-amd64.xz.asc
* gitea-x.x.x-linux-amd64.xz.sha256

## Verifying the signatures


## References
1. https://stackoverflow.com/questions/24987542/is-there-a-link-to-github-for-downloading-a-file-in-the-latest-release-of-a-repo

