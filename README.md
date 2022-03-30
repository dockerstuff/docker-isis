# Docker JupyterHub + DockerSpawner with GitHub/GitLab OAuth + USGS ISISv5-ASP3+JupyterLab

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6396321.svg)](https://doi.org/10.5281/zenodo.6396321)

_________________________________________________________________________________________
This repository contain all the configuration files to build and deploy a containerized JupyterHub wich deploy singleuser USGS ISIS5-ASP3-GISPY + JupyterLab instances in separate containers using DockerSpawner authenticated with GitHub or GitLab OAuth and allowed users configuration file.

Derived from [jupyterhub/jupyterhub-deploy-docker](https://github.com/jupyterhub/jupyterhub-deploy-docker) and [docker-isis](https://github.com/europlanet-gmap/docker-isis3), [docker-gispy](https://github.com/europlanet-gmap/docker-gispy) and [docker-jupyterhub](https://github.com/europlanet-gmap/docker-jupyterhub)


## Structure

<img src="ReadmeImages/scheme.png?raw=true" alt="Test Example"
	title="Test Example" width="1000"/>

## Requirements

* docker
* GitHub/GitLab app for authentication see [Here](https://docs.github.com/en/developers/apps/building-github-apps/creating-a-github-app)
* ISIS-DATA folder (for v4+) - local or shared folder (e.g. nfs) see [Here](https://github.com/USGS-Astrogeology/ISIS3)

## How-To

1) Clone this repository and enter the main folder
2) EDIT env_example and rename as .env )


*Basic .env variables*
```
### JupyterHUB variables

## Docker network
NETWORK='jupyterhub-network'

## Volumes Names
JHDATA='jupyterhub-data'
JHDB='jupyterhub-sqldata'
ISISDATA='isis-data'
SHARED='shared-data'

## Volumes Paths
JHDATA_PATH='/mnt/DATS-EXT4/docker-vols/hub-data-vol'
JHDB_PATH='/mnt/DATS-EXT4/docker-vols/hub-db-vol'
ISISDATA_PATH='/mnt/NAS/OrbitalData/ISIS-DATA/'
SHARED_PATH='/mnt/DATS-EXT4/docker-vols/preset-data-vol'

## Image for docker-spawner (Image to be used for each user)
NOTEBOOK_IMAGE=isis5-asp3-gispy:lab

## JupyterHUB access port
NOTEBOOK_PORT=9988

## JupyterHUB database
# Name, user and pwd of JupyterHub postgres database
DB_VOLUME_HOST=jupyterhub-db-data
POSTGRES_DB=jupyterhub
POSTGRES_PASSWORD=jupysqlpswd!

## OAuthentication configuration
GITHUB_CLIENT_ID=0180328a17738c6ed04c
GITHUB_CLIENT_SECRET=5ab0622ec5eeddfdf2f7ace14e38284d015d11f3
GITHUB_CALLBACK_URL=http://localhost:9988/hub/oauth_callback
```
3) create *userlist* file list containing only the authorized github/gitlab usernames and admin flag.

E.g. *userlist* file containing:
```
Giacomo
Chtulhu admin
```
4) Make the main scripts executable
```
chmod +x script/ImageBuilder.sh

chmod +x Installer.sh
```
5) Run the installer
```
./Installer.sh
```

**NOTE** It is possible to create a standalone isis5-asp3-gispy+jupyterlab image by passing options -JH N or -jh n to the installer.
```
./Installer -jh n
```

## Installer details

The installer scripts take care of everything!

* check if DOCKER_NETWORK_NAME exists and create it binding HUB_DATA_VOL_PATH if missing
* check if HUB_DATA_VOL exists and create it if missing
* check if HUB_DB_VOL exists and create it binding HUB_DB_VOL_PATH if missing
* check if ISIS_DATA_VOL exists and create it binding ISIS_DATA_PATH if missing
* build the isis5asp3-gispy:lab image

## isis5asp3-gispy:lab image

This image is a combined build of:

* USGS ISIS v5
* NASA AMES Stereo Pipeline (ASP) v3
* jupyter-stack/base-notebook  
* GISPY image containing several common used python package for processing planetary images and GIS data (e.g. rasterio, spectral, fiona, shapely) and various utilities (e.g. numpy, matoplotlib, pandas, scikit-image, etc)

Then ISIS v5 can be used in jupyterlab terminal or jupyter noteboo through [kalasiris](https://github.com/rbeyer/kalasiris) package by adding in the first cell of the notebook the following code:
```
import os
os.environ["ISISROOT"]="/opt/conda/envs/isis/"
os.environ["ISISDATA"]="/isis/data"
import kalasiris as isis
```

For an example notebook see [PyISIS-Parallel](https://github.com/Hyradus/PyISIS-Parallel/tree/main/PyISIS-Parallel)

## ISIS-DATA

ISIS-DATA is mounted to the JupyterHub container and to each spawned container.

## Persistent Data

All data is persistent using docker volumes.

# TO-DO

* [ ] Multi user test during processing
* [ ] Add concurrent OAuth
* [ ] Add configuration for spawned container resource limits
* [ ] Switch to kubernetes
* [ ] Integrate with portainer
* [ ] Integrate with Guacamole
