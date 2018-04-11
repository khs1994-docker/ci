#!/usr/bin/env bash

print_help_info(){
  exec echo "
CI-CLI v18.06

Official WebSite https://ci.khs1994.com

Usage: ./ci.sh COMMAND

Commands:

  change-mysql-root-password

  up

  config

  up-tls

  tls-config

  down

  swarm-deploy

  swarm-remove

  k8s-deploy

  k8s-remove

  reset

Read './docs/*.md' for more information about CLI commands.

You can open issue in [ https://github.com/khs1994-docker/ci/issues ] when you meet problems.

You must Update .env file when update this project.

Donate https://zan.khs1994.com
"
}

_cp(){
  if [ ! -f $1 ];then cp $2 $1; fi
}

_init(){
  _cp .env .env.example
  _cp gogs/app.ini gogs/app.example.ini
  _cp registry/config.yml registry/config.example.yml

  cd webhooks

  _cp .env .env.example
  _cp update.js update.example.js
  _cp update.sh update.example.sh

  cd ../

  command -v docker-compose > /dev/null 2>&1

  if [ $? -ne 0 ];then exec echo "docker-compose not install" ; fi
}

_reset(){
  rm -rf .env \
      gogs/app.prod.ini gogs/app.port.ini registry/config.yml registry/config.port.yml \
      webhooks/.env \
      webhooks/update.js \
      webhooks/update.sh
}

_change_mysql_root_password(){
 echo 1
}

_up(){
    sed -i
    docker-compose up ${CI_INCLUDE:-drone-server drone-agent gogs registry}
}

_up-tls(){
    sed -i
    docker-compose up ${CI_INCLUDE:-drone-server drone-agent gogs registry}
}

_down(){
  docker-compose down --remove-orphans
}

set -e

_init

. .env

. ~/.bash_profile || echo

test ! -z "$1" || print_help_info

command=$1

shift

_$command "$@"
