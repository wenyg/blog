---
title: 一键安装 Docker
date: 2022-06-19 09:14:19
tags: [docker]
categories: 工具
---

```bash
#pre-install

#add & verify key
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable" -y
sudo apt update
sudo apt --fix-broken install -y
sudo groupadd docker
sudo gpasswd -a $USER docker
sudo systemctl restart docker
```

<!-- more -->