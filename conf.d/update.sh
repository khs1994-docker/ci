#!/bin/bash

BASE_DIR=~/khs1994-lnmp/config/nginx/

rm -rf ${BASE_DIR}drone.conf \
       ${BASE_DIR}gogs.conf \
       ${BASE_DIR}docker-registry.conf \
       ${BASE_DIR}auth

cp -a local/. ${BASE_DIR}
