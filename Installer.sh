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
      echo -e "This is a script to build standalone docker-isis5-asp3-gispy + jupyter lab or jupyterhub with dockerspawner isis5asp3-gispy:lab:
            \nDefaut JUPYTERHUB+dockerspawner!
            \n'-jhub -n' to install Standalone"
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

    echo "Creating docker network and volumes"
    docker network inspect $NETWORK >/dev/null 2>&1 || docker network create $NETWORK
    echo "Docker network created: ${NETWORK}"
    docker volume inspect $JHDATA > /dev/null 2>&1 || docker volume create --driver local --opt type=volume --opt device=$JHDATA_PATH --opt o=bind --name $JHDATA
    echo "Docker volumes created: ${JHDB}"
    docker volume inspect $JHDB > /dev/null 2>&1 || docker volume create --driver local --opt type=volume --opt device=$JHDB_PATH --opt o=bind --name $JHDB
    echo "Docker volumes created: ${JHDB}"
    docker volume inspect $ISISDATA > /dev/null 2>&1 || docker volume create --driver local --opt type=volume --opt device=$ISISDATA_PATH --opt o=bind --name $ISISDATA
    echo "Docker volumes created: ${ISISDATA}"
    docker volume inspect $SHARED > /dev/null 2>&1 || docker volume create --driver local --opt type=volume --opt device=$SHARED_PATH --opt o=bind --name $SHARED
    echo "Docker volumes created: ${SHARED}"
    echo "Building base images"
    sleep 2
    ./scripts/ImageBuilder.sh
    docker-compose --f docker-compose.yml --env-file .env build

  else
    ./scripts/ImageBuilder.sh
fi
