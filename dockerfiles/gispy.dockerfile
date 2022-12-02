ARG BASE_IMAGE=jupyter/base-notebook:latest
FROM $BASE_IMAGE as base

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV TZ=Europe/Rome
ENV DEBIAN_FRONTEND='noninteractive'

MAINTAINER "Giacomo Nodjoumi <giacomo.nodjoumi@hyranet.info>"

USER root

RUN apt-get update				&& \
    apt-get upgrade -y 			&& \
    apt-get install --no-install-recommends -y	\
				build-essential					\
				curl 							\
				git-core 						\
				python3-pip 					\
				sudo 							\
				tzdata							\
				vim							 && \	
    rm -rf /var/lib/apt/lists/* 	 		 && \
    apt-get clean


USER $NB_USER
    
RUN	mamba install -c conda-forge 				\
				fiona 							\
				geopandas 						\
				geoplot 						\
				geoviews 						\
				holoviews 						\
				hvplot 							\
				kalasiris 						\
				matplotlib 						\
				owslib 							\
				numpy 							\
				plotly 							\
				pygeos 							\
				rasterio 						\
				rioxarray 						\
				scikit-image					\
				scipy 							\
				shapely 						\
				spectral					 && \
	conda clean -a							 && \
	pip install asap_stereo					 	\
	pds4-tools									\
	rio-cogeo									\
	https://github.com/chbrandt/gpt/archive/refs/tags/v0.3dev.zip  

WORKDIR $HOME/
ENV JUPYTER_ENABLE_LAB='yes'
