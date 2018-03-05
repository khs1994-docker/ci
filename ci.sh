#!/usr/bin/env sh

if [ ! -f .env ];then cp .env.example .env; fi
if [ ! -f app.prod.ini ];then cp gogs/app.ini gogs/app.prod.ini; fi
if [ ! -f registry/config.yml ];then cp registry/config.default.yml registry/config.yml; fi
if [ ! -f gogs/app.port.ini ];then cp gogs/app.port.example.ini gogs/app.port.ini; fi
if [ ! -f registry/config.port.yml ];then cp registry/config.port.example.yml registry/config.port.yml; fi

cd webhooks

if [ ! -f .env ];then cp .env.example .env; fi
if [ ! -f update.js ];then cp update.example.js update.js; fi
if [ ! -f update.sh ];then cp update.example.sh update.sh; fi

cd ../

command -v docker-compose > /dev/null 2>&1

if [ $? -ne 0 ];then echo "docker-compose not install"; exit 1; fi

if [ "$1" = "production" ];then
  echo "You are in Production, Please exec\n"
  exec echo "$ docker-compose -f docker-compose.github.yml -f docker-compose.other.yml up -d\n"
fi

if [ "$1" = "swarm" ];then
  exec echo "\nYou are in Swarm mode, Please exec\n\n$ docker swarm init\n\n$ docker stack deploy -c docker-stack.yml ci\n"
fi

if [ "$1" = "khs1994" ];then
  exec echo "Please exec\n\n$ docker-compose -f docker-compose.yml -f docker-compose.khs1994.yml up -d\n"
fi

if [ "$1" = 'down' ];then exec docker-compose down --remove-orphans; fi

echo "Maybe You are in Local Development, please exec

$ docker-compose -f docker-compose.gogs.yml -f docker-compose.other.yml up -d
"
