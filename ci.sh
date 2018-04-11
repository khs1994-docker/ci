#!/usr/bin/env bash

print_help_info(){
  exec echo "
CI-CLI v18.06

Official WebSite https://ci.khs1994.com

Usage: ./ci.sh COMMAND

Debug: [env] DEBUG=1 ./ci.sh COMMAND options

Options:

  --port-port            开放 MySQL Redis 端口

  -d                     后台运行

  --use-external-nginx   使用外部 NGINX = 后边值为配置文件路径 (TLS Only)

Commands:

  change-mysql-root-password

  up           [-d]   [--open-port]

  config              [--open-port]

  up-tls       [-d]   [--open-port]  [--use-external-nginx=/etc/nginx/conf.d]

  tls-config          [--open-port]

  down

  swarm-deploy

  swarm-remove

  k8s-deploy

  k8s-remove

  reset           恢复原始状态

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
  _cp docker-compose.override.yml docker-compose.override.demo.yml

  cd config

  _cp gogs/app.ini gogs/app.example.ini
  _cp registry/config.yml registry/config.example.yml

  cd ../webhooks

  _cp .env .env.example
  _cp update.js update.example.js
  _cp update.sh update.example.sh

  cd ../

  cd config/nginx

  _cp docker-registry.conf demo-docker-registry.config
  _cp drone.conf demo-drone.config
  _cp gogs.conf demo-gogs.config

  cd ../../

  command -v docker-compose > /dev/null 2>&1

  if [ $? -ne 0 ];then exec echo "docker-compose not install" ; fi
}

_reset_(){
  rm -rf docker-compose.override.yml \
      config/gogs/app.ini \
      config/registry/config.yml \
      webhooks/update.js \
      webhooks/update.sh \
      config/nginx/*.conf
}

_reset(){
  _reset_
  rm -rf .env webhooks/.env
}

_change_mysql_root_password(){
 echo 1
}

_sed_common(){
  cd config
  sed -i "s#{{ DB_TYPE }}#${CI_DB_TYPE:-mysql}#g" gogs/app.ini
  sed -i "s#{{ DB_HOST }}#${CI_EXTERNAL_MYSQL_HOST:-mysql}:${CI_EXTERNAL_MYSQL_PORT:-3306}#g" gogs/app.ini
  sed -i "s#{{ DB_DATABASE }}#${CI_EXTERNAL_MYSQL_DATABASE:-$MYSQL_DATABASE}#g" gogs/app.ini
  sed -i "s#{{ DB_USERNAME }}#${CI_EXTERNAL_MYSQL_USERNAME:-root}#g" gogs/app.ini
  sed -i "s#{{ DB_PASSWORD }}#${CI_EXTERNAL_MYSQL_PASSWORD:-$MYSQL_ROOT_PASSWORD}#g" gogs/app.ini

  sed -i "s#{{ SSH_PORT }}#${CI_GOGS_SSH_PORT:-8022}#g" gogs/app.ini

  sed -i "s#{{ MAIL_HOST }}#${CI_MAIL_HOST}#g" gogs/app.ini
  sed -i "s#{{ MAIL_FROM }}#${CI_MAIL_FROM}#g" gogs/app.ini
  sed -i "s#{{ MAIL_USERNAME }}#${CI_MAIL_USERNAME}#g" gogs/app.ini
  sed -i "s#{{ MAIL_PASSWORD }}#${CI_MAIL_PASSWORD}#g" gogs/app.ini
  cd -
}

_up(){
    _reset_ ; _init
    _sed_common
    cd config
    sed -i "s#{{ CI_DOMAIN }}#${CI_HOST:-192.168.199.100}#g" gogs/app.ini

    sed -i "s#{{ CI_DOMAIN_FULL }}#${CI_HOST:-192.168.199.100}#g" gogs/app.ini

    sed -i "s#{{ PROTOCOL }}#http#g" gogs/app.ini
    sed -i "s!^CERT_FILE.*!#CERT_FILE!g" gogs/app.ini
    sed -i "s!^KEY_FILE.*!#KEY_FILE!g" gogs/app.ini
    sed -i "s!^TLS_MIN_VERSION.*!#TLS_MIN_VERSION!g" gogs/app.ini

    sed -i "s#{{ REDIS_HOST }}#${CI_EXTERNAL_REDIS_HOST:-$REDIS_HOST}#g" registry/config.yml
    sed -i "s#{{ WEBHOOKS_HOST }}#${WEBHOOKS_HOST:-http://192.168.199.100}#g" registry/config.yml
    cd -
    sed -i "s#{{ DRONE_HOST }}#http://${CI_HOST:-192.168.199.100}:${CI_DRONE_PORT:-8000}#g" docker-compose.override.yml
    sed -i "s#{{ DRONE_GOGS_URL }}#http://${CI_HOST:-192.168.199.100}:${CI_GOGS_PORT:-3000}#g" docker-compose.override.yml

    docker-compose ${COMPOSE_FILE:-} up ${opt:-} ${CI_INCLUDE:-drone-server drone-agent gogs registry}
}

_config(){
  docker-compose ${COMPOSE_FILE:-} config
}

_up-tls(){
    _reset_ ; _init
    _sed_common
    cd config
    sed -i "s#{{ CI_DOMAIN }}#${CI_DOMAIN:-t.khs1994.com}#g" gogs/app.ini

    sed -i "s#{{ CI_DOMAIN_FULL }}#git.${CI_DOMAIN:-t.khs1994.com}#g" gogs/app.ini

    sed -i "s#{{ PROTOCOL }}#https#g" gogs/app.ini

    sed -i "s#{{ REDIS_HOST }}#${CI_EXTERNAL_REDIS_HOST:-$REDIS_HOST}#g" registry/config.yml
    sed -i "s#{{ WEBHOOKS_HOST }}#${WEBHOOKS_HOST:-https://ci.t.khs1994.com/docker/webhooks}#g" registry/config.yml
    cd -
    sed -i "s#{{ DRONE_HOST }}#https://drone.${CI_DOMAIN:-t.khs1994.com}#g" docker-compose.override.yml
    sed -i "s#{{ DRONE_GOGS_URL }}#https://git.${CI_DOMAIN:-t.khs1994.com}#g" docker-compose.override.yml

    sed -i "s#{{ CI_DOMAIN }}#${CI_DOMAIN:-t.khs1994.com}#g" config/nginx/docker-registry.conf
    sed -i "s#{{ CI_DOMAIN }}#${CI_DOMAIN:-t.khs1994.com}#g" config/nginx/drone.conf
    sed -i "s#{{ CI_DOMAIN }}#${CI_DOMAIN:-t.khs1994.com}#g" config/nginx/gogs.conf

    _sed_external_nginx(){
      # 使用外部 NGINX
      cd config/nginx
      for file in $( ls *.conf )
      do
        sed -i "s#{{ CI_DOMAIN }}#${CI_DOMAIN:-t.khs1994.com}#g" $file
        sed -i "s#{{ REGISTRY_UPSTREAM }}#${CI_HOST:-192.168.199.100}#g" $file
        sed -i "s#{{ DRONE_UPSTREAM }}#${CI_HOST:-192.168.199.100}#g" $file
        sed -i "s#{{ GOGS_UPSTREAM }}#${CI_HOST:-192.168.199.100}#g" $file
      done
        cp -a $PWD/*.conf $NGINX_CONF
        mkdir -p $NGINX_CONF/ssl || echo
        if ! [ -f ssl/$CI_DOMAIN.crt ];then
            cp -a $PWD/ssl/*  $NGINX_CONF/ssl
        fi
      cd -
    }

    _sed_nginx(){
      # 使用内部 NGINX
      cd config/nginx
      for file in `ls *.conf`
      do
        sed -i "s#{{ CI_DOMAIN }}#${CI_DOMAIN:-t.khs1994.com}#g" $file
        sed -i "s#{{ REGISTRY_UPSTREAM }}#registry#g" $file
        sed -i "s#{{ DRONE_UPSTREAM }}#drone-server#g" $file
        sed -i "s#{{ GOGS_UPSTREAM }}#gogs#g" $file
      done
      cd -
    }

    set +e
    test "$ENABLE_NGINX" = 'FALSE' && _sed_external_nginx
    set -e

    test "$ENABLE_NGINX" = 'FALSE' || _sed_nginx

    docker-compose ${COMPOSE_FILE:-} up ${opt:-} ${CI_INCLUDE:-drone-server drone-agent gogs registry} \
       $( test "$ENABLE_NGINX" = 'FALSE' || echo 'nginx' )
}

_tls-config(){
  docker-compose ${COMPOSE_FILE:-} config
}

_down(){
  docker-compose down --remove-orphans
}

_logs(){
  if ! [ -f logs/nginx/access.log ];then
    mkdir -p logs/nginx
    touch logs/nginx/access.log
    touch logs/nginx/error.log
  fi
}

set -e

_logs

if [ "$DEBUG" = 'true' ];then set -x; fi

OS=`uname -s`

test $OS = 'Darwin' && export PATH=/usr/local/opt/gnu-sed/libexec/gnubin:$PATH

_init

. $PWD/.env

. $PWD/secrets/mysql.env

. ~/.bash_profile > /dev/null 2>&1 || echo

test ! -z "$1" || print_help_info

command=$1

shift

set +e
[ -z $CI_HOST ] && echo "CI_HOST not set"
[ -z $CI_DOMAIN ] && echo "CI_DOMAIN not set"
set -e

for arg in "$@"
do
  test $arg = '--open-port' && COMPOSE_FILE='-f docker-compose.yml -f docker-compose.override.yml -f docker-compose.port.yml'
  test $arg = '-d' && opt='-d'
  [[ $arg =~ --use-external-nginx=* ]] && ENABLE_NGINX=FALSE && NGINX_CONF=$( echo $arg | cut -d '=' -f 2 )
done

_$command "$@"
