#!/bin/bash

BASE_IMAGE='jupyter:gdal'

docker build -t jupyter:isis3 -f Dockerfile.jupyter .

