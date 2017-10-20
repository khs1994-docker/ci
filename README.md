# 如何工作

本地制作 Docker 镜像推送到私有仓库（Docker Registry）

本地开发，推送到 Gogs

Drone 拉取代码完成编译，部署

# Overview

## Nginx

一种是使用本机的 Nginx，一种是直接使用本项目的 Nginx

本项目 Nginx 配置文件默认为 `使用本机 nginx`，使用时将 `conf.d` 中的文件复制到本机 nginx 配置文件夹（一般情况下为 `/etc/nginx/conf.d`）。

使用本项目的 Nginx 请在 docker-compose.yml 文件中将 nginx 部分的注释取消，并修改 `conf.d/*.conf` 的内容，里面有详细的注释，请把相关内容注释取消即可。

## 新建数据库

新建 gogs 数据库（供 Gogs 使用）

```bash
$ docker-compose -f docker-compose.mysql.yml up -d
$ docker-compose exec mysql bash
$ mysql -uroot -p
$ create database gogs;
$ docker-compose -f docker-compose.mysql.yml down
```

## 准备 SSL 证书

* git.xc725.wang
* drone.xc725.wang
* docker.xc725.wang

# Drone

参考 [官方文档](http://docs.drone.io/)，并仔细查看 `docker-compose.yml` 文件。

# Gogs

```bash
cd gogs
cp app.ini app.prod.ini
```

修改 `app.prod.ini`：

改数据库密码、邮箱服务器密码等

# 注意

Drone 使用新的容器来拉取 git 代码（Drone 启动的容器不能配置 host），这就要求 `git 服务器` 必须是「公网地址」（即公共 DNS 能够解析该 `git 网址`），当然也可以在 docker 的 daemon.json 文件中定义私有 `DNS 服务器`，来将 `git 服务器` 指向私有地址。

遇到这个问题的人看一下就明白了，这里不再赘述。

# More Information

* [Gogs](https://github.com/gogits/gogs)
* [Gogs Docker](https://github.com/gogits/gogs/tree/master/docker)
* [Drone](https://github.com/drone)
* [Drone Documents](http://docs.drone.io/)
* [Drone Docker](https://store.docker.com/profiles/drone)
