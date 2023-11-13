# Docker-ISIS

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

The *images* are:

- `gispy`: Jupyter-Lab for Geographical (GIS) data analysis with Python
- `isis`: Jupyter-Lab server with USGS/ISIS installed
- `isis-asp`: Extension of `isis` with AMES Stereo Pipeline installed

Images tree:

    ---------
    | gispy |
    ---------
    --------     ------------
    | isis | --> | isis-asp |
    --------     ------------

The corresponding images can be downloaded from GMAP repository in DockerHub:

- `gmap/jupyter-gispy`: latest build of `gispy.dockerfile`
- `gmap/jupyter-isis`: latest build of `isis.dockerfile`
- `gmap/jupyter-isis-asp`: latest build of `isis-asp.dockerfile`

> Check GMAP's DockerHub for specific image tags (other than "`latest`")
> if you want to use specific software (eg, ISIS) versions.
> The `latest` versions will corresponding to the latest (Git) tag of
> *this* (Git/Github) repository.

If you want to *build* your own images,
go to [`dockerfiles/README.md`](dockerfiles/README.md).

## TLDR

Since these images are based on [Jupyter images][], running them works
exactly the same:

```bash
docker run -it -p 8888:8888 -e JUPYTER_TOKEN=pass gmap/jupyter-isis
```

> Open a browser window at [http://localhost:8888](http://localhost:8888)
> and type `pass` in the password/token field for the authentication.
>
> Notice that we used the argument `-e JUPYTER_TOKEN=pass` to set the
> password/token. If you don't use such argument, you should get the
> token value from the (Jupyter) service log from `docker run` command.

Since most of ISIS tools demand the use of ISIS-Data, you need to provide it
by *sharing* a local directory containing a copy of *ISISDATA*.
This is done with options `-v`:

```bash
ISISDATA="/path/to/my/isisdata"
docker run -it -p 8888:8888 -v $ISISDATA:/isis/data gmap/jupyter_isis
```

> Notice the value where your `$ISISDATA` directory is being mounted to
> inside the container:
>
> - **`/isis/data`**
>
> This is where the user environment inside the container is expecting
> to find ISIS' Data.

You can share as many directories as you want (between your computer and
the container) through (multiple) `-v` arguments.
For example, if you want to analyse data there are stored in two different
diretories in your computer -- say, `/path/to/raster` and `/path/to/vector` --,
you can share them with the container like so:

```bash
docker run -it -p 8888:8888 \
    -v /path/to/raster:/home/jovyan/raster \
    -v /path/to/vector:/home/jovyan/vector \
    gmap/jupyter_gispy
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


## How to run

This section is somewhat long because we go through the various options you
have when running these images, in particular `jupyter-isis`.
We assume no particular knowledge with `docker`, hence the many steps we'll
go through.

> If you are familiar with Docker and Jupyter and ISIS, you can skip to
> sub-section [Command-line summary](#command-line-summary)

Subsections:

- [Run Docker container, the basics](#run-docker-container-the-basics)
- [Accessing Jupyter-Lab](#accessing-jupyter-lab)
    * [Get *token* from terminal](#get-token-from-terminal)
    * [Define *password* beforehand](#define-password-beforehand)
- [Accessing host data](#accessing-host-data)
    * [Mount ISISDATA](#mount-isisdata)


### Run Docker container, the basics

> The instruction below assume the use of a terminal (cli), if you are not
> used to command-line interfaces, don't worry, you can achieve the same
> through the graphical interface provided by Docker Desktop.

Running the (jupyter-isis) container is a two-steps process:

- *Pull* (or *download*) the (jupyter-isis) image:
```bash
docker pull gmap/jupyter-isis
```


- And *run* it. Pay attention to the `--port` argument:
```bash
docker run --rm -p 8888:8888 gmap/jupyter-isis
```

> The `-p` argument is necessary because the interface we are going to
> use -- Jupyter-Lab -- is accessible through our host's port `8888`.
>
> The other argument, `--rm` is responsible for automatic remove of of
> the container when you finish using it.


### Accessing Jupyter-Lab

"Jupyter-ISIS" containter is running, and an instance of Jupyter-Lab
should be available at [http://localhost:8888](http://localhost:8888).
If you go there (in your browser), you should see a login page, where a
passphrase (password, token) is requested.

There are two ways you can authenticate and login into a Jupyter-Lab instance:

1. (default) you get the *token* generated by Jupyter, from the terminal;
2. you define the password beforehand, when you `run` the container.


#### Get *token* from terminal

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


#### Define *password* beforehand

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


### Accessing host data

Docker containers run in an isolated environment, meaning it is not possible
to access the contents of the host system unless explicitly required.
For example, if you want to access the content of directory `/data` from
inside the (jupyter-isis) container, you must "say" so when *instantiating*
the container (*ie*, when `docker run`*ning*).

In practice, to *share* a directory from your computer (*eg*, `/data`)
with the (jupyter-isis) container, you will use `docker run` option `-v`:

```bash
docker run  -v "/data:/mnt/data" \
            -p 8888:8888 gmap/jupyter-isis
```

In the command above we *bound* host's `/data` directory to
container's `/mnt/data` directory through option `-v` (*volume*)

You can mount as many volumes (*ie*, directories) as you want.
For example, suppose we want to analyse some data from Mars, and for that
we are going to use raster and vector datasets from two diferent directories,
'`/data/raster/mars`' and '`/data/vector/mars`'.

We can share *both* directories with the container.
In this case, we can bind `/data/{raster,vector}/mars` directories to
container's `/mnt/data/mars/{raster,vector}` paths:

```bash
docker run  -v /data/raster/mars:/mnt/data/mars/raster \
            -v /data/vector/mars:/mnt/data/mars/vector \
            -p 8888:8888 gmap/jupyter-isis
```

Now, from inside the container, if you inspect the content of those
directories, `/mnt/data/*`, you should see the very same content of the
respective ones in the host system (`/data/*`).


### Mount ISISDATA

`ISISDATA` is a directory you will give to `jupyter-isis` everytime you
run it if you want to make use of the ISIS tools.

The ISIS tools inside jupyter-isis expect ISISDATA to be provided at
'`/isis/data`'

Suppose I download ISIS Data into my system's `/path/to/isisdata` directory.
I'd run jupyter-isis as follows:

```bash
docker run  -v /path/to/isisdata:/isis/data \
            -p 8888:8888 gmap/jupyter-isis
```

Inside the container, you should see the content of ISISDATA inside
`/isis/data`.
