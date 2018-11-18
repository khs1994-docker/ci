# 私有化 CI/CD 解决方案

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/ci.svg?style=social&label=Stars)](https://github.com/khs1994-docker/ci) [![star](https://gitee.com/khs1994-docker/ci/badge/star.svg?theme=dark)](https://gitee.com/khs1994-docker/ci/stargazers)

* [支持文档](docs)

* [问题反馈](https://github.com/khs1994-docker/ci/issues)

* [更多信息](https://www.khs1994.com/categories/CI/Drone/)

## CI & DevOps 工作流程

**1.** 本地制作 Docker 镜像推送到私有仓库（Docker Registry）

**2.** 本地开发项目，项目根目录编写 `.drone.yml` 文件，推送到 git （例如，GitHub，Gogs ...）

**3** Drone 自动拉取代码完成编译，部署 (Drone 本质就是在指定的容器中运行指定的命令，通过项目根目录中的 `.drone.yml` 文件指定)。

**4** 支持哪些编程语言？理论上支持所有的编程语言！

## With TLS ?

本教程通过 IP + 不同端口 来提供不同的服务，如果你想要通过域名（`TLS`）来提供不同的服务，请查看 [README.TLS.md](README.TLS.md)。

## 准备

* 了解 CI，了解 Travis CI (Drone 和大多数 CI 工具一样，不过 Drone 可以免费的进行私有部署)

* 有公网 IP 的云服务器（推荐，但不是必须）

* Docker CE v18.09 Stable +

* docker-compose v1.23.1 +

* 知道如何注册 GitHub App (GitHub only)

* `brew install gnu-sed` (macOS only)

## 快速开始

### 安装

> 已经使用 khs1994-docker/lnmp?请直接执行 `$ cd ~/lnmp/drone`

```bash
$ git clone https://github.com/khs1994-docker/ci.git ~/ci

$ cd ci
```

#### Windows 用户使用 WSL

```bash
$ wsl
```

### 修改配置

执行以下命令完成初始化，然后修改配置。

```bash
$ ./ci
```

### 配置 hosts

修改 `.env` 中的 `CI_HOST` 变量值为 `你自己的 IP`(例如 `云服务器公网 IP`、`路由器分配给电脑的 IP`)

> Windows 用户请将 `COMPOSE_CONVERT_WINDOWS_PATHS=1` 取消注释

### MySQL 密码(可选)

修改 `secrets/mysql.env` 中的 `MYSQL_ROOT_PASSWORD` 变量值为 MySQL 密码。

### 启用软件

修改 `.env` 中的 `CI_INCLUDE` 变量。

### 使用 khs1994-docker/lnmp 的 MySQL Redis 服务（可选项）

修改 `.env` 中的 `CI_INCLUDE` 变量，若 Git 使用 `Gogs` 则只保留 `gogs` 即可，若使用 `GitHub` 请留空。

```bash
CI_INCLUDE="gogs"
```

编辑 `docker-compose.override.yml`，将以下内容取消注释。

```yaml
networks:
  backend:
    external: true
    name: lnmp_backend
  frontend:
    external: true
    name: lnmp_frontend
```

> CI 启动之前必须先启动 khs1994-docker/lnmp

### 使用外部服务？(高级选项)

编辑 `.env` 文件，编辑 `CI_INCLUDE` 变量，去掉内置的软件名，之后填写外部服务的相关配置

```bash
# CI_INCLUDE="gogs registry mysql redis"

CI_INCLUDE="gogs registry"

CI_EXTERNAL_MYSQL_HOST=
CI_EXTERNAL_MYSQL_PORT=
CI_EXTERNAL_MYSQL_USERNAME=
CI_EXTERNAL_MYSQL_PASSWORD=
CI_EXTERNAL_MYSQL_DATABASE=

CI_EXTERNAL_REDIS_HOST=
```

### 选择 Git 服务商

编辑 `docker-compose.override.yml` 文件最下方

默认使用 `Gogs` ，如需使用 `GitHub` 按如下内容修改

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
$ ./ci up [-d] [--reset]
```

## 访问服务

> 能不开放端口尽量不开放（例如数据库、缓存）。

* git HTTP **3000**

* git SSH **8022**

* drone **8000**

* registry **5000**

## 启用构建

在 `Drone` 页面登录账号，在项目列表的右边打开开关，将项目推送到 Git，可以看到 Drone 开始构建项目。

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
