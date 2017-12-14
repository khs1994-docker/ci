#!/bin/bash

. ../.env

BASE_DIR=~/khs1994-lnmp/config/nginx/

rm -rf ${BASE_DIR}drone.conf \
       ${BASE_DIR}gogs.conf \
       ${BASE_DIR}docker-registry.conf \
       ${BASE_DIR}auth

cp -a *.conf ${BASE_DIR}
cp -a ssl/. ${BASE_DIR}/ssl
cp -a auth/. ${BASE_DIR}/auth

if [ `uname -s` = "Darwin" ];then

  sed -i "" "s/gogs/${DRONE_IP}/g" ${BASE_DIR}gogs.conf

  sed -i "" "s/drone-server/${DRONE_IP}/g" ${BASE_DIR}drone.conf

  sed -i "" "s/registry-server/${DRONE_IP}/g" ${BASE_DIR}docker-registry.conf

elif [ `uname -s` = "Linux"  ];then
  sed -i "s/gogs/${DRONE_IP}/g" ${BASE_DIR}gogs.conf

  sed -i "s/drone-server/${DRONE_IP}/g" ${BASE_DIR}drone.conf

  sed -i "s/registry-server/${DRONE_IP}/g" ${BASE_DIR}docker-registry.conf
fi
