---
title: ubuntu下构建deb包
date: 2019-07-23 20:17:33
categories: 开发者手册
---

本文讲解如何构建一个deb包

### dpgk

首先介绍下dpkg，dpkg是debian系统下软件包管理工具，用dpkg可以很方便的安装管理我们的deb包，为什么呢，因为deb包都是用dpkg构建的。类似于rethat系列的软件用rpm一样，rethat用rpm管理软件，用rpmbuild构建软件。

<!-- more -->
### 如何用dpkg构建一个软件包呢

1. 模仿，找一个流行的deb包，拆开里面的内容，看看它们是怎么写的，模仿他们准没错。我们可以上 dpkg.org 去查找比较流行的程序。这里我以sshd服务举例

2. 解压sshd基本资源

   ```bash
   dpkg -x openssh-server_6.6p1-2ubuntu1_amd64.deb openssh
   ```

   现在解压的都是sshd自身的东西，比如可执行程序，man文档，启动脚本之类的

3. 解压 debian 包构建脚本

   ```bash
   dpkg -e openssh-server_6.6p1-2ubuntu1_amd64.deb openssh/DEBIAN
   ```

   这DEBIAN里面就是构建deb包所需要的脚本， 我们最需要关注的就是control，其他的可有可无

4. 以上内容就是构建sshd服务的所有内容了，重新打包下试试

   ```bash
   dpkg -b openssh openssh.deb
   ```

   以上就是构建包的整理流程，但是你要是构建软件，你可能还需要一些其他的知识，比如Linux service脚本编写， /etc/init.d/脚本编写等等。
