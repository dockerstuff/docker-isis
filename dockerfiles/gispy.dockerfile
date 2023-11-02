ARG BASE_IMAGE="jupyter/minimal-notebook:latest"
FROM $BASE_IMAGE
ENV BASE_IMAGE $BASE_IMAGE

# ARG JUPYTERHUB_VERSION="3.0.0"
# RUN python -m pip install --no-cache jupyterhub==$JUPYTERHUB_VERSION    && \
#     echo "jupyterhub $(jupyterhub --version)" >> $CONDA_DIR/conda-meta/pinned

# This lines above are necessary to guarantee a smooth coupling JupyterHub.
# -------------------------------------------------------------------------

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Guarantee some basic system tools are installed
#
USER root
RUN apt-get update -y                           && \
    apt-get install -y --no-install-recommends  \
        bzip2                                   \
        ca-certificates                         \
        curl                                    \
        git                                     \
        libgl1-mesa-glx                         \
        libjpeg9                                \
        libjpeg9-dev                            \
        rsync                                   \
        wget                                    \
        vim                                     && \
    rm -rf /var/lib/apt/lists/*                 && \
    apt-get autoremove
USER $NB_UID

# Set some global configs to Conda
#
RUN conda config --set always_yes true                          && \
    conda config --set use_only_tar_bz2 false                    && \
    conda config --set notify_outdated_conda false              && \
    #
    ## conda-update may not be necessary, and can mess up things.
    ## for instance, https://github.com/conda/conda/issues/10887,
    ## guarantee 'pip' will be there after updating.
    # conda update conda                                          && \
    # conda install pip                                           && \
    #
    ## "nb-conda-kernels" doesn't seem to work (as I expected).
    ## There is a discussion about managing kernels/nb_conda_kernels
    ## in: https://github.com/jupyter-server/jupyter_server/pull/112.
    ## In short, nb_conda_kernels used to work well, but is outdated.
    # conda install nb_conda_kernels                              && \
    #
    conda config --add create_default_packages ipykernel        && \
    conda config --add create_default_packages pip              && \
    conda config --add create_default_packages sh               && \
    conda clean -a


## Install the GIS packages listed in 'gispy.txt'
#
# Copy the list of packages to install ("requirements.txt")
COPY gispy.txt /tmp/gispy.txt

# Turn off PyGEOS, prefer Shapely (for some reason)
#   - https://geopandas.org/en/stable/docs/user_guide/pygeos_to_shapely.html
ENV USE_PYGEOS=0

# Install gispy packages
RUN mamba install -y --file /tmp/gispy.txt      && \
    mamba clean -a


## Write a README file for user
#
ENV README=$HOME/README.md

COPY readmes/readme.base.md /tmp/readme.base.md
COPY readmes/readme.gispy.md /tmp/readme.gispy.md

RUN cat /tmp/readme.base.md | envsubst              > $README  && \
    echo ""                                         >> $README  &&\
    cat /tmp/readme.gispy.md | envsubst             >> $README  && \
    echo ""                                         >> $README  &&\
    echo "Python/Conda packages installed by *us*:" >> $README  && \
    conda env export --no-builds                                \
        | grep --file /tmp/gispy.txt --word-regexp  >> $README  &&\
    echo ""                                         >> $README

# COPY etc/jupyterlab/user_settings.json /opt/conda/share/jupyter/lab/settings/overrides.json
