---
title: 常见工具国内镜像源
date: 2023-12-18 16:54:44
tags: [proxy, docker, apt, pip, npm]
categories: 工具 
---

## docker 镜像

在 `/etc/docker/daemon.json` 添加以下内容

```json
{
    "registry-mirrors":[
        "https://registry.docker-cn.com",
        "https://docker.mirrors.ustc.edu.cn/",
        "https://mirror.ccs.tencentyun.com/"
    ]
}
```

##  ubuuntu apt 源

/etc/apt/sources.list 替换为 清华源

```shell
sed -i 's/http:\/\/\(archive\|security\).ubuntu.com\/ubuntu\//http:\/\/mirrors.tuna.tsinghua.edu.cn\/ubuntu\//g' /etc/apt/sources.list
```

## npm 

方法一:

```bash
alias cnpm="npm --registry=https://registry.npmmirror.com \ --cache=$HOME/.npm/.cache/cnpm \ --disturl=https://npmmirror.com/mirrors/node \ --userconfig=$HOME/.cnpmrc"
```

方法二:

```bash
npm config set registry https://registry.npmmirror.com
```

## pip

```bash
python -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade pip
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
```

##  oh-my-zsh

```bash
git clone https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git
cd ohmyzsh/tools
REMOTE=https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git sh install.sh
```