# Developers

Let's go through the structure of files and workflow on building and releasing
of our (Docker) container images.

- [The images]()
- [Compose and Env files]()
- [Dockerfiles and Packages]()
- [Github Actions and Versions]()

# The images

[jupyter/minimal-notebook]: https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-minimal-notebook
[jupyter/scipy-notebook]: https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-scipy-notebook

This repo focuses on setting up/building three images, the so called "gispy",
"isis", and "isis-asp".
*All* images are based on [Jupyter Docker Stacks](https://github.com/jupyter/docker-stacks),
by default, either the [jupyter/minimal-notebook][]
or [jupyter/scipy-notebook][].
Although they can be changed as necessary/desired (see following sections).

- **Gispy** image is defined in [`gispy.dockerfile`](/dockerfiles/gispy.dockerfile).
  It provide GIS software such as [GDAL](https://gdal.org) and
  (Python) Cartopy, Geopandas, Shapely, etc. By default, this images is
  built on top of Jupyter' Scipy image.

- **Isis** image is defined in [`isis.dockerfile`](/dockerfiles/isis.dockerfile).
  It is built on top of Jupyter' Minimal Docker image and
  provide [USGS' ISIS toolkit](https://github.com/DOI-USGS/ISIS3).

- **Isis-Asp** image is defined in [`isisasp.dockerfile](/dockerfiles/isisasp.dockerfile).
  It installs [NASA' ASP toolkit](https://github.com/NeoGeographyToolkit/StereoPipeline).

## Compose and Env files

Docker `compose.yml` file has the receipes to `build` each of the (3) images
with default attributes/variables that can be modified through `.env` file.

Notice that the `compose.yml` and `.env` files are primarily meant for
templating/simplifying the *build* of image (rather than the *run* of them).

> If you had not yet, go there and have a look on [`compose.yml`](/compose.yml)
> and [`.env`](/.env) files.




## USGS/ISIS containers
ISIS containers have ISIS(3) installed as in the official repository,
https://github.com/USGS-Astrogeology/ISIS3.
It uses `conda` to have ISIS installed under a (`isis`) named virtual environment.

The container (image) is build on top of (some) [osgeo/gdal](https://hub.docker.com/r/osgeo/gdal).
Typically, the `small` version of the latest tagged version (as of now,
`osgeo/gdal:ubuntu-small-3.4.0`).
OSGEO tends to use the latest Ubuntu LTS, currently: `ubuntu:20.04`.


### ISIS versions
Specification of ISIS version (3, 4, or 5) is possible during the building
through `--build-arg ISIS_VERSION=5` (for example, to install the latest).
The default is `3`.
See the [Dockerfile](/dockerfile/Dockerfile) for details.


## Jupyter containers
Long story short, Jupyter containers have to come from an
[official Jupyter image](https://hub.docker.com/u/jupyter),
default is `jupyter/base-notebook`.
The official containers setup is set properly for
[JupyterHub spawners](https://jupyterhub.readthedocs.io/en/stable/reference/spawners.html)
which simplifies a lot the adoption of _DockerSpawner_, for instance.

There is one issue, though: we can only use _one_ base image to our ISIS3
container, either "gdal" or "jupyter".
Thankfully, `osgeo/gdal` and `jupyter/*-notebook` are both descendants from
`ubuntu:20.04` (see [gdal](https://github.com/OSGeo/gdal/blob/master/docker/ubuntu-small/Dockerfile) and [base-notebook](https://github.com/jupyter/docker-stacks/blob/master/base-notebook/Dockerfile)).
Which allows us to rebuild one of them based on the other.
It seems better to me to rebuild the Jupyter container from an OSGEO image,
and then put ISIS on top.


### Jupyter-GDAL container
Basically, what we want to do is in the following branch of [jupyter/docker-stack](
https://github.com/dockerstuff/docker-stacks/blob/master/base-notebook/build_gdal.sh
) build script:

```bash
$ cd docker-stacks/base-notebook
$ docker build -t jupyter:gdal --build-arg ROOT_CONTAINER='osgeo/gdal:ubuntu-small-3.4.0' .
```


### Jupyter-ISIS container
Then, we build ISIS container using the just built `jupyter_gdal` as
`Dockerfile.jupyter` base image:

```bash
$ cd dockerfile
$ docker build -t jupyter:isis --build-arg BASE_IMAGE'jupyter:gdal' \
          -f Dockerfile.jupyter .
```
