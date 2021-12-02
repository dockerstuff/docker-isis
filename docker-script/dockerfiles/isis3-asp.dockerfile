ARG BASE_IMAGE=osgeo/gdal:ubuntu-small-3.4.0

FROM $BASE_IMAGE

MAINTAINER "Giacomo Nodjoumi <giacomo.nodjoumi@hyranet.info>"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

USER root
ARG ISISDATA=/isis/data
ARG ISISTESTDATA=/isis/testdata

RUN mkdir -p $ISISDATA && \
    mkdir -p $ISISTESTDATA

ARG ASP_VERSION="2.6.2"
ARG ISIS_VERSION="3"
ARG ASP_ROOT="/opt/asp/${ASP_VERSION}"
ARG TARBALL="StereoPipeline-2.6.2-2019-06-17-x86_64-Linux.tar.bz2"

ARG CONDA_MIRROR='https://github.com/conda-forge/miniforge/releases/latest/download'
ARG CONDA_DIR='/opt/conda'
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV PATH="${CONDA_DIR}/bin:${PATH}"

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

RUN set -x && \
    miniforge_arch=$(uname -m) && \
    miniforge_installer="Mambaforge-Linux-${miniforge_arch}.sh" && \
    wget --quiet "${CONDA_MIRROR}/${miniforge_installer}" && \
    /bin/bash "${miniforge_installer}" -f -b -p "${CONDA_DIR}" && \
    rm "${miniforge_installer}" && \
    # Using conda to update all packages: https://github.com/mamba-org/mamba/issues/1092
    echo 'eval "$(command conda shell.bash hook 2> /dev/null)"' >> /etc/skel/.bashrc && \
    #conda update --all --quiet --yes && \
    conda create -n isis -c conda-forge -y python=3.6.0 && \
    #/bin/bash -c "source activate isis" && \
    source activate isis && \
    conda config --env --append channels usgs-astrogeology     && \
    conda config --env --add channels nasa-ames-stereo-pipeline && \
    conda config --env --append channels default                && \
    conda config --env --append channels conda-forge                && \
    conda install -n isis -y https://anaconda.org/conda-forge/jpeg/9b/download/linux-64/jpeg-9b-h470a237_3.tar.bz2 && \
    conda install -n isis -y https://anaconda.org/conda-forge/curl/7.60.0/download/osx-64/curl-7.60.0-h93b3f91_0.tar.bz2 && \
    conda install -n isis -y https://anaconda.org/conda-forge/openssl/1.0.2n/download/linux-64/openssl-1.0.2n-0.tar.bz2 && \
    mamba install -n isis https://anaconda.org/conda-forge/libssh2/1.8.0/download/linux-64/libssh2-1.8.0-h90d6eec_1004.tar.bz2 && \
    #mamba install -n isis https://anaconda.org/usgs-astrogeology/isis/3.10.2/download/linux-64/isis-3.10.2-py36_0.tar.bz2 && \
    #mamba install -n isis -c conda-forge spiceypy && \
    mamba install -n isis -c usgs-astrogeology isis=3.10.2 && \
    conda clean -a && \
    python /opt/conda/envs/isis/scripts/isis3VarInit.py \
          --data-dir=$ISISDATA  \
          --test-dir=$ISISTESTDATA && \
        echo "source activate isis" >> $HOME/.bashrc

RUN mkdir -p $ASP_ROOT \
    && wget https://github.com/NeoGeographyToolkit/StereoPipeline/releases/download/v2.6.2/$TARBALL        					&&	\
    tar --strip-components 1 -xvf $TARBALL -C /opt/asp/2.6.2  && \
    echo "export PATH=${PATH}:/opt/asp/2.6.2/bin" >> $HOME/.bashrc

RUN echo "source activate isis" >> $HOME/.bashrc
