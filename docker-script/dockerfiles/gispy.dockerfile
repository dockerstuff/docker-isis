ARG BASE_IMAGE=jupyter/base-notebook:lab-3.2.8 #ubuntu:21.04
FROM $BASE_IMAGE as base
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV TZ=Europe/Rome
ENV DEBIAN_FRONTEND='noninteractive'
MAINTAINER "Giacomo Nodjoumi <giacomo.nodjoumi@hyranet.info>"
USER root
RUN apt-get update && \
    apt-get upgrade -y \
    && apt-get install –no-install-recommends -y python3-pip \
                          git-core \
                          tzdata \
                          vim \
    && rm -rf /var/lib/apt/lists/* \
    && mamba install -c conda-forge \
                          fiona \
                          geopandas \
                          geoplot \
                          kalasiris \
                          matplotlib \
                          numpy \
                          pygeos \
                          rasterio \
                          scikit-image \
                          scipy \
                          shapely \
                          spectral \
    && python3.9 -m pip --no-cache-dir install \
                          ipython
