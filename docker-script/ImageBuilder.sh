#!/bin/bash

jupyter="y"
SHORT=J:,j:,h
LONG=JUPYTER:,jupyter:,help
OPTS=$(getopt -a -n test --options $SHORT --longoptions $LONG -- "$@")
eval set -- "$OPTS"
while :
do
  case "$1" in
    -J | --JUPYTER )
      jupyter="$2"
      shift 2
      ;;
    -j | --jupyter )
      jupyter="$2"
      shift 2
      ;;
    -h | --help)
      echo -e "This is a script to build docker-isis-asp + jupyter:
            \n-j to install jupyter - default: $jupyter"
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
GDAL_VERSION='3.4.0'
JUPYTER_ENABLE_LAB='yes'
DOCKERFILE=isis5-asp.dockerfile

echo "ISIS version $ISIS_VERSION will be installed"
echo "NASA_Ames Stereo Pipeline 3.0.0 will be installed"
echo "Jupyter install: $jupyter"
read -p "Continue? " -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]
then
    BASE_IMAGE="osgeo/gdal:ubuntu-small-$GDAL_VERSION"

if [[ $jupyter =~ ^[Yy1]$ ]]
    then
      echo "\n-j Creating jupyter:gdal image"
      JUPYTER_IMAGE="jupyter:gdal_$GDAL_VERSION"
      git clone 'https://github.com/jupyter/docker-stacks.git'
      (
      cd docker-stacks
      docker build -t "$JUPYTER_IMAGE"                 \
              --build-arg ROOT_CONTAINER="$BASE_IMAGE" \
              base-notebook/
      )

[ $? ] && rm -rf docker-stacks && echo "Docker image $OUTPUT_IMAGE built."

      ISIS_IMAGE="isis_$ISIS_VERSION:jupyter"
      BASE_IMAGE=$JUPYTER_IMAGE
  else
      ISIS_IMAGE="isis_$ISIS_VERSION:gdal"
      JUPYTER_ENABLE_LAB='no'
fi
    echo "Creating $ISIS_IMAGE image"
    docker build -t "$ISIS_IMAGE"                              \
            --build-arg BASE_IMAGE="$BASE_IMAGE"               \
            --build-arg ISIS_VERSION="$ISIS_VERSION"           \
            --build-arg ASP_VERSION="$ASP_VERSION"             \
            --build-arg JUPYTER_ENABLE_LAB=$JUPYTER_ENABLE_LAB \
            -f $PWD/dockerfiles/$DOCKERFILE .
    [ $? ] && echo "Docker image $ISIS_IMAGE built."
else
    echo "Aborting"
fi
