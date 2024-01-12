---
title: 一键安装 Docker
date: 2022-06-19 09:14:19
tags: [docker]
categories: 工具
---

## 安装 docker

```bash
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable" -y
sudo apt update
sudo apt --fix-broken install -y docker.io
sudo groupadd docker
sudo gpasswd -a $USER docker
sudo systemctl restart docker
```

## 安装 nvidia-docker

```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
```

验证是否安装成功

```bash
docker run -ti --gpus=all ubuntu:18.04 nvidia-smi
```

## nvidia-driver

```bash
# 先卸载
sudo apt-get --purge remove "*nvidia*"

# 查看 可用驱动版本
apt list | grep nvidia-driver

# 选择一个版本安装, 比如 530
sudo apt install nvidia-driver-530

# 重启机器
sudo reboot
```

## 其他设置

**锁定内核版本**

锁定内核当前使用版本，否则系统有可能自动更新内核，那样 nvidia-driver 也要重新安装

```bash
sudo apt-mark hold linux-image-$(uname -r)
```