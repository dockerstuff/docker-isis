# ARG BASE_IMAGE="osgeo/gdal"
ARG BASE_IMAGE="chbrandt/gispy:gdal-3.3.0"
FROM $BASE_IMAGE

MAINTAINER "Carlos Brandt <carloshenriquebrandt at gmail>"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN DEBIAN_FRONTEND=noninteractive        \
    && apt-get update --fix-missing       \
    && apt-get install -y wget            \
                          bzip2           \
                          ca-certificates \
                          curl            \
                          git             \
                          vim             \
    && apt-get install -y rsync           \
                          libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

ENV CONDA_PREFIX="/opt/conda"
ENV PATH="$PATH:${CONDA_PREFIX}/bin"

RUN wget -q -O /tmp/miniconda.sh                                               \
         https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && /bin/bash /tmp/miniconda.sh -b -p ${CONDA_PREFIX}                       \
    && rm /tmp/miniconda.sh                                                    \
    && echo "export PATH=$PATH" > /etc/profile.d/conda.sh

RUN conda install -y python=3.6                             \
    && conda config --env --add channels conda-forge        \
    && conda config --env --add channels usgs-astrogeology  \
    && conda install -c usgs-astrogeology isis=3       \
    && conda clean -a

ARG ISISDATA=/isis/data
ADD etc/isis.sh /etc/profile.d/isis.sh
RUN sed -i "s,ISISDATA\=.*,ISISDATA\=${ISISDATA}," /etc/profile.d/isis.sh
VOLUME "${ISISDATA}"
