ARG BASE_IMAGE="jupyter/minimal-notebook:latest"
FROM $BASE_IMAGE

ARG JUPYTERHUB_VERSION="3.0.0"
RUN python3 -m pip install --no-cache jupyterhub==$JUPYTERHUB_VERSION

# This lines above are necessary to guarantee a smooth coupling JupyterHub.
# -------------------------------------------------------------------------

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

USER root
RUN apt-get update  -y                  && \
    apt-get install -y libgl1-mesa-glx  \
                        libjpeg9        \
                        libjpeg9-dev    && \
    apt-get install -y python3-pip      \
                        build-essential \
                        curl            \
                        sudo            \
                        tzdata          \
                        git-core        \
                        # libproj-dev     \
                        # libgeos-dev     \
                        vim             && \
    rm -rf /var/lib/apt/lists/*         && \
    apt-get clean                       && \
    apt-get autoremove -y
USER $NB_UID

RUN	mamba install -c conda-forge 				\
				fiona 							\
				geopandas 						\
				geoplot 						\
				geoviews 						\
				holoviews 						\
				hvplot 							\
				ipywidgets						\
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
				spectral					 	\
				tqdm						 && \
	conda clean -a							 && \
	pip install asap_stereo					 	\
	pds4-tools									\
	rio-cogeo									\
	https://github.com/chbrandt/gpt/archive/refs/tags/v0.3dev.zip  

ENV USE_PYGEOS=0

# COPY etc/jupyterlab/user_settings.json /opt/conda/share/jupyter/lab/settings/overrides.json
