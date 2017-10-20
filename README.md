# Overview

新建 gogs 数据库

```bash
$ docker-compose -f docker-compose.mysql.yml up -d
$ docker-compose exec mysql bash
$ mysql -uroot -p
$ create database gogs;
$ docker-compose -f docker-compose.mysql.yml down
```

准备 SSL 证书

* git.xc725.wang
* drone.xc725.wang

# Drone

# Gogs

* cp app.ini app.prod.ini
* 改数据库密码、邮箱服务器密码

# More

* [Gogs](https://github.com/gogits/gogs)
* [docker-gogs](https://github.com/gogits/gogs/tree/master/docker)
