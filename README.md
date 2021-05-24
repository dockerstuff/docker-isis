# USGS ISIS3 Dockerfile

USGS Integrated Software for Imagers and Spectrometers v3 (ISIS3) Docker container.

This (docker) container definition we provide [here](dockerfile/Dockerfile) is based on [ISIS install document (at Github)](https://github.com/USGS-Astrogeology/ISIS3/blob/dev/README.md#Installation).
ISIS is installed with Conda in its own environment (`isis`) under `/opt/conda`).

> To not conflict with other common commands (e.g., `pip`), conda binary path is positioned at last in
> `$PATH` environment variables. This note is to mind you about paying attention when installing new packages:
> ISIS environment should be managed by `conda` while python packages should be managed by OS' `pip`/`pip3`.

ISIS3 documentation/resources:

- https://isis.astrogeology.usgs.gov/
- https://github.com/USGS-Astrogeology/ISIS3
- https://astrodiscuss.usgs.gov/


## Containers

The images built from the [dockerfile](dockerfile/) can be found at the [DockerHub](https://hub.docker.com/r/chbrandt/isis3).
The following tags are defined:

* `chbrandt/isis3:latest`: based on `ubuntu:20.04` (as in [osgeo/gdal](https://github.com/OSGeo/gdal/blob/master/gdal/docker/ubuntu-full/Dockerfile))
* `chbrandt/isis3:gdal`: based on [`osgeo/gdal`](https://hub.docker.com/r/osgeo/gdal)
* `chbrandt/isis3:gispy`: based on [`chbrandt/gispy:gdal`](https://hub.docker.com/r/chbrandt/gispy)
* `chbrandt/isis3:jupyterhub`: [jupyter-hub install](https://github.com/chbrandt/docker-jupyterhub/blob/main/dockerfile/Dockerfile) on top of "isis3:gispy"

The container has the following [ISIS3 environment variables](dockerfile/etc/isis.sh):

```bash
ISISROOT=/opt/conda
ISISDATA=/isis/data
ISIS3DATA="${ISISDATA}"
ISISTESTDATA=/isis/data_test
```


## Run

If you are familiar with ISIS3 you know that ISIS needs its kernels/ancillary data -- the famous `ISISDATA` -- to do virtually anything.
By default, in `isis3` containers `ISIS3DATA` is expected to be found at `/isis/data` directory.

> Since "ISISDATA" is not included in the container the user must _mount_ a local copy of "ISISDATA"
> as container's `/isis/data`. The examples below show how to do it.

### ISIS3 command-line

In this example, the location for `ISIS3DATA` in the local/host filesystem is `/path/to/isis3data`.
Running a `isis3` container with the ancillary data (at `/isis/data`):

```bash
$ docker run -it --rm --name isis3 \
    -v "/path/to/isis3data":"/isis/data" \
    chbrandt/isis3
```

### ISIS3 + GDAL command-line

Let's run the container with GDAL as in `osgeo/gdal`. 
ISIS is installed in its own _conda_ environment, separated from the system.

Let's also _bind_ (mount) our current directory (`$PWD`) to container's `/mnt/data`:

```bash
$ docker run -it --rm --name isis3_gdal \
    -v "$PWD":"/mnt/data" \
    -v "/path/to/isis3data":"/isis/data" \
    chbrandt/isis3:gdal
```

### ISIS3 + Jupyter-Hub command-line

If you would like a graphical interface to use ISIS, GDAL and many Python GIS libraries you should use
the `jupyterhub` tag.
It is based on `chbrandt/gispy:gdal` (which uses `apt`/`pip` as package managers) with Jupyter-Hub
on top. ISIS is installed (as always) in its own conda environment.

```bash
$ docker run -it --rm --name isis3_jupyter \
    -p 8000:8000 \
    -v "$PWD":"/mnt/data" \
    -v "/path/to/isis3data":"/isis/data" \
    chbrandt/isis3:jupyterhub
```

### Redefining ISIS3 environment variables
> ISIS3 environment variables are defined in container's [/etc/profile.d/isis.sh](dockerfile/etc/isis.sh).

* If you want to customize ISIS3 variables, overwrite the default bash-profile:

```bash
$ docker run -it --name isis3 \
    -v "$PWD/dockerfile/etc/isis.sh":"/etc/profile.d/isis.sh" \
    chbrandt/isis3
```

* If you're running the `jupyterhub` image, it comes with Jupyterhub:
