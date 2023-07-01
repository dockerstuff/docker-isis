# Docker-ISIS

Docker container images for planetary data analysis. The original goal of this
repository was/is to define a docker container with USGS/ISIS toolkit pre-set.
So planetary data provided by NASA's Planetary Data System (PDS) could/can be
processed anywhere with Docker installed.

The "ISIS" container is defined in 
[`dockerfiles/isis.dockerfile`](`dockerfiles/isis.dockerfile`):
Notice that other images are defined in [`dockerfiles/`](dockerfiles/):

- `isis`: Jupyter-Lab server with USGS/ISIS install
- `isis-asp`: Extension of `isis` with AMES Stereo Pipeline installed 
- `gispy`: Jupyter-Lab for Python Geographical (GIS) data analysis

The corresponding images can be downloaded from GMAP repository in DockerHub:

- `gmap/jupyter-isis`: latest build of `isis.dockerfile`
- `gmap/jupyter-isis-asp`: latest build of `isis-asp.dockerfile`
- `gmap/jupyter-gispy`: latest build of `gispy.dockerfile`

If you want to *build* your own images, check 
[the README in `dockerfiles/`](dockerfiles/README.md).

ToC:

1. [#how-to-use](#how-to-use)
2. [#contents](#contents)

## How to use

See [*requirements* section](#requirements) if it's your first time here.

Running the container is a two-steps process (`pull` and `run`):

```bash
# Get image from GMAP' DockerHub repository
docker pull gmap/jupyter-isis
```
This downloads (*pulls*) the "isis" image from the repository.

```bash
# And then run it, sharing port '8888' to access the Jupyter Notebook
docker run --rm --name isis_container --port 8888:8888 gmap/jupyter-isis
```
At this point, the containter (`isis_container`) is running and Jupyter-Lab
should be available at `http://localhost:8888`.

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
in the authentication page at `localhost:8888`, or simply copy and paste the
whole "`127.0.0.1`" URL in your browser directly, it will then authenticate
automatically.

### Requirements

* Docker
* ISIS-DATA folder (for v4+) - local or shared folder (e.g. nfs) see [Here](https://github.com/USGS-Astrogeology/ISIS3)

## Contents

This image is a combined build of:

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

### Install 

#### Pull from docker-hub 
**With jupyterlab environment**
```
docker pull hyradus/isis-asp-gispy:standalone-lab
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
