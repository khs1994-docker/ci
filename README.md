# 私有化 CI/CD 解决方案

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/ci.svg?style=social&label=Stars)](https://github.com/khs1994-docker/ci)

## 如何工作

**1.** 本地制作 Docker 镜像推送到私有仓库（Docker Registry）

**2.** 本地开发项目，根目录编写 `.drone.yml` 文件，推送到 git （例如，GitHub，Gogs ...）

**3** Drone 自动拉取代码完成编译，部署 (Drone 本质就是在指定的容器中运行指定的命令，通过项目根目录中的 `.drone.yml` 文件指定)。

更多信息：https://www.khs1994.com/categories/CI/Drone/

## 使用示例

* [Hexo](https://github.com/khs1994-php/hexo)

* [Gitbook](https://github.com/khs1994-php/gitbook)

* [PHP](https://github.com/khs1994-php/tencent-ai)

## 疑问

你可以在 [Issue](https://github.com/khs1994-docker/ci/issues) 来提出你部署及使用过程中遇到的问题。

## TLS

本 `REAADME.md` 的教程通过端口来提供不同的服务，如果你想要通过域名（`With TLS`）来提供不同的服务，请查看 [README.TLS.md](README.TLS.md) 文件。

## 端口暴露

* `Gogs` **3000** **1022**

* `Drone` **8000**

* `Docker Registry` **5000**

* `MYSQL` **13306**(默认不暴露)

* `REDIS` **16379**(默认不暴露)

## 修改配置

执行以下命令完成初始化，然后修改配置。

```bash
$ ./ci.sh
```

修改 `.env` 中的 `DRONE_HOST_BASED_PORT` 为 `你自己的 IP`(例如 `云服务器公网 IP`、`路由器分配给电脑的 IP`)

`gogs/app.port.ini` `registry/config.port.yml`

搜索 `192.168.199.100` 为 `你自己的 IP`

在 `config/mysql.env` 中配置密码，对应的也要修改 `gogs/app.port.ini` 中的 MySQL 密码（`PASSWD` 项）。

## 启动

```bash
$ docker-compose up -d
```

## 访问服务

* git HTTP **3000**

* git SSH **1022**

* drone **8000**

* registry **5000**

## 最佳实践

https://www.khs1994.com/categories/CI/Drone/

## More Information

* [Gogs](https://github.com/gogits/gogs)

* [Gogs Docker](https://github.com/gogits/gogs/tree/master/docker)

* [Drone](https://github.com/drone)

* [Drone Documents](http://docs.drone.io/)

* [Drone Docker](https://store.docker.com/profiles/drone)
