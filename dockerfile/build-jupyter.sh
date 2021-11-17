#!/bin/bash

BASE_IMAGE='jupyter:gdal'

docker build -t jupyter:isis -f Dockerfile.jupyter \
        --build-arg BASE_IMAGE=$BASE_IMAGE .
