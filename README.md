# Docker-ISIS

Docker container images for planetary data analysis. 
This repository defines a docker container with USGS/ISIS toolkit pre-set.
So planetary data provided by NASA's Planetary Data System (PDS) could/can be
processed anywhere with Docker installed.

Around the ISIS image there is "Gispy" and "ISIS-ASP". The former is an
image with GIS Python packages to provide a modern data analysis environment
based on Jupyter Notebooks. Per default, Gispy is based on `jupyter/scipy-notebook`.
The latter, ISIS-ASP, extends "ISIS" with Ames Stereo Pipeline.
Finally, the ISIS image is an extention of Gispy, with the USGS/ISIS installed.

Images tree:

    ---------     --------     ------------
    | gispy | --> | isis | --> | isis-asp |
    ---------     --------     ------------


The "ISIS" container is defined in 
[`dockerfiles/isis.dockerfile`](`dockerfiles/isis.dockerfile`),
next to the other images (in [`dockerfiles/`](dockerfiles/)):

- `gispy`: Jupyter-Lab for Python Geographical (GIS) data analysis
- `isis`: Jupyter-Lab server with USGS/ISIS install (based in `gispy`)
- `isis-asp`: Extension of `isis` with AMES Stereo Pipeline installed 

The corresponding images can be downloaded from GMAP repository in DockerHub:

- `gmap/jupyter-gispy`: latest build of `gispy.dockerfile`
- `gmap/jupyter-isis`: latest build of `isis.dockerfile`
- `gmap/jupyter-isis-asp`: latest build of `isis-asp.dockerfile`

If you want to *build* your own images, check 
the *readme* in `dockerfiles/`](dockerfiles/README.md).

ToC:

1. [How to use](#how-to-use)
2. [Contents](#contents)


## How to use

> If it's your first time here, you may want to check the 
[*requirements* section](#requirements) first.

Running the container is a two-steps process:

- *Pull* (or *download*) the image:
```bash
docker pull gmap/jupyter-isis
```


- And *run* it. Pay attention to the `--port` argument:
```bash
docker run --rm --port 8888:8888 gmap/jupyter-isis
```

> The `--port` argument is necessary because the interface we are going to 
> use -- Jupyter-Lab -- is accessible through our host's port `8888`.
>
> The other argument, `--rm` is responsible for automatic remove of of
> the container when you finish using it. 

At this point, "Jupyter-ISIS" containter is running and Jupyter-Lab
should be available at `http://localhost:8888`.
You can copy-and-paste this URL in a new web-browser windows and the
the login page of a Jupyter-Lab instance.

There are two ways you can authenticate and login a Jupyter-Lab instance
like this one: (1) the default one where you get the random *token* (*ie*, password)
Jupyter generated for you, or (2) you define the password beforehand.

### Get *token* from terminal

If you go straight to [http://localhost:8888](http://localhost:8888) you'll
notice a *passphrase* or *token* is required. 
Such information you find in the output from the latest command, `docker-run`,
you should see something *like*:

```
    To access the server, open this file in a browser:
        file:///home/jovyan/.local/share/jupyter/runtime/jpserver-7-open.html
    Or copy and paste one of these URLs:
        http://51476fe2885f:8888/lab?token=19aa3371154d1a74d726c2b422fd134ac881827b44e69d40
        http://127.0.0.1:8888/lab?token=19aa3371154d1a74d726c2b422fd134ac881827b44e69d40
```
The value of `token` is unique to each (run) session, you can copy-and-paste
the token string (eg, `19aa3371154d1a74d726c2b422fd134ac881827b44e69d40`)
in the authentication page at `localhost:8888`.

### Define *password* beforehand

When instanciating the container (*ie*, when `docker-run` is executed)
you can define an environment variables in `gmap/jupyter-isis`.
The variable responsible for Jupyter-Lab password is `JUPYTER_TOKEN`,
the value you define for this variable will be the login password.

For example,
```bash
docker run --name isis_tmp --port 8888:8888 -e JUPYTER_TOKEN='bla' gmap/jupyter-isis
```
will define `bla` as password for this (`isis_tmp`) container.
You can now go to `http://localhost:8888` and type `bla` in the corresponding
field there.
You should then be redirected to a Jupyter-Lab workspace.

### Requirements

* Docker
* ISIS-DATA folder (for v4+) - local or shared folder (e.g. nfs) see [Here](https://github.com/USGS-Astrogeology/ISIS3)

## Contents

```bash
$ docker run -it --rm --name isis3 \
    -v "/path/to/isis3data":"/isis/data" \
    my_isis3_container
```

* USGS ISIS v7.2.0
* NASA AMES Stereo Pipeline (ASP) v3.2.0
* jupyter-stack/base-notebook  
* GISPY image containing several common used python package for processing planetary images and GIS data (e.g. rasterio, spectral, fiona, shapely) and various utilities (e.g. numpy, matoplotlib, pandas, scikit-image, etc)

Then ISIS v7 can be used in jupyterlab terminal or jupyter noteboo through [kalasiris](https://github.com/rbeyer/kalasiris) package by adding in the first cell of the notebook the following code:
```
import os
os.environ["ISISROOT"]="/opt/conda/envs/isis/"
os.environ["ISISDATA"]="/isis/data"
import kalasiris as isis
```
For an example notebook see [PyISIS-Parallel](https://github.com/Hyradus/PyISIS-Parallel/tree/main/PyISIS-Parallel)

## ISIS-DATA

ISIS-DATA must be mounted to **/isis/data** 

## Persistent Data

## How-To

```bash
$ docker run -it --rm --name isis3_jupyter \
    -p 8888:8888 \
    -v "$PWD":"/mnt/data" \
    -v "/path/to/isis3data":"/isis/data" \
    my_isis3_container:jupyterhub
```

**Without jupyterlab environment**
```
docker pull hyradus/isis-asp-gispy:standalone-native
```

#### Build the image from scratch

1) Clone [this](https://github.com/europlanet-gmap/docker-isis3.git) repository and enter the main folder
2) Switch to standalone branch
```
git checkout standalone
```
4) Make the main scripts executable
```
chmod +x script/ImageBuilder.sh
```
4) Run the installer
```
./ImageBuilder.sh
```

#### Run the container
* dockerhub 
```
docker run -it --rm -e NB_UID=$UID -e NB_GID=$UID -e CHOWN_HOME=yes -e CHOWN_HOME_OPTS='-R' --user root -v path-to-data-folder:/home/Data -v path-to-isis-data-folder:/isis/data -p 8888:8888 hyradus/isis-asp3-gispy:standalone-lab

```

* built from scratch 
```
docker run -it --rm -e NB_UID=$UID -e NB_GID=$UID -e CHOWN_HOME=yes -e CHOWN_HOME_OPTS='-R' --user root -v path-to-data-folder:/home/Data -v path-to-isis-data-folder:/isis/data -p 8888:8888 isis-asp3-gispy:standalone-lab
```
Mount a host-folder to the container

## TO-DO
_____________________
This study is within the Europlanet 2024 RI and EXPLORE project, and it has received funding from the European Union’s Horizon 2020 research and innovation programme under grant agreement No 871149 and No 101004214.
