#!/usr/bin/env sh

if [ ! -f .env ];then cp .env.example .env; fi
if [ ! -f app.prod.ini ];then cp gogs/app.ini gogs/app.prod.ini; fi
if [ ! -f registry/config.yml ];then cp registry/config.default.yml registry/config.yml; fi

cd webhooks

if [ ! -f .env ];then cp .env.example .env; fi
if [ ! -f update.js ];then cp update.example.js update.js; fi
if [ ! -f update.sh ];then cp update.example.sh update.sh; fi

cd ../

command -v docker-compose > /dev/null 2>&1

if [ $? -ne 0 ];then echo "docker-compose not install"; exit 1; fi

if [ "$1" = "production" ];then echo "You are in Production, Please exec\n"; exec echo "$ docker-compose -f docker-compose.github.yml up -d\n"; fi
if [ "$1" = "swarm" ];then exec echo "\nYou are in Swarm mode, Please exec\n\n$ docker swarm init\n\n$ docker stack deploy -c docker-stack.yml ci\n"; fi
if [ "$1" = 'down' ];then exec docker-compose -f docker-compose.override.yml down; fi

echo "You are in Local Development, please exec

$ docker-compose -f docker-compose.gogs.yml -f docker-compose.override.yml up -d
"
