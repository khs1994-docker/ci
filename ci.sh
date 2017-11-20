#!/usr/bin/env sh

if [ ! -f .env ];then cp .env.example .env; fi
if [ ! -f app.prod.ini ];then cp gogs/app.ini gogs/app.prod.ini; fi

cd webhooks

if [ ! -f .env ];then cp .env.example .env; fi
if [ ! -f update.js ];then cp update.example.js update.js; fi
if [ ! -f update.sh ];then cp update.example.sh update.sh; fi

cd ../

if [ "$1" = "production" ];then echo "You are in Production, Please exec\n"; echo "$ docker-compose -f docker-compose.prod.yml up -d\n"; exit 0; fi
if [ "$1" = "swarm" ];then echo -e "\nYou are in Docker Swarm, Please exec\n\n$ docker swarm init\n$ docker stack deploy -c docker-compose.swarm.yml ci\n"; exit 0; fi

command -v docker-compose > /dev/null 2>&1

if [ $? -ne 0 ];then echo "docker-compose not install"; exit 1; fi

echo
echo "You are in Local Development,please exec"
echo "$ docker-compose up -d mysql"
echo "$ docker-compose exec mysql mysql -uroot -pmytest"
echo "CREATE DATABASE gogs;"
echo "$ exit"
echo "$ docker-compose up -d"
echo
