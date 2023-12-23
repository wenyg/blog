---
title: docker常见操作
tags: [docker]
categories: 工具
date: 2019-07-25 23:33:55
---

1. 列出已有镜像

   ```bash
   docker image ls
   ```

2. 列出镜像实际占用空间

   ```bash
   docker system df
   ```

3. 删除“旧”镜像

   ```bash
   docker image prune
   ```

   <!-- more -->

4. 删除本地镜像

   ```bash
   docker image rm [镜像ID]
   ```

5. 挂载当前目录到镜像

   ```bash
   docker run -v "$(pwd)"/:/workspace/ ubuntu:16.04
   ```

   挂载主目录下的文件到镜像

   ```bash
   docker run -v $HOME/.ssh:/root/.ssh ubuntu:16.04
   ```

6. 挂载单个文件到镜像

   ```bash
   docker run --mount \
   type=bind,source="$(pwd)"/sources.list,target=/etc/apt/sources.list \
   ubuntu
   ```

7. 显示正在运行的容器

   ``` bash
    docker container ls
   ```

   列出所有容器

   ```bash
   docker container ls -a
   ```

   删除所有停止的容器

   ```bash
   docker container prune
   ```

8. 进入容器

   ```bash
   docker run -ti --entrypoint=/bin/bash node
   docker run -ti node /bin/bash
   ```

   进入已在运行的容器

   ```bash
   docker exec -it [镜像ID] /bin/bash
   ```

9. 镜像导入导出

   ```bash
   docker save myimage:tag > myimage.tar
   docker load < myimage.tar
   ```

10. 把容器端口4000映射到主机80

   ```bash
   docker run -p 80:4000 nginx
   ```
