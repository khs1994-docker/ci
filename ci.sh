#!/usr/bin/env sh

if [ ! -f .env ];then cp .emv.example .env; fi
if [ ! -f app.prod.ini ];then cp gogs/app.ini gogs/app.prod.ini; fi

cd webhooks

if [ ! -d "node_modules" ];then
       docker build -t test .
       docker run test --name=test sh
       docker cp test:/data/lnmp/ci/node_modules .
elif [ ! -f ".env" ];then
       cp .env.example .env
       cp update.example.js update.js
       cp update.example.sh update.sh
fi

echo -e "修改端口号，密钥之后在 ./webhooks 执行\n
$ docker-compose up -d\n"
