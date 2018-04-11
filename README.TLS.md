# 私有化 CI/CD 解决方案 (TLS)

## 内部端口

* `Gogs` **3000** **22**

* `Drone` **8000**

* `Docker Registry` **5000**

## 准备

* 域名

* `*.t.khs1994.com` 通配符 TLS 证书 （acme.sh 可以免费申请）

## 快速开始

### 初始化

首次使用本项目时，务必执行以下命令完成初始化。

```bash
$ ./ci.sh
```

### 编辑 `.env` 文件

* `CI_HOST` 为主机 IP (建议使用 内网 IP, example 192.168.199.100)

* `CI_DOMAIN` 为服务主域名（example t.khs1994.com）

### `443` 端口是否占用

根据 `443` 端口是否占用情况，使用下面的命令启动 CI `服务`。

* 已占用->实体机运行 NGINX

  ```bash
  $ ./ci.sh up-tls --use-external-nginx=/etc/nginx/conf.d
  ```

  重启 NGINX

* 已占用->容器运行 NGINX

  ```bash
  $ ./ci.sh up-tls --use-external-nginx=/etc/nginx/conf.d
  ```

  重启 NGINX 容器

* 未占用

  ```bash
  $ ./ci.sh up-tls [-d] [--reset]
  ```
