#!/usr/bin/env bash

case $1 in
  ci )
    cd webhooks
    if [ ! -d "node_modules" ];then
       npm install
    elif [ ! -f ".env" ];then
       cp .env.example .env
       cp update.example.js update.js
       cp update.example.sh update.sh
    fi
    echo "修改端口号，密钥之后在 webhooks/ 执行 docker-compose up -d"
  ;;
  * )
  echo -e "khs1994-docker/ci Powered By Gogs & Drone & Registry
  ci Start webhooks server
  "
  ;;
esac
