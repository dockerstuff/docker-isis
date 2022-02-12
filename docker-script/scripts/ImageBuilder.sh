#!/bin/bash

gispy="y"
SHORT=G:,g:,h
LONG=GISPY:,gispy:,help
OPTS=$(getopt -a -n test --options $SHORT --longoptions $LONG -- "$@")
eval set -- "$OPTS"
while :
do
  case "$1" in
    -G | --JUPYTER )
      gispy="$2"
      shift 2
      ;;
    -g | --jupyter )
      gispy="$2"
      shift 2
      ;;
    -h | --help)
      echo -e "This is a script to build docker-isis-asp + jupyter:
            \n-j to install jupyter - default: $gispy"
      exit 2
      ;;
    --)
      shift;
      break
      ;;
    *)
      echo "Unexpected option, using defaults"
      break
      ;;
  esac
done

ASP_VERSION='3.0.0'
ISIS_VERSION='5'
GDAL_VERSION='3.4.1'
JUPYTER_ENABLE_LAB='yes'
DOCKERFILE=isis5-asp3.dockerfile
GISPY_DOCKERFILE=gispy.dockerfile

BASE_IMAGE="condaforge/mambaforge"
ISIS_IMAGE="isis5-asp3:base"

echo "ISIS version $ISIS_VERSION will be installed"
echo "NASA_Ames Stereo Pipeline 3.0.0 will be installed"
echo "GIS-python install: $gispy"

if [[ $jupyter =~ ^[Yy1]$ ]]
  then
    JUPYTER_GISPY_IMAGE="jupyter-gispy:gdal"
    docker build -t "$JUPYTER_GISPY_IMAGE"               \
            -f $PWD/dockerfiles/$GISPY_DOCKERFILE .
    BASE_IMAGE=$JUPYTER_GISPY_IMAGE
    ISIS_IMAGE="isis5-asp3:jupyter-gispy"
  else
    JUPYTER_ENABLE_LAB='no'
fi

echo "Creating $ISIS_IMAGE image"
docker build -t "$ISIS_IMAGE"                              \
        --build-arg BASE_IMAGE="$BASE_IMAGE"               \
        --build-arg ISIS_VERSION="$ISIS_VERSION"           \
        --build-arg ASP_VERSION="$ASP_VERSION"             \
        -f $PWD/dockerfiles/$DOCKERFILE .
[ $? ] && echo "Docker image $ISIS_IMAGE built."
