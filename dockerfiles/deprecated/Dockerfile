ARG BASE_IMAGE=osgeo/gdal:ubuntu-small-3.3.0

FROM $BASE_IMAGE

MAINTAINER "Carlos Brandt <carloshenriquebrandt at gmail>"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN DEBIAN_FRONTEND=noninteractive        \
    && apt-get update --fix-missing       \
    && apt-get install -y \
          bzip2           \
          ca-certificates \
          curl            \
          git             \
          libgl1-mesa-glx \
          libjpeg9        \
          libjpeg9-dev    \
          python3-pip     \
          rsync           \
          wget            \
          vim             \
    && rm -rf /var/lib/apt/lists/*

ENV CONDA_PREFIX="/opt/conda"
ENV PATH="$PATH:${CONDA_PREFIX}/bin"

ARG ISIS_VERSION="3"

RUN wget -q -O /tmp/miniconda.sh                                               \
         https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && /bin/bash /tmp/miniconda.sh -b -p ${CONDA_PREFIX}                       \
    && rm /tmp/miniconda.sh                                                    \
    && echo "export PATH=$PATH" > /etc/profile.d/conda.sh

RUN conda update conda                                      && \
    conda install -y python=3.6                             && \
    conda config --add channels conda-forge                 && \
    conda config --add channels usgs-astrogeology           && \
    conda install -c usgs-astrogeology isis="$ISIS_VERSION" && \
    conda clean -a

ARG ISISDATA=/isis/data
ADD etc/isis.sh /etc/profile.d/isis.sh
RUN sed -i "s,ISISDATA\=.*,ISISDATA\=${ISISDATA}," /etc/profile.d/isis.sh
VOLUME "${ISISDATA}"

#ENTRYPOINT ["bash"]
#CMD ["-l"]
