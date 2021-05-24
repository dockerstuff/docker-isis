# USGS ISIS3 Dockerfile

USGS Integrated Software for Imagers and Spectrometers v3 (ISIS3) Docker container.

ISIS3 documentation/resources:
- https://isis.astrogeology.usgs.gov/
- https://github.com/USGS-Astrogeology/ISIS3
- https://astrodiscuss.usgs.gov/

## Docker container
The latest container built from the [dockerfile](dockerfile/) here defined can be found at the [DockerHub](https://hub.docker.com/r/chbrandt/isis3):
* `chbrandt/isis3`

The container has the following [ISIS3 environment variables](dockerfile/etc/isis.sh):
```bash
ISISROOT=/opt/conda
ISISDATA=/isis/data
ISIS3DATA="${ISISDATA}"
ISISTESTDATA=/isis/data_test
```

## How to run
If you are familiar with ISIS3 you know that ISIS need its kernels/ancillary data -- the famous `ISIS3DATA` -- to do virtually anything.
By default (in this container) `ISIS3DATA` is expected to be found under the container's `/isis/data` directory.

### Basic example (recommended)
> Provide your `ISIS3DATA` repository by mounting it at container's `/isis/data` path.

* Example of running a `isis3` container with the ancillary data (at `/isis/data`):
```bash
$ docker run -it --name isis3 \
    -v /path/to/data/isis3data:/isis/data \
    chbrandt/isis3
```

### Redefining ISIS3 environment variables
> ISIS3 environment variables are defined in container's [/etc/profile.d/isis.sh](dockerfile/etc/isis.sh).

* If you want to customize ISIS3 variables, overwrite the default bash-profile:
```bash
$ docker run -it --name isis3 \
    -v $PWD/dockerfile/etc/isis.sh:/etc/profile.d/isis.sh \
    chbrandt/isis3
```

* If you're running the `jupyterhub` image, it comes with Jupyterhub:
```bash
$ docker run -it --rm --name jupyterhub \
    -p 8000:8000 \
    -v "$PWD":/mnt/data \
    -v "/path/to/data/isis3data":/isis/data \
    chbrandt/isis3:jupyterhub
```
