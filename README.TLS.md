# 私有化 CI/CD 解决方案 (TLS)

## 内部端口

* `Gogs` **3000** **22**

* `Drone` **8000**

* `Docker Registry` **5000**

## 准备

* 域名

* git.t.khs1994.com TLS 证书

* drone.t.khs1994.com TLS 证书

* docker.t.khs1994.com TLS 证书

## 快速开始

### 初始化

首次使用本项目时，务必执行以下命令完成初始化。

```bash
$ ./ci.sh
```

### 编辑 `.env` 文件

务必编辑 `.env` 文件，具体变量含义文件中的注释有详细的说明。

## `80` `443` 端口是否占用

本项目使用 `nginx` 来反向代理各种服务，各服务通过不同的网址来暴露。

### 已占用

>这里又分两种情况，一种是外部的 `nginx` 容器占用 80 端口，一种是外部非容器方式运行的 `nginx` 占用 80 端口。

#### 非容器方式运行的 nginx

使用时将 `conf.d` 中的 `*.conf` `ssl` `auth` 文件复制到本机 nginx 配置文件夹（一般情况下为 `/etc/nginx/conf.d`）。

务必修改 `/etc/hosts/`。

```bash
127.0.0.1 registry-server drone-server gogs-server
```

#### 容器方式运行的 nginx

使用时将 `conf.d` 中的 `*.conf` `ssl` `auth` 文件复制到其他的文件夹中。

将三个 `*.conf` 中的 `registry-server` `drone-server` `gogs-server` 字段替换为本机路由器分配的地址。

之后将配置文件挂载到已存在的 nginx 容器中。

### 未占用

那么就请使用本项目的 nginx，请在 `docker-compose.override.yml` 文件中将 nginx 部分的注释取消。

### 启动

```bash
$ ./ci.sh up-tls
```
