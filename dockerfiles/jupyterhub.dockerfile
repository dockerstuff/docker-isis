ARG BASE_IMAGE=ubuntu:20.04
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
    && python3 -m pip --no-cache-dir install \
                          jupyterlab jupyterhub \
                          oauthenticator \
                          dockerspawner \
                          netifaces \
                          psycopg2-binary


RUN curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash - \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
          nodejs
RUN npm install -g configurable-http-proxy

#COPY ../dockerfiles/jupyterhub_conf /srv/jupyterhub
#CMD ["jupyterhub", "--config=/srv/jupyterhub/jupyterhub_config.py", "--port=8000"]
