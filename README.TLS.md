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

## `443` 端口是否占用

根据 `443` 端口是否占用情况，使用下面的命令启动。

* 已占用->实体机运行 NGINX

  ```bash
  $ ./ci.sh up-tls --use-external-nginx=/etc/nginx/conf.d
  ```

* 已占用->容器运行 NGINX

  ```bash
  $ ./ci.sh up-tls --use-external-nginx=container
  ```

  使用时将 `conf.d` 中的 `*.conf` `ssl` `auth` 文件复制到其他的文件夹中。

  将三个 `*.conf` 中的 `registry-server` `drone-server` `gogs-server` 字段替换为本机路由器分配的地址。

  之后将配置文件挂载到已存在的 nginx 容器中。

* 未占用

  ```bash
  $ ./ci.sh up-tls [-d] [--reset]
  ```
