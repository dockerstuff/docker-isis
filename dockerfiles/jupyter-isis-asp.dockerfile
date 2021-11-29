ARG BASE_IMAGE=osgeo/gdal:ubuntu-small-3.4.0

FROM $BASE_IMAGE

MAINTAINER "Carlos Brandt <carloshenriquebrandt at gmail>"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

USER root
RUN apt-get update && \
    # apt-get install -y --no-install-recommends s3cmd && \
    #apt-get install -y libgl1-mesa-glx && \
    apt-get install -y libgl1 && \
    # apt-get install -y libjpeg9 libjpeg9-dev && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove
RUN wget 	http://archive.ubuntu.com/ubuntu/pool/main/libg/libglvnd/libgl1_1.0.0-2ubuntu2.3_amd64.deb && \
    dpkg -i libgl1_1.0.0-2ubuntu2.3_amd64.deb && \
    wget  http://archive.ubuntu.com/ubuntu/pool/main/m/mesa/libgl1-mesa-glx_20.0.8-0ubuntu1~18.04.1_amd64.deb && \
    dpkg -i libgl1-mesa-glx_20.0.8-0ubuntu1~18.04.1_amd64.deb && \
    wget 	http://archive.ubuntu.com/ubuntu/pool/universe/libj/libjpeg9/libjpeg9_9b-2_amd64.deb && \
    dpkg -i libjpeg9_9b-2_amd64.deb && \
    wget 	http://archive.ubuntu.com/ubuntu/pool/universe/libj/libjpeg9/libjpeg9-dev_9b-2_amd64.deb && \
    dpkg -i libjpeg9-dev_9b-2_amd64.deb


#ARG ASP_INSTALLER="https://github.com/NeoGeographyToolkit/StereoPipeline/releases/download/3.0.0/StereoPipeline-3.0.0-2021-07-27-x86_64-Linux.tar.bz2"
ARG ASP_VERSION="3.0.0"
ARG ISIS_VERSION="5.0.1"

ARG ASP_ROOT="/opt/asp/${ASP_VERSION}"
#ARG TARFILE="asp.tar.bz2"
#    RUN mkdir -p $ASP_ROOT
#    RUN wget -q -O $TARFILE "$ASP_INSTALLER"
#    #tar --strip-components 1 -xvf $TARFILE \
#    #-C /opt/asp/${ASP_VERSION} && \
#    #rm $TARFILE

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


# VOLUME "${ISISDATA}"

#ENV PATH="$PATH:/opt/conda/envs/isis/bin"

# WORKDIR $HOME
