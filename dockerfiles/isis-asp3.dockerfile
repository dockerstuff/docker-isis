ARG BASE_IMAGE=condaforge/mambaforge

FROM $BASE_IMAGE

MAINTAINER "Giacomo Nodjoumi <giacomo.nodjoumi@hyranet.info>"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

USER root

ARG ISISDATA=/isis/data
ARG ISISTESTDATA=/isis/testdata

RUN mkdir -p $ISISDATA && \
    mkdir -p $ISISTESTDATA
    
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV PATH="${CONDA_DIR}/bin:${PATH}"

RUN DEBIAN_FRONTEND=noninteractive        																		&& \
    apt-get update --fix-missing      																			&& \
    apt-get install --no-install-recommends -y	\
          bzip2           						\
          ca-certificates 						\
          curl            						\
          git             						\
          libgl1-mesa-glx 						\
          libjpeg9        						\
          libjpeg9-dev    						\
          python3-pip     						\
          rsync           						\
          wget            						\
          vim             																						&& \
    rm -rf /var/lib/apt/lists/*


ARG ASP_VERSION="3.1.0"
ARG ASP_TAR="StereoPipeline-${ASP_VERSION}-2022-05-18-x86_64-Linux.tar.bz2"
ARG ISIS_VERSION="7.1.0"
ARG CONDA_DIR='/opt/conda'

RUN set -x && \
    conda update --all -y && \
    echo 'eval "$(command conda shell.bash hook 2> /dev/null)"' >> /etc/skel/.bashrc 							&& \
    conda create -n isis -c conda-forge -y python=3.9 															&& \
    source activate isis 																						&& \
    conda config --append channels usgs-astrogeology     														&& \
    conda config --append channels default                														&& \    
    mamba install -n isis -c usgs-astrogeology isis=$ISIS_VERSION 												   \
											   rclone															&& \
    wget "https://github.com/NeoGeographyToolkit/StereoPipeline/releases/download/${ASP_VERSION}/${ASP_TAR}"  	&& \
    mkdir /opt/ASP	 																							&& \
    tar -xvf StereoPipeline-${ASP_VERSION}-2022-05-18-x86_64-Linux.tar.bz2 --strip 1 -C /opt/ASP 				&& \
    rm -rf $ASP_TAR 																							&& \
    chmod -R 755 /opt/ASP/ 																						&& \
    conda clean -a																								    

	
RUN source activate isis && \ 
	python /opt/conda/envs/isis/scripts/isisVarInit.py \
    --data-dir=$ISISDATA  \
    --test-dir=$ISISTESTDATA 
												
RUN echo "export PATH=${PATH}:/opt/ASP/bin" >> ~/.bashrc													&& \
	echo "source activate isis" >> ~/.bashrc && \ 
	chmod -R 755 /lib/ && \
	source ~/.bashrc

