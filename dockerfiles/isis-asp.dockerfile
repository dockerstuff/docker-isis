ARG BASE_IMAGE="gmap/jupyter-isis:latest"
FROM $BASE_IMAGE

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

USER root
RUN [ -n "${BASE_IMAGE##*isis*}" ]                  && \
    apt-get update -y                               && \
    apt-get install -y --no-install-recommends      \
        bzip2                                       \
        ca-certificates                             \
        curl                                        \
        git                                         \
        libgl1-mesa-glx                             \
        libjpeg9                                    \
        libjpeg9-dev                                \
        rsync                                       \
        wget                                        \
        vim                                         && \
    rm -rf /var/lib/apt/lists/*                     && \
    apt-get autoremove                              || \ 
    echo "Nothing apt-installed, base 'isis' image already did it."
USER $NB_UID

ARG ASP_VERSION=""

COPY asp.txt /tmp/asp.tmp

RUN [ -n "${ASP_VERSION}" ]                                             && \
    sed "s/\(.*stereo-pipeline\).*/\1=$ASP_VERSION/" /tmp/asp.tmp       \
        > /tmp/asp.txt                                                  || \
    cp /tmp/asp.tmp /tmp/asp.txt

RUN source activate isis                    && \
    mamba install --file /tmp/asp.txt       && \
    conda clean -a

# RUN source activate isis                                    && \
#     python -m ipykernel install --user --name 'ISIS-ASP'

RUN DOC="${HOME}/README.md"                                     && \
    echo '# AMES Stereo Pipeline'                       >> $DOC && \
    echo ''                                             >> $DOC && \
    echo 'The version installed:'                       >> $DOC && \
    echo ''                                             >> $DOC && \
    echo "- ASP version: ${ASP_VERSION}"                >> $DOC && \
    echo ''                                             >> $DOC && \
    echo '-----'                                        >> $DOC && \
    echo "> This container is based on '${BASE_IMAGE}'" >> $DOC

# RUN source activate gispy                     && \
# 	pip install -y                              \
#         asap_stereo                             \
#         pds4-tools                              \
#         rio-cogeo

# # If WORK_DIR is not defined (when notebook/user is started), use (~) Home.
# RUN echo 'conda config --add envs_dirs ${WORK_DIR:-~}/.conda/envs 2> /dev/null' \
#       >> $HOME/.bashrc

# RUN python3 -m pip install nbgitpuller
# RUN echo 'http://localhost:8888/hub/user-redirect/git-pull?repo=https%3A%2F%2Fgithub.com%2Feuroplanet-gmap%2FBasemappingUtils&urlpath=lab%2Ftree%2FBasemappingUtils%2FREADME.md&branch=master' > $HOME/README.md

# COPY etc/jupyterlab/user_settings.json /opt/conda/share/jupyter/lab/settings/overrides.json
