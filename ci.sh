#!/usr/bin/env sh

if [ ! -f .env ];then cp .env.example .env; fi
if [ ! -f app.prod.ini ];then cp gogs/app.ini gogs/app.prod.ini; fi

cd webhooks

if [ ! -f ".env" ];then cp .env.example .env; cp update.example.js update.js; cp update.example.sh update.sh; fi
