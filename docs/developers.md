# Developers

Let's go through the structure of files and workflow on building and releasing
of our (Docker) container images.

- [The images](#the-images)
- [Tags and Versions](#tags-and-versions)
- [Compose and Env files](#compose-and-env-files)
- [Dockerfiles and Packages](#dockerfiles-and-packages)

## The images

[jupyter/minimal-notebook]: https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-minimal-notebook
[jupyter/scipy-notebook]: https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-scipy-notebook

This repo provides three images, the so called "gispy", "isis", and "isis-asp".
All images are based on [Jupyter Docker Stacks](https://github.com/jupyter/docker-stacks);
by default, [jupyter/minimal-notebook][] and [jupyter/scipy-notebook][].
They can be changed as necessary/desired (see following sections).

- **Gispy** image is defined in [`gispy.dockerfile`](/dockerfiles/gispy.dockerfile).
  It provide GIS software such as [GDAL](https://gdal.org) and
  (Python) Cartopy, Geopandas, Shapely, etc. By default, this images is
  built on top of Jupyter' Scipy image.

- **Isis** image is defined in [`isis.dockerfile`](/dockerfiles/isis.dockerfile).
  It is built on top of Jupyter' Minimal Docker image and
  provide [USGS' ISIS toolkit](https://github.com/DOI-USGS/ISIS3).

- **Isis-Asp** image is defined in [`isisasp.dockerfile](/dockerfiles/isisasp.dockerfile).
  It installs [NASA' ASP toolkit](https://github.com/NeoGeographyToolkit/StereoPipeline).


## Tags and Versions

There is no real meaning in tagging this repository with some [semver](https://semver.org/)
syntax (eg, `v2` or `v1.3.7`); it can, though. Any tagging of the repository
will create corresponding (tagged) images and published in DockerHub automatically.

> See document [workflows.md](workflows.md) for details on building/publishing.

It is **recommended** for the tagging of this repository to use a date in the format
`YYYYMMDD` (year-month-day) or some specific event for which some custom
image is necessary (eg, `egu`).
## Compose and Env files

Docker `compose.yml` file has the recipes to `build` each of the (3) images
with default attributes/variables that can be modified through `.env` file.

> Notice that the `compose.yml` and `.env` files are primarily meant for
> templating/simplifying the *build* of image (rather than *running* them).
>
> If you had not yet, go there and have a look on [`compose.yml`](/compose.yml)
> and [`.env`](/.env) files.

In `.env` file we can define any variable used in `compose.yml`, the values
defined there have precedence over the default/fallback ones from `compose`.

Before you wonder about the utility of the variables in `.env` -- *"they are
not very useful"*, you may say; and I would agree in principle -- there use
is just to simplify the building commands and the Github workflow building them.

### ISIS and ASP versions

The versions to install in the images are defined in compose's variables:

- `ISIS_VERSION`
- `ASP_VERSION`

For instance, when you do `docker compose build jupyter-isis`, the `ISIS_VERSION`
defined in `.env` will be used. Likewise for ASP when you build `jupyter-isis-asp`.

### Image names

The names of the images used as *base-image* arguments as well as the output
images are defined in `.env`.


### Building

As explained above, the use of `.env` is to simplify the building through
docker-compose. The building should then call for building each service
individually:

- Build "gispy":
    ```bash
    docker compose build jupyter-gispy
    ```

- Build "isis":
    ```bash
    docker compose build jupyter-isis
    ```

- Build "isis-asp":
    ```bash
    docker compose build jupyter-isis-asp
    ```

## Dockerfiles and Packages

TBD
