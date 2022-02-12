#!/bin/bash

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

#sleep 10
echo "Creating docker network and volumes"

#sleep 10
docker network inspect $DOCKER_NETWORK_NAME >/dev/null 2>&1 || docker network create $DOCKER_NETWORK_NAME
echo "Docker network created: ${DOCKER_NETWORK_NAME}"

docker volume inspect $HUB_DATA_VOL > /dev/null 2>&1 || docker volume create --driver local --opt type=volume --opt device=$HUB_DATA_VOL_PATH --opt o=bind --name $HUB_DATA_VOL
echo "Docker volumes created: ${HUB_DATA_VOL}"
docker volume inspect $HUB_DB_VOL > /dev/null 2>&1 || docker volume create --driver local --opt type=volume --opt device=$HUB_DB_VOL_PATH --opt o=bind --name $HUB_DB_VOL
echo "Docker volumes created: ${HUB_DB_VOL}"
docker volume inspect $ISIS_DATA_VOL > /dev/null 2>&1 || docker volume create --driver local --opt type=volume --opt device=$ISIS_DATA_PATH --opt o=bind --name $ISIS_DATA_VOL
echo "Docker volumes created: ${ISIS_DATA_VOL}"


echo "Building base images"
#sleep 5
./scripts/ImageBuilder.sh
#sleep 5
echo "COMPOSE"
docker-compose --f docker-compose.yml --env-file .env build
