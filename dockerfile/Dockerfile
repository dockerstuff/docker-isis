FROM continuumio/miniconda3

MAINTAINER "Carlos Brandt <carloshenriquebrandt at gmail>"

RUN conda create -n isis3 python=3.6                      &&\
    conda activate isis3                                  &&\
    conda config --env --add channels conda-forge         &&\
    conda config --env --add channels usgs-astrogeology   &&\
    conda install -c usgs-astrogeology isis3              &&\
    python $CONDA_PREFIX/scripts/isis3VarInit.py          \
      --data-dir='/work/data'                             \
      --test-dir='/work/data_test'

RUN git clone -b stable https://github.com/chbrandt/docker_entrypoint.git && \
    ln -sf docker_entrypoint/entrypoint.sh /.

ENTRYPOINT ["/entrypoint.sh"]
