---
title: VSCode 容器中开发相关配置
date: 2023-08-22 13:43:57
tags: [docker, vscode]
categories: 工具
---

本文主要讲解在容器中利用 VSCode 进行开发的一些配置， 容器的优势这里不再赘述，假设你已具备了镜像构建以及其基本操作

## 容器环境准备

预设以下条件

- 代码工程目录放置在 /workspace/my_project
- 开发环境镜像在 my_image (这里假设是一个ubuntu镜像)

```bash
cd /workspace/my_project

docker run -ti --entrypoint=/bin/bash \
  --net=host \
  --ipc=host \
  -v $(pwd):/$(basename $(pwd)) \
  -v $(pwd)/.vscode-server:/root/.vscode-server \
  --privileged \
  --name $(basename $(pwd))_dev \
  my_image
```

以上会启动一个 my_project_dev 容器，并将代码挂载到了容器内的 /my_project

- `-v $(pwd)/.vscode-server:/root/.vscode-server` vscode 容器开发会在容器内的 $HOME/.vscode-server 里安装一些资源或者文件，包括容器内的插件也在这里，提前挂载进去是将这部分持久化，避免重新安装

## Remote-SSH 配置

另一种方法，是在容器里启一个ssh服务，然后用ssh远程连接，和连接远程服务器一样，下面是 容器内远程连接的一些说明以及配置

1. 容器要 --net=host 启动，且要将代码挂载进容器内
2. 要选择一个容器 ssh 端口，比如 2222，连接容器内的时候要指定端口。（22通常是宿主机的 ssh 端口）

在容器安装ssh服务并开启，下面是 `ssh-rsa xxxxxxxxxxxxxxxxxxxxx` 是物理机的公钥, 用于免密登录，需要替换成自己的值。

> 公钥通常在 `$HOME/.ssh/id_rsa.pub` 下，可通过 `ssh-keygen` 生成。 

```bash
apt install openssh-server -y
mkdir /var/run/sshd
echo "ssh-rsa xxxxxxxxxxxxxxxxxxxxx" > /root/.ssh/authorized_keys

/usr/sbin/sshd -p 2222
```

物理机验证

```bash
ssh -p 2222 root@my_ip
```

验证成功后就可以使用vscode远程连接了。
