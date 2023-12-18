---
title: docker 使用国内镜像源
date: 2023-12-18 16:54:44
tags: [docker, proxy]
categories: 工具 
---

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