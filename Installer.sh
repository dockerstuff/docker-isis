#!/bin/bash

jhub="y"
SHORT=JH:,jh:,h
LONG=JHUB:,jhub:,help
OPTS=$(getopt -a -n jupyterhub --options $SHORT --longoptions $LONG -- "$@")
eval set -- "$OPTS"
while :
do
  case "$1" in
    -JH | --JHUB )
      jhub="$2"
      shift 2
      ;;
    -jh | --jhub )
      jhub="$2"
      shift 2
      ;;
    -h | --help)
      echo -e "This is a script to build standalone docker-isis5-asp3-gispy + jupyter lab or jupyterhub with dockerspawner isis5asp3-gispy:
            \nDefaut JUPYTERHUB+dockerspawner!
            \n-n to install Standalone"
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

if [[ $jhub =~ ^[Yy1]$ ]]
  then
    set -o allexport
    source .env
    set +o allexport

    echo $DOCKER_NETWORK_NAME
    echo $HUB_DATA_VOL
    echo $HUB_DB_VOL
    echo $HUB_DATA_VOL_PATH
    echo $HUB_DB_VOL_PATH
    echo $ISIS_DATA_VOL
    echo $ISIS_DATA_PATH
    echo $POSTGRES_DB
    echo $PRESET_NB_DATA_VOL_PATH

    echo "Creating docker network and volumes"
    docker network inspect $DOCKER_NETWORK_NAME >/dev/null 2>&1 || docker network create $DOCKER_NETWORK_NAME
    echo "Docker network created: ${DOCKER_NETWORK_NAME}"
    docker volume inspect $HUB_DATA_VOL > /dev/null 2>&1 || docker volume create --driver local --opt type=volume --opt device=$HUB_DATA_VOL_PATH --opt o=bind --name $HUB_DATA_VOL
    echo "Docker volumes created: ${HUB_DATA_VOL}"
    docker volume inspect $HUB_DB_VOL > /dev/null 2>&1 || docker volume create --driver local --opt type=volume --opt device=$HUB_DB_VOL_PATH --opt o=bind --name $HUB_DB_VOL
    echo "Docker volumes created: ${HUB_DB_VOL}"
    docker volume inspect $ISIS_DATA_VOL > /dev/null 2>&1 || docker volume create --driver local --opt type=volume --opt device=$ISIS_DATA_PATH --opt o=bind --name $ISIS_DATA_VOL
    echo "Docker volumes created: ${ISIS_DATA_VOL}"
    docker volume inspect $PRESET_NB_DATA_VOL > /dev/null 2>&1 || docker volume create --driver local --opt type=volume --opt device=$PRESET_NB_DATA_VOL_PATH --opt o=bind --name $PRESET_NB_DATA_VOL
    echo "Docker volumes created: ${PRESET_NB_DATA_VOL}"
    echo "Building base images"
    sleep 2
    ./scripts/ImageBuilder.sh
    docker-compose --f docker-compose.yml --env-file .env build
  else
    ./scripts/ImageBuilder_standalone.sh
fi
