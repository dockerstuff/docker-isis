#!/bin/bash

IMAGE_NAME='my_isis5:gdal'

docker build -t "$IMAGE_NAME" \
	--build-arg ISIS_VERSION='5' \
	--build-arg BASE_IMAGE='osgeo/gdal:ubuntu-small-3.3.0' \
	-f Dockerfile .

[ $? ] && echo "Image '$IMAGE_NAME' created" || echo "Something FAILED"

