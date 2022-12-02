# Dockerized USGS ISIS + NASA Ames Stereo Pipeline + GIS-python + Jupyter lab

This branch contain 

## Requirements

* docker
* ISIS-DATA folder (for v4+) - local or shared folder (e.g. nfs) see [Here](https://github.com/USGS-Astrogeology/ISIS3)

This image is a combined build of:

* USGS ISIS v7.0.0
* NASA AMES Stereo Pipeline (ASP) v3.1.0
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
```
docker pull hyradus/isis-asp-gispy:latest
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
```
docker run -it --rm -e NB_UID=$UID -e NB_GID=$UID -e CHOWN_HOME=yes -e CHOWN_HOME_OPTS='-R' --user root -v path-to-data-folder:/home/Data -v path-to-isis-data-folder:/isis/data -p 8888:8888 hyradus/isis-asp-gispy:latest

```
Mount a host-folder to the container

## TO-DO
