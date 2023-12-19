---
title: VSCode 容器中开发相关配置
date: 2023-8-22 13:43:57
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

<!-- more -->

## vscode 配置

vscode 需要安装 Dev Containers 插件， 然后在左侧边栏的远程资源管理器，选择开发容器就可以看到启动的容器

![Attach to Container](https://code.visualstudio.com/assets/docs/devcontainers/attach-container/containers-attach.png)
