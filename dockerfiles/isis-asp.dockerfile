ARG BASE_IMAGE=osgeo/gdal:ubuntu-small-3.4.0

FROM $BASE_IMAGE

MAINTAINER "Carlos Brandt <carloshenriquebrandt at gmail>"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

USER root
RUN apt-get update && \
    # apt-get install -y --no-install-recommends s3cmd && \
    apt-get install -y libgl1-mesa-glx && \
    apt-get install -y libjpeg9 libjpeg9-dev && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove


RUN wget -q -O /tmp/miniconda.sh                                               \
         https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && /bin/bash /tmp/miniconda.sh -b -p ${CONDA_PREFIX}                       \
    && rm /tmp/miniconda.sh                                                    \
    && echo "export PATH=$PATH" > /etc/profile.d/conda.sh


ARG ASP_VERSION="3.0.0"
ARG ISIS_VERSION="5"

USER $NB_UID
RUN conda create -n isis -c conda-forge -y python=3.6     && \
    source activate isis                                  && \
    conda config --add channels conda-forge               && \
    conda config --prepend channels usgs-astrogeology     && \
    conda config --append channels default                && \
    mamba install -c usgs-astrogeology -y isis="$ISIS_VERSION"            && \
    conda config --append channels nasa-ames-stereo-pipeline && \
    mamba install -c nasa-ames-stereo-pipeline stereo-pipeline==$ASP_VERSION && \
    conda clean -a

RUN source activate isis  && \
    pip install ipykernel &&\
    python -m ipykernel install --user --name 'ISIS'

# ENV ISISROOT=/opt/conda
ARG ISISDATA=/isis/data
ARG ISISTESTDATA=/isis/testdata

USER root
RUN mkdir -p $ISISDATA && \
    mkdir -p $ISISTESTDATA
USER $NB_UID

RUN source activate isis && \
    python /opt/conda/envs/isis/scripts/isisVarInit.py \
      --data-dir=$ISISDATA  \
      --test-dir=$ISISTESTDATA && \
    echo "source activate isis" >> $HOME/.bashrc && \
    

# VOLUME "${ISISDATA}"

#ENV PATH="$PATH:/opt/conda/envs/isis/bin"

# WORKDIR $HOME
