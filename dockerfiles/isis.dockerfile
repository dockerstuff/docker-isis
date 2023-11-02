ARG BASE_IMAGE="jupyter/minimal-notebook:latest"
FROM $BASE_IMAGE

# ARG JUPYTERHUB_VERSION="3.0.0"
# RUN python -m pip install --no-cache jupyterhub==$JUPYTERHUB_VERSION    && \
#     echo "jupyterhub $(jupyterhub --version)" >> $CONDA_DIR/conda-meta/pinned

# This lines above are necessary to guarantee a smooth coupling JupyterHub.
# -------------------------------------------------------------------------

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

USER root
RUN apt-get update -y                           && \
    apt-get install -y --no-install-recommends  \
        bzip2                                   \
        ca-certificates                         \
        curl                                    \
        gettext                                 \
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

ARG ISIS_VERSION=""

COPY isis.yml /tmp/isis.tmp

RUN [ -n "${ISIS_VERSION}" ]                                                && \
    sed "s/\(.*- isis\).*/\1=$ISIS_VERSION/" /tmp/isis.tmp > /tmp/isis.yml  || \
    cp /tmp/isis.tmp /tmp/isis.yml

RUN mamba env create --name isis --file /tmp/isis.yml   && \
    mamba clean -a

# Set channels for isis environment.
# These channels are the very same ones in 'isis.yml', used to install 'ISIS'
# in the 'isis' environment, but for some reason those channels are NOT set
# for the new environment. I think this is a bug a filed an issue in Conda:
# - https://github.com/conda/conda/issues/13276
# In the meantime, we force/add those channels by hand here.
RUN source activate isis                                        && \
    conda config --env --append channels defaults               && \
    conda config --env --prepend channels usgs-astrogeology

# Stack 'base' on top of 'isis' to get its PATH.
# Then, update the default/base kernel to include PATH from 'isis'
RUN source activate isis                                        && \
    source activate --stack base                                && \
    python -m ipykernel install --user --env PATH $PATH

# Although providing an ipykernel for 'isis' environment is not
# very useful (since ISIS is about command-line tools) and may
# cause confusion to less geek users, it may be of particular use
# to some advanced ones calling shell from python.
# So...let's define an ISIS kernel
RUN source activate isis                                    && \
    python -m ipykernel install --user --name 'ISIS'

ARG ISISDATA="/isis/data"
ARG ISISTESTDATA="/isis/testdata"

ENV ISISDATA=${ISISDATA}
ENV ISISTESTDATA=${ISISTESTDATA}

ENV ISISROOT="/opt/conda/envs/isis"

RUN echo 'source activate isis' >> ~/.bashrc                        && \
    echo 'export PATH="${HOME}/.local/bin:${PATH}"' >> ~/.bashrc

## Write a README file for user
#
ENV README=$HOME/README.md

COPY readmes/readme.base.md /tmp/readme.base.md
COPY readmes/readme.isis.md /tmp/readme.isis.md

RUN cat /tmp/readme.base.md | envsubst              > $README  && \
    echo ""                                         >> $README  &&\
    cat /tmp/readme.isis.md | envsubst              >> $README  && \
    echo ""                                         >> $README

# # # If WORK_DIR is not defined (when notebook/user is started), use (~) Home.
# # RUN echo 'conda config --add envs_dirs ${WORK_DIR:-~}/.conda/envs 2> /dev/null' \
# #       >> $HOME/.bashrc

# # RUN python3 -m pip install nbgitpuller
# # RUN echo 'http://localhost:8888/hub/user-redirect/git-pull?repo=https%3A%2F%2Fgithub.com%2Feuroplanet-gmap%2FBasemappingUtils&urlpath=lab%2Ftree%2FBasemappingUtils%2FREADME.md&branch=master' > $HOME/README.md

# # COPY etc/jupyterlab/user_settings.json /opt/conda/share/jupyter/lab/settings/overrides.json
