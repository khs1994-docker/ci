# 私有化 CI/CD 解决方案

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/ci.svg?style=social&label=Stars)](https://github.com/khs1994-docker/ci) [![star](https://gitee.com/khs1994-docker/ci/badge/star.svg?theme=dark)](https://gitee.com/khs1994-docker/ci/stargazers)

* [支持文档](docs)

* [问题反馈](https://github.com/khs1994-docker/ci/issues)

## 重要提示

本项目基于 [Drone `2.x`](https://docs.drone.io/) 版本。

## 微信订阅号

<p align="center">
<img width="200" src="https://user-images.githubusercontent.com/16733187/46847944-84a96b80-ce19-11e8-9f0c-ec84b2ac463e.jpg">
</p>

<p align="center"><strong>关注项目作者微信订阅号，接收项目最新动态</strong></p>

## CI & DevOps 工作流程

**1.** 本地编写 Dockerfile，CI 构建镜像推送到私有仓库（Docker Registry）

**2.** 本地开发项目，项目根目录编写 `.drone.yml` 文件，推送到 git （例如，GitHub，Gogs ...）

**3** Drone 自动拉取代码完成编译，部署 (Drone 本质就是在指定的容器中运行指定的命令，通过项目根目录中的 `.drone.yml` 文件指定)。

**4** 支持哪些编程语言？理论上支持所有的编程语言！

## With TLS ?

本教程通过 IP + 不同端口 来提供不同的服务，如果你想要通过域名（`TLS`）来提供不同的服务，请查看 [README.TLS.md](README.TLS.md)。

## 准备

* 了解 CI(Drone 和大多数 CI 工具一样，不过 Drone 可以免费的进行私有部署)

* 有公网 IP 的云服务器（推荐，但不是必须）

* Docker CE v18.09 Stable +

* docker-compose v1.23.1 +

* 知道如何注册 GitHub App (GitHub only)

* `$ brew install gnu-sed` (macOS only)

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

### MySQL 密码(可选)

修改 `secrets/mysql.env` 中的 `MYSQL_ROOT_PASSWORD` 变量值为 MySQL 密码。

### 安全

在 `.env` 文件中配置如下两个变量

* `DRONE_USER_CREATE` Drone 启动时创建哪些用户
* `DRONE_USER_FILTER` Drone 允许哪些用户注册，留空即表示允许所有用户注册，将会造成资源浪费，**强烈建议** 配置该选项

### 启用软件

修改 `.env` 中的 `CI_INCLUDE` 变量。

### 使用 khs1994-docker/lnmp 的 MySQL Redis 服务（可选项）

修改 `.env` 中的 `CI_INCLUDE` 变量，若 Git 使用 `Gogs` 则只保留 `gogs` 即可，若使用 `GitHub` 请留空 `CI_INCLUDE=""`。

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

> 启动之前必须先启动 khs1994-docker/lnmp

### 使用外部服务(高级选项)

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
```

## 启动

```bash
$ ./ci up --config
```

检查 `docker-compose.yml` 配置是否正确，之后启动

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

在 `Drone` 页面登录账号，点击右上角 `sync` 按钮，在项目列表点击项目，并启用。之后将项目推送到 Git，可以看到 Drone 开始构建项目。

## 使用示例

* [PHP](https://github.com/khs1994-php/tencent-ai)

## More Information

* [Gogs](https://github.com/gogs/gogs)

* [Gogs Docker](https://github.com/gogs/gogs/tree/master/docker)

* [Drone](https://github.com/drone)

* [Drone Documents](https://docs.drone.io/)

* [Drone Docker](https://hub.docker.com/u/drone)
