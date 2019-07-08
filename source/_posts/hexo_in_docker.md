---
title: 基于docker的hexo博客环境
tags: [docker，hexo]
categories: 工具
date: 2019-07-08 19:45:55
---

### Docker介绍

Docker 是一个开源的应用容器引擎，让开发者可以打包他们的应用以及依赖包到一个可移植的镜像中，然后发布到任何流行的 Linux或Windows 机器上，也可以实现虚拟化。容器是完全使用沙箱机制，相互之间不会有任何接口，本文讲述的是如何基于docker构建一个博客环境

<!-- more -->

### 构建docker

在一个空目录下新建一个Dockfile，写入以下内容

```dockerfile
FROM node:latest
RUN npm install -g cnpm --registry=https://registry.npm.taobao.org
RUN cnpm install hexo-cli hexo-server -g
RUN hexo init blog && cd blog && cnpm install \
    && cnpm install hexo-renderer-scss --save \
    && cnpm install hexo-deployer-git --save
RUN git config --global user.email "yg_wen@126.com" \
    && git config --global user.name "wenyg"
CMD /bin/bash
WORKDIR /blog
EXPOSE 4000
```

构建docker

```
sudo docker build -t hexo .
```

### 博客启动停止

启动

```
sudo docker run -it --rm -p 80:4000 hexo hexo s
```

停止

```
sudo docker stop hexo 
```

