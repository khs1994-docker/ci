#!/usr/bin/env bash

print_help_info(){
  exec echo "
CI-CLI v18.06

Official WebSite https://ci.khs1994.com

Usage: ./ci.sh COMMAND

Debug: [env] DEBUG=1 ./ci.sh COMMAND

Commands:

  change-mysql-root-password

  up [-d] [--open-port] [--reset]

  config [--open-port]

  up-tls [-d] [--open-port] [--reset]

  tls-config [--open-port]

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
  _cp docker-compose.override.yml docker-compose.override.demo.yml
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
      docker-compose.override.yml \
      gogs/app.ini \
      registry/config.yml \
      webhooks/.env \
      webhooks/update.js \
      webhooks/update.sh
}

_change_mysql_root_password(){
 echo 1
}

_up(){
    sed -i "s#{{ CI_DOMAIN }}#${CI_BASED_PORT_DRONE_HOST:-192.168.199.100}#g" gogs/app.ini

    sed -i "s#{{ DB_TYPE }}#${CI_DB_TYPE:-mysql}#g" gogs/app.ini
    sed -i "s#{{ DB_HOST }}#${CI_EXTERNAL_MYSQL_HOST:-mysql}:${CI_EXTERNAL_MYSQL_PORT:-3306}#g" gogs/app.ini
    sed -i "s#{{ DB_DATABASE }}#${CI_EXTERNAL_MYSQL_DATABASE:-$MYSQL_DATABASE}#g" gogs/app.ini
    sed -i "s#{{ DB_USERNAME }}#${CI_EXTERNAL_MYSQL_USERNAME:-root}#g" gogs/app.ini
    sed -i "s#{{ DB_PASSWORD }}#${CI_EXTERNAL_MYSQL_PASSWORD:-$MYSQL_ROOT_PASSWORD}#g" gogs/app.ini

    sed -i "s#{{ CI_DOMAIN_FULL }}#${CI_BASED_PORT_DRONE_HOST:-192.168.199.100}#g" gogs/app.ini
    sed -i "s#{{ PROTOCOL }}#http#g" gogs/app.ini
    sed -i "s!^CERT_FILE.*!#CERT_FILE!g" gogs/app.ini
    sed -i "s!^KEY_FILE.*!#KEY_FILE!g" gogs/app.ini
    sed -i "s!^TLS_MIN_VERSION.*!#TLS_MIN_VERSION!g" gogs/app.ini

    sed -i "s#{{ MAIL_HOST }}#${CI_MAIL_HOST}#g" gogs/app.ini
    sed -i "s#{{ MAIL_FROM }}#${CI_MAIL_FROM}#g" gogs/app.ini
    sed -i "s#{{ MAIL_USERNAME }}#${CI_MAIL_USERNAME}#g" gogs/app.ini
    sed -i "s#{{ MAIL_PASSWORD }}#${CI_MAIL_PASSWORD}#g" gogs/app.ini

    sed -i "s#{{ REDIS_HOST }}#${CI_EXTERNAL_REDIS_HOST:-$REDIS_HOST}#g" registry/config.yml
    sed -i "s#{{ WEBHOOKS_HOST }}#${WEBHOOKS_HOST:-192.168.199.100}#g" registry/config.yml

    sed -i "s#{{ DRONE_HOST }}#http://${CI_BASED_PORT_DRONE_HOST:-192.168.199.100}:${CI_BASED_PORT_DRONE_PORT}#g" docker-compose.override.yml
    sed -i "s#{{ DRONE_GOGS_URL }}#http://${CI_BASED_PORT_DRONE_HOST:-192.168.199.100}:${CI_BASED_PORT_GOGS_PORT=3000}#g" docker-compose.override.yml
    docker-compose ${COMPOSE_FILE:-} up ${opt:-} ${CI_INCLUDE:-drone-server drone-agent gogs registry}
}

_config(){
  docker-compose ${COMPOSE_FILE:-} config
}

_up-tls(){
    sed -i "s#{{ CI_DOMAIN }}#${CI_DOMAIN:-t.khs1994.com}#g" gogs/app.ini

    sed -i "s#{{ DB_TYPE }}#${CI_DB_TYPE:-mysql}#g" gogs/app.ini
    sed -i "s#{{ DB_HOST }}#${CI_EXTERNAL_MYSQL_HOST:-mysql}:${CI_EXTERNAL_MYSQL_PORT:-3306}#g" gogs/app.ini
    sed -i "s#{{ DB_DATABASE }}#${CI_EXTERNAL_MYSQL_DATABASE:-$MYSQL_DATABASE}#g" gogs/app.ini
    sed -i "s#{{ DB_USERNAME }}#${CI_EXTERNAL_MYSQL_USERNAME:-root}#g" gogs/app.ini
    sed -i "s#{{ DB_PASSWORD }}#${CI_EXTERNAL_MYSQL_PASSWORD:-$MYSQL_ROOT_PASSWORD}#g" gogs/app.ini

    sed -i "s#{{ CI_DOMAIN_FULL }}#git.${CI_BASED_PORT_DRONE_HOST:-t.khs1994.com}#g" gogs/app.ini
    sed -i "s#{{ PROTOCOL }}#https#g" gogs/app.ini

    sed -i "s#{{ MAIL_HOST }}#${CI_MAIL_HOST}#g" gogs/app.ini
    sed -i "s#{{ MAIL_FROM }}#${CI_MAIL_FROM}#g" gogs/app.ini
    sed -i "s#{{ MAIL_USERNAME }}#${CI_MAIL_USERNAME}#g" gogs/app.ini
    sed -i "s#{{ MAIL_PASSWORD }}#${CI_MAIL_PASSWORD}#g" gogs/app.ini

    sed -i "s#{{ REDIS_HOST }}#${CI_EXTERNAL_REDIS_HOST:-$REDIS_HOST}#g" registry/config.yml
    sed -i "s#{{ WEBHOOKS_HOST }}#${WEBHOOKS_HOST:-192.168.199.100}#g" registry/config.yml
    docker-compose ${COMPOSE_FILE:-} up ${opt:-} ${CI_INCLUDE:-drone-server drone-agent gogs registry}
}

_tls-config(){
  docker-compose ${COMPOSE_FILE:-} config
}

_down(){
  docker-compose down --remove-orphans
}

set -e

if [ "$DEBUG" = 'true' ];then set -x; fi

OS=`uname -s`

test $OS = 'Darwin' && export PATH=/usr/local/opt/gnu-sed/libexec/gnubin:$PATH

_init

. .env

. ~/.bash_profile || echo

test ! -z "$1" || print_help_info

command=$1

shift

for arg in "$@"
do
  test $arg = '--open-port' && COMPOSE_FILE='-f docker-compose.yml -f docker-compose.override.yml -f docker-compose.port.yml'
  test $arg = '-d' && opt='-d'
  test $arg = '--reset' && ( _reset ; _init )
done

_$command "$@"
