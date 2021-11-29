#!/bin/bash

SHORT=I:,i:,J:,j:,h
LONG=ISIS:,jupyter:,help
ISIS_VERSION=5
jupyter="y"
OPTS=$(getopt -a -n test --options $SHORT --longoptions $LONG -- "$@")
eval set -- "$OPTS"
while :
do
  case "$1" in
    -I | --ISIS )
      ISIS_VERSION="$2"
      shift 2
      ;;
    -i | --ISIS )
      ISIS_VERSION="$2"
      shift 2
      ;;
    -J | --jupyter )
      jupyter="$2"
      shift 2
      ;;
    -j | --jupyter )
      jupyter="$2"
      shift 2
      ;;
    -h | --help)
      echo -e "This is a script to build docker-isis-asp + jupyter:
            \n-I for ISIS version (3,4,5) - default: $ISIS_VERSION
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

if (($ISIS_VERSION >=5));
then
    ASP_VERSION='3.0.0'
    ISIS_VERSION='5.0.1'
    echo "ISIS version $ISIS_VERSION will be installed"
    echo "NASA_Ames Stereo Pipeline 3.0.0 will be installed"

elif (($ISIS_VERSION >=4)) && (($ISIS_VERSION <5))
then
    ASP_VERSION='2.7.0'
    ISIS_VERSION='4.1.0'
    echo "ISIS version $ISIS_VERSION will be installed"
    echo "NASA_Ames Stereo Pipeline 3.0.0 will be installed"

elif (($ISIS_VERSION ==3))
then
      ASP_VERSION='2.6.2'
      ISIS_VERSION='3.6.0'
      echo "ISIS version $ISIS_VERSION will be installed"
      echo "NASA_Ames Stereo Pipeline 3.0.0 will be installed"

else
    echo "ISIS version not supported"
fi
echo "Jupyter install: $jupyter"
read -p "Continue? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    BASE_IMAGE="osgeo/gdal:ubuntu-small-3.3.0"

if [[ $jupyter =~ ^[Yy1]$ ]]
    then
      echo "Creating jupyter:gdal image"
      JUPYTER_IMAGE="jupyter:gdal"
      docker build -t "$JUPYTER_IMAGE"                 \
              --build-arg ROOT_CONTAINER="$BASE_IMAGE" \
              'https://github.com/jupyter/docker-stacks.git#master:base-notebook'
      [ $? ] && echo "Docker image $JUPYTER_IMAGE built."

      ISIS_IMAGE="isis_$ISIS_VERSION:jupyter"
      BASE_IMAGE=$JUPYTER_IMAGE
      DOCKERFILE=jupyter-isis-asp.dockerfile

else
  ISIS_IMAGE="isis_$ISIS_VERSION:gdal"
  DOCKERFILE=isis-asp.dockerfile
fi

    echo "Creating $ISIS_IMAGE image"
    docker build -t "$ISIS_IMAGE"                    \
            --build-arg BASE_IMAGE="$BASE_IMAGE"  \
            --build-arg ISIS_VERSION="$ISIS_VERSION"   \
            --build-arg ASP_VERSION="$ASP_VERSION"   \
            -f $PWD/dockerfiles/$DOCKERFILE .
    [ $? ] && echo "Docker image $ISIS_IMAGE built."
else
    echo "Aborting"
fi
