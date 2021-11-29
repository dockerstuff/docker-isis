#!/bin/bash -e

OUTPUT_IMAGE='jupyter:gdal'

ROOT_CONTAINER='osgeo/gdal:ubuntu-small-3.4.0'

docker build -t "$OUTPUT_IMAGE" \
        --build-arg ROOT_CONTAINER="$ROOT_CONTAINER" \
        'https://github.com/jupyter/docker-stacks.git#master:base-notebook'

[ $? ] && echo "Docker image $OUTPUT_IMAGE built."
