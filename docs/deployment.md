# Deployment

[1]: https://jupyter-docker-stacks.readthedocs.io
[2]: https://github.com/jupyter/docker-stacks

The (Docker) images we build here are custom versions of Jupyter' Docker Stacks
([1][], [2][]).
Since they expand (with packages and some extensions) the Jupyter images,
their deployment works pretty much the same.

> In principle, as of this writting, our images are being published on
> DockerHub; this is one difference respect to Jupyter's (using Quay.io).
> See the [Developers](developers.md) document for release/publishing details.

**Necessarily** -- to access the Jupyter (Lab) interface --, when you
"docker-run" an image you want to **share container's port `8888`**.

*Optionally*, you may want to simplify the *login* process by defining a
*password* through the `JUPYTER_TOKEN` (container) environment variable.

> See https://jupyter-docker-stacks.readthedocs.io/en/latest/index.html#quick-start
> for general instructions on running Jupyter Docker images.

When running an **ISIS** images (ie, `jupyter-isis`, `jupyter-isis-asp`),
you (likely) *want to* mount the **ISIS-Data** directory (from host system)
in the container's `ISISDATA=/isis/data`.

> See https://github.com/DOI-USGS/ISIS3/blob/dev/README.md#The-ISIS-Data-Area
> for current ways of getting ISIS-Data.

## Docker-Compose

The primary purpose of the [`compose.yml`](/compose.yml) in this repository
is to provide a default building (template) for the images we offer, and
-- secondarily -- to provide examples for running them (ports, volumes, etc.).

The Compose file is *NOT* meant to be used simply as `docker compose up`,
simply because the (three) services defined there are NOT meant to run
simultaneously!
Nevertheless, you can -- YES -- use it to run each service individually.

For example (notice the service-name after `up`):

```bash
docker compose up jupyter-isis
```

THe building and further customization of the images/services is explained
in document [Developers](developers.md).
