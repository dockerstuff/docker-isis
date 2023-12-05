# Docker-ISIS
![build badge](https://github.com/europlanet-gmap/docker-isis/actions/workflows/docker_build.yml/badge.svg)
-----
[Jupyter images]: https://jupyter-docker-stacks.readthedocs.io
Container images for geo-planetary data analysis.

This repository defines a Docker containers with USGS/ISIS and NASA/ASP toolkits
ready for use, as well as a GIS environment based on Python and command-line
tools for either Earth or planetary geo-spatial data processing.

The goal is to remove the time-consuming and error-prone steps on setting up
those data analysis/processing software. Besides optimizing the time spent on
setup, a standard set of images provide reproducible scenario for more
reliable results.

All the (three) images extend on [Jupyter Docker Stacks images][Jupyter images],
meaning they *all provide* a Jupyter Lab interface for high level access to
Python and CLI.

The (Docker) image recipes we provide here are:

- `gispy`: Jupyter-Lab for Geographical (GIS) data analysis with Python
- `isis`: Jupyter-Lab server with USGS/ISIS installed
- `isis-asp`: Extension of `isis` with AMES Stereo Pipeline installed

Ready-for-use images can be downloaded from GMAP repository in DockerHub:

- `gmap/jupyter-gispy`: latest build of `gispy.dockerfile`
- `gmap/jupyter-isis`: latest build of `isis.dockerfile`
- `gmap/jupyter-isis-asp`: latest build of `isis-asp.dockerfile`

Images tree:

    |---------|     ---------
    | Jupyter | --> | gispy |
    | Docker  |     ---------
    | Stacks  |     ---------     ------------
    | images  | --> | isis  | --> | isis-asp |
    |---------|     ---------     ------------

If you want to *build* your own images,
go to [`dockerfiles/README.md`](dockerfiles/README.md).

## How to use it

Since these images are based on [Jupyter images][], running them works
exactly the same:

```bash
docker run -it -p 8888:8888 -e JUPYTER_TOKEN=pass gmap/jupyter-isis
```

> Open a browser window at [http://localhost:8888](http://localhost:8888)
> and type `pass` in the password/token field for the authentication.
> Notice that we used the argument `-e JUPYTER_TOKEN=pass` to set the
> password/token. If you don't use such argument, you should get the
> token value from the (Jupyter) service log from `docker run` command.

Since most of ISIS tools demand the use of ISIS-Data, you need to provide it
by *sharing* a local directory with *ISISDATA* (see [ISIS-Data](#ISIS-Data) below).

Per default, the container images (ie, `jupyter-isis`, `jupyter-isis-asp`) define the
`ISISDATA` variable to:

> **`ISISDATA=/mnt/isis/data`**

Analogously, `ISISTESTDATA` (in case you use) is defined to `/mnt/isis/testdata`.

You will then *bind* your local directory to that of *ISISDATA* inside the image though *docker-run* `-v` option:

```bash
MY_ISIS_DATA="/path/to/my/isis/data/in/your/system"
docker run -it -p 8888:8888 -v $MY_ISIS_DATA:/isis/data gmap/jupyter-isis
```

You can share as many directories as you want (between your computer and
the container) through (multiple) `-v` arguments.
For example, if you want to analyse data there are stored in two different
diretories in your computer -- say, `/path/to/raster` and `/path/to/vector` --,
you can share them with the container like so:

```bash
docker run -it -p 8888:8888 \
    -v /path/to/raster:/home/jovyan/raster \
    -v /path/to/vector:/home/jovyan/vector \
    gmap/jupyter-gispy
```

The "raster" and "vector" (local) directories will be mounted in container's
`/home/jovyan/raster` and `/home/jovyan/vector`, resp.


## ISIS-Data

If using ISIS tools, you'll probably need "`ISISDATA`" (the space-planetary
missions and instruments support data). ISIS-Data is NOT included in the
container(s).

For instructions on obtaining ISIS-Data, see the official docs at:

* https://github.com/DOI-USGS/ISIS3/blob/dev/README.md#The-ISIS-Data-Area

In the next section you'll learn how to use it.
