ARG BASE_IMAGE=condaforge/mambaforge

FROM $BASE_IMAGE AS BASE

MAINTAINER "Giacomo Nodjoumi <giacomo.nodjoumi@hyranet.info>"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

USER root

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
    rm -rf /var/lib/apt/lists/*                                                                                 && \
    apt-get clean

ARG ISIS_VERSION="7.1.0"
ARG ASP_VERSION="3.2.0"
FROM base AS ISIS

RUN set -x && \
    conda update --all -y && \
    echo 'eval "$(command conda shell.bash hook 2> /dev/null)"' >> /etc/skel/.bashrc 							&& \
    conda create -n isisasp -c conda-forge -y python=3.9 															&& \
    source activate isisasp 																						&& \
    conda config --env --add channels conda-forge                                                               && \
    conda config --env --add channels usgs-astrogeology                                                         && \
    conda config --env --add channels nasa-ames-stereo-pipeline                                                 && \
    conda install stereo-pipeline==3.2.0                                                                        && \
    mamba install -n isisasp -c usgs-astrogeology isis=$ISIS_VERSION 												\
											   rclone		                                                    && \
    conda clean -a                                                                                              && \
    pip install ipykernel                                                                                       && \
    python -m ipykernel install --user --name 'ISIS-ASP'                                                            

ARG ISISDATA=/isis/data
ARG ISISTESTDATA=/isis/testdata

RUN mkdir -p $ISISDATA && \
    mkdir -p $ISISTESTDATA
    
RUN source activate isisasp && \ 
	python /opt/conda/envs/isisasp/scripts/isisVarInit.py \
    --data-dir=$ISISDATA  \
    --test-dir=$ISISTESTDATA 

ARG WORKPATH=/work
RUN mkdir -p $WORKPATH && \
    chmod -R 777 $WORKPATH

RUN echo "export PATH=${PATH}:/opt/conda/envs/isisasp/bin" >> ~/.bashrc                                     && \                                    
    echo "export ISISROOT=/opt/conda/envs/isisasp" >> ~/.bashrc                                             && \   
    echo "source activate isisasp" >> ~/.bashrc                                                             && \
    source ~/.bashrc

WORKDIR $WORKPATH