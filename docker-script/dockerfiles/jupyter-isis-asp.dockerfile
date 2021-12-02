ARG BASE_IMAGE=osgeo/gdal:ubuntu-small-3.4.0

FROM $BASE_IMAGE

MAINTAINER "Carlos Brandt <carloshenriquebrandt at gmail>"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends s3cmd && \
    apt-get install -y libgl1-mesa-glx && \
    apt-get install -y libgl1 && \
    apt-get install -y libjpeg9 libjpeg9-dev && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove

ARG ASP_VERSION="3.0.0"
ARG ISIS_VERSION="5.0.1"

USER $NB_UID
RUN conda create -n isis -c conda-forge -y python=3.6     && \
    source activate isis                                  && \
    conda config --prepend channels usgs-astrogeology     && \
    conda config --append channels default                && \
    conda install -c usgs-astrogeology -y isis="$ISIS_VERSION"            && \
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
    echo "source activate isis" >> $HOME/.bashrc
