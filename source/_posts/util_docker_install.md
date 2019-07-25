---
title: Ubuntu18.04 安装 Docker
tags: [docker]
categories: 工具
date: 2019-07-08 17:38:55
---

### Docker安装

1. 更换国内软件源，推荐 [清华大学开源软件镜像源](https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/) 。Ubuntu的软件配置文件是`/etc/apt/sources.list`, 将系统自带的文件做个备份，将该文件替换为下面内容，即可使用清华的软件源镜像。

   ``` text
   # 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
   deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
   # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
   deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
   # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
   deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
   # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
   deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
   # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
   ```

   <!-- more -->

2. 如果你过去安装过docker，先删掉：

   ```bash
   sudo apt-get remove docker docker-engine docker.io
   ```

3. 首先安装依赖

   ```bash
   sudo apt-get install apt-transport-https ca-certificates \
      curl gnupg2 software-properties-common
   ```

4. 信任Docker的GPG公钥

   ```bash
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
   ```

5. 添加清华的软件仓库

   ```bash
   sudo add-apt-repository \
      "deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu \
      $(lsb_release -cs) \
      stable"
   ```

6. 安装

   ```bash
   sudo apt-get update
   sudo apt-get install docker-ce
   ```

### Docker一些设置

1. 设置开机启动。(安装后默认设置开机启动，可忽略)

   ```bash
   sudo systemctl enable docker
   sudo systemctl start docker
   ```

2. 添加当前用户到docker用户组，可以不用 sudo 运行docker

   ```bash
   sudo groupadd docker
   sudo usermod -aG docker $USER
   ```
   