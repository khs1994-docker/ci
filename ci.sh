#!/usr/bin/env sh

if [ ! -f .env ];then cp .env.example .env; fi
if [ ! -f app.prod.ini ];then cp gogs/app.ini gogs/app.prod.ini; fi

cd webhooks

if [ ! -f .env ];then cp .env.example .env; fi
if [ ! -f update.js ];then cp update.example.js update.js; fi
if [ ! -f update.sh ];then cp update.example.sh update.sh; fi

cd ../

if [ "$1" = "production" ];then echo "You are in Production, Please exec\n"; echo "$ docker-compose -f docker-compose.prod.yml up -d\n"; exit 0; fi

docker-compose up -d mysql

docker-compose exec mysql mysql -uroot -pmytest

# create database gogs;
# exit
# docker-compose up -d

echo "You are in Development, Please exec\n"
echo "$ docker-compose up -d\n"
