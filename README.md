# USGS ISIS3 Dockerfile

USGS Integrated Software for Imagers and Spectrometers v3 (ISIS3) Docker container.

This (docker) container recipes we provide [here](dockerfile/) is based on
the official [ISIS install document (at Github)](https://github.com/USGS-Astrogeology/ISIS3/blob/dev/README.md#Installation).
ISIS is installed with Conda in its own environment (`isis`) under `/opt/conda`).

The containers are based on [`osgeo/gdal`](https://hub.docker.com/r/osgeo/gdal)
images (by default, the `gdal-ubuntu-small-*`), though you can use the
build-argument (`--build-arg BASE_IMAGE=...`) to specify any other (ubuntu) base image.

> To not conflict with other common commands (e.g., `pip`), conda binary path is positioned at last in
> `$PATH` environment variables. This note is to mind you about paying attention when installing new packages:
> ISIS environment should be managed by `conda` while python packages should be managed by OS' `pip`/`pip3`.

The following [ISIS3 environment variables](dockerfile/etc/isis.sh):

```bash
ISISROOT=/opt/conda
ISISDATA=/isis/data
ISIS3DATA="${ISISDATA}"
ISISTESTDATA=/isis/data_test
```

## Dockerfile.jupyter

The Jupyter-enabled container uses (by default) `jupyter/base-notebook` as
base image (which, by default) uses [`ubuntu:focal`](https://github.com/jupyter/docker-stacks/blob/master/base-notebook/Dockerfile) as base image.
If you want a _jupyter/base-notebook_ based on _osgeo/gdal_ you can do so by
building a _base-notebook_ image based on that just like [we do for the other containers](dockerfile/Dockerfile).
[Here](https://github.com/dockerstuff/docker-stacks/blob/master/base-notebook/build_gdal.sh) is an example of how _I_ do that.


## ISIS3 documentation/resources:

- https://isis.astrogeology.usgs.gov/
- https://github.com/USGS-Astrogeology/ISIS3
- https://astrodiscuss.usgs.gov/


## How to run

If you are familiar with ISIS3 you know that ISIS needs its kernels/ancillary data -- the famous `ISISDATA` -- to do virtually anything.
By default, in `isis3` containers expect to find `ISIS3DATA` mounted at `/isis/data` directory.

> Since "ISISDATA" is not included in the container the user must _mount_ a local copy of "ISISDATA"
> as container's `/isis/data`. The examples below show how to do it.

### ISIS3 command-line

In this example, the location for `ISIS3DATA` in the local/host filesystem is `/path/to/isis3data`.
Running a `isis3` container with the ancillary data (at `/isis/data`):

```bash
$ docker run -it --rm --name isis3 \
    -v "/path/to/isis3data":"/isis/data" \
    my_isis3_container
```

### ISIS3 + GDAL command-line

Let's run the container with GDAL as in `osgeo/gdal`.
ISIS is installed in its own _conda_ environment, separated from the system.

Let's also _bind_ (mount) our current directory (`$PWD`) to container's `/mnt/data`:

```bash
$ docker run -it --rm --name isis3_gdal \
    -v "$PWD":"/mnt/data" \
    -v "/path/to/isis3data":"/isis/data" \
    my_isis3_container:gdal
```

### ISIS3 + Jupyter-Hub

If you would like a graphical interface to use ISIS, GDAL and many Python GIS libraries you should use
the `jupyterhub` tag.
It is based on `chbrandt/gispy:gdal` (which uses `apt`/`pip` as package managers) with Jupyter-Hub
on top. ISIS is installed (as always) in its own conda environment.

```bash
$ docker run -it --rm --name isis3_jupyter \
    -p 8888:8888 \
    -v "$PWD":"/mnt/data" \
    -v "/path/to/isis3data":"/isis/data" \
    my_isis3_container:jupyterhub
```

### Redefining ISIS3 environment variables
> ISIS3 environment variables are defined in container's [/etc/profile.d/isis.sh](dockerfile/etc/isis.sh).

* If you want to customize ISIS3 variables, overwrite the default bash-profile:

```bash
$ docker run -it --name isis3 \
    -v "$PWD/dockerfile/etc/isis.sh":"/etc/profile.d/isis.sh" \
    chbrandt/isis3
```
