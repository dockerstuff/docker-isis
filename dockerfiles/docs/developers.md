# Docker-ISIS3 Developers docs
Set up, building, deployment of USGS ISIS(3) containers.


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
