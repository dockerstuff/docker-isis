FROM debian:latest

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
ENV PATH="${CONDA_PREFIX}/bin:$PATH"

RUN wget -q -O /tmp/miniconda.sh                                               \
         https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && /bin/bash /tmp/miniconda.sh -b -p ${CONDA_PREFIX}                       \
    && rm /tmp/miniconda.sh                                                    \
    && echo "export PATH=$PATH" > /etc/profile.d/conda.sh

#    && ${CONDA_PREFIX}/bin/conda clean -tipsy                                  \
#    && ln -s ${CONDA_PREFIX}/etc/profile.d/conda.sh /etc/profile.d/conda.sh    \
#    && echo "export PATH=$PATH" > /etc/profile.d/conda.sh\
#    && echo "conda activate base" >> /etc/profile.d/conda.sh

RUN conda install -y python=3.6                             \
    && conda config --env --add channels conda-forge        \
    && conda config --env --add channels usgs-astrogeology  \
    && conda install -c usgs-astrogeology isis3

ADD etc/isis.sh /etc/profile.d/isis.sh

#RUN git clone -b stable https://github.com/chbrandt/docker_entrypoint.git \
#    && ln -sf docker_entrypoint/entrypoint.sh /.
#
#ENTRYPOINT ["/entrypoint.sh"]

ENV TINI_VERSION=v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash", "-l" ]
