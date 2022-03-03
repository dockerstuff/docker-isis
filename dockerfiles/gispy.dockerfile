ARG BASE_IMAGE=condaforge/mambaforge
FROM $BASE_IMAGE as base

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV TZ=Europe/Rome
ENV DEBIAN_FRONTEND='noninteractive'
MAINTAINER "Giacomo Nodjoumi <giacomo.nodjoumi@hyranet.info>"
USER root
RUN apt-get update && \
    apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
                          build-essential \
                          curl \
                          git-core \
			                    python3-pip \
                          sudo \
                          tzdata \
                          vim \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && mamba install -c conda-forge \
                          fiona \
                          geopandas \
                          geoplot \
                          holoviews \
                          hvplot \
                          kalasiris \
                          matplotlib \
                          numpy \
                          plotly \
                          pygeos \
                          rasterio \
                          rioxarray \
                          scikit-image \
                          scipy \
                          shapely \
                          spectral
