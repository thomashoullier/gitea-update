# Automatic update of Gitea
We write a script in order to keep our Gitea instance up to date automatically
by downloading the latest release from Github.

## Getting the latest release of Gitea through the Github API
As indicated in [1], we can use the github API in order to have a parsable
document containing the download links to the files we want.

''https://api.github.com/repos/go-gitea/gitea/releases/latest'' points to the
latest release. In it, we can extract the download URL for all the assets of
this particular release. It is listed under ''assets_url''.

## References
1. https://stackoverflow.com/questions/24987542/is-there-a-link-to-github-for-downloading-a-file-in-the-latest-release-of-a-repo

