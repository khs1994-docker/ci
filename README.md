# 私有化 CI/CD 解决方案

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/ci.svg?style=social&label=Stars)](https://github.com/khs1994-docker/ci)

* [问题反馈](https://github.com/khs1994-docker/ci/issues)

* [更多信息](https://www.khs1994.com/categories/CI/Drone/)

## 如何工作

**1.** 本地制作 Docker 镜像推送到私有仓库（Docker Registry）

**2.** 本地开发项目，项目根目录编写 `.drone.yml` 文件，推送到 git （例如，GitHub，Gogs ...）

**3** Drone 自动拉取代码完成编译，部署 (Drone 本质就是在指定的容器中运行指定的命令，通过项目根目录中的 `.drone.yml` 文件指定)。

**4** 支持哪些编程语言？理论上支持所有的编程语言！

## TLS

本教程通过端口来提供不同的服务，如果你想要通过域名（`With TLS`）来提供不同的服务，请查看 [README.TLS.md](README.TLS.md)。

## 准备

* 有公网 IP 的云服务器（推荐，但不是必须）

* Docker CE v18.03 Stable +

* docker-compose v1.20.1 +

* 知道如何注册 GitHub App (GitHub only)

* `brew install gnu-sed` (macOS only)

## 快速开始

### 安装

```bash
$ git clone -b v18.03 https://github.com/khs1994-docker/ci.git ~/ci

$ cd ci
```

### 修改配置

执行以下命令完成初始化，然后修改配置。

```bash
$ ./ci.sh
```

修改 `.env` 中的 `CI_BASED_PORT_DRONE_HOST` 变量值为 `你自己的 IP`(例如 `云服务器公网 IP`、`路由器分配给电脑的 IP`)

### MySQL 密码

修改 `.env` 中的 `MYSQL_ROOT_PASSWORD` 变量值为 MySQL 密码。

### 启用软件

修改 `.env` 中的 `CI_INCLUDE` 变量。

### 使用外部服务？

### 选择 Git 服务商

编辑 `docker-compose.override.yml` 文件最下方

默认使用 `Goos` ，如需使用 `GitHub` 按如下内容修改

```yaml

...

services:
  drone-server:
    # << : *gogs
    << : *github
    # << : *coding
    # << : *khs1994
```

## 启动

```bash
$ ./ci.sh up [-d] [--reset]
```

## 访问服务

> 能不开放端口尽量不开放（例如数据库、缓存）。

* git HTTP **3000**

* git SSH **8022**

* drone **8000**

* registry **5000**

## 使用示例

* [HEXO](https://github.com/khs1994-php/hexo)

* [GitBook](https://github.com/khs1994-php/gitbook)

* [PHP](https://github.com/khs1994-php/tencent-ai)

## 最佳实践

https://www.khs1994.com/categories/CI/Drone/

## More Information

* [Gogs](https://github.com/gogits/gogs)

* [Gogs Docker](https://github.com/gogits/gogs/tree/master/docker)

* [Drone](https://github.com/drone)

* [Drone Documents](http://docs.drone.io/)

* [Drone Docker](https://store.docker.com/profiles/drone)
