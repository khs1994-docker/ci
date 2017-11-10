#!/usr/bin/env sh

if [ ! -f .env ];then cp .env.example .env; fi
if [ ! -f app.prod.ini ];then cp gogs/app.ini gogs/app.prod.ini; fi

cd webhooks

if [ ! -f ".env" ];then cp .env.example .env; cp update.example.js update.js; cp update.example.sh update.sh; fi

# docker build -t khs1994/ci .
# docker run -it -d \
#   --name=ci \
#   -p 1234:7777 \
#   khs1994/ci

echo -e "修改端口号，密钥之后在 ./webhooks 执行\n
$ docker-compose up -d\n"
