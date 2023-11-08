# Workflows

Github actions (or workflows) are responsible to automate the building and
publishing (on DockerHub) of all three images.

Because we don't want to build/publish images everytime some minor, irrelevant
change happens to the repository (eg, edit README.md), building will happen
only when the repository is *tagged* or a branch *other than `master`* is
modified.

- [Branches and Tags](#branches-and-tags)
- [Variables and Secrets](#variables-and-secrets)

## Branches and Tags

Commits to the `master` branch will NOT trigger the building of images.

What *will* trigger the buillding and (DockerHub) publishing of the images
are new branches and commits to branches *other than `master`*.
The name of the corresponding branch will be used to *tag* the images.

> Eg, suppose you pushed commits in branch named `test`: the new images
> will be tagged `jupyter-gispy:test`, `jupyter-isis:test`, `jupyter-isis-asp:test`.

Analogously, pushing a new tag to Github will trigger the building and publishing
of the images. This time though, the tagging of those images are as follows:

- the *tag* itself (eg, repository tag is "20231031" will tag images `jupyter-isis:20231031`)
- `latest`
- `$ISIS_VERSION` will be used to tag `jupyter-isis` image
- `$ISIS_VERSION-$ASP_VERSION` will be used to tag `jupyter-isis-asp` image

## Variables and Secrets

The [`docker_build.yml`](/.github/workflows/docker_build.yml) workflow
needs two secrets and one variable defined in the scope of the repository:

- variable:
    - `DOCKERHUB_USERNAME`: name of the user *or* organization namespace
      the images will be published in DockerHub (eg, `gmap`)
- secrets:
    - `DOCKERHUB_USERNAME`: name of the user authoring/pushing the images
      (eg, `chbrandt`)
    - `DOCKERHUB_TOKEN`: token associated to the user pushing the images
      (See https://docs.docker.com/security/for-developers/access-tokens/
      for instructions on creating DockerHub access tokens)

> For learning about Github repositories variables and secrets, read:
> - https://docs.github.com/en/actions/learn-github-actions/variables#creating-configuration-variables-for-a-repository
> - https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-a-repository
