#!/bin/bash

BASE_IMAGE='myjupyter:gdal'

docker build -t jupyter:isis -f jupyter.dockerfile \
        --build-arg BASE_IMAGE=$BASE_IMAGE .
