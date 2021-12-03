#!/bin/bash -e

OUTPUT_IMAGE='jupyter:gdal'

ROOT_CONTAINER='osgeo/gdal:ubuntu-small-3.4.0'

git clone 'https://github.com/jupyter/docker-stacks.git'
(
cd docker-stacks/
docker build -t "$OUTPUT_IMAGE" \
        --build-arg ROOT_CONTAINER="$ROOT_CONTAINER" \
        base-notebook/
)
[ $? ] && rm -rf docker-stacks && echo "Docker image $OUTPUT_IMAGE built."
