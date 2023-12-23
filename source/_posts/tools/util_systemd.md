---
title: systemctl 服务编写
tags: [systemctl]
categories: 工具
date: 2019-07-12 15:50:22
---

## Linux 服务

启动Linux服务，一般有两种方法, 一种是`service`, 一种是`systemctl`

```
service nginx start
systemctl start nginx
```

`service`是比较老的系统的管理方式， `systemctl`是比较新的管理方式，一些老的系统不支持`systemctl`, 但新的系统`systemctl`会兼容`service` 

`service start`其实执行的是`/etc/init.d/`下面的shell脚本，脚本中定义了start，stop等操作。这些脚本需要我们自己编写。

`systemctl`是比较新的系统里的服务管理方式，`systemctl`脚本都放在`/etc/systemd/system/`(Ubuntu)或者`/usr/lib/systemd/system`(Centos)下。如果在该目录下找不到相应的脚本，它会去`/etc/init.d`目录下找`service`的启动脚本。

<!-- more -->

## systemd init系统

大部分Linux发行版，如Rhel，CentOS，Fedora，Ubuntu，Debian和Archlinux，都采用systemd作为其初始系统。实际上，Systemd不仅仅是一个init系统，这也是为什么有些人强烈反对其设计的原因之一，这违背了公认的unix座右铭：“做一件事，做得好”。systemd使用自己的.service文件, 其他init系统使用简单的shell脚本来管理服务，不过慢慢的就会被systemctl取代，这里主要介绍systemcl的一些操作以及systemd服务脚本编写。

### 基本命令

1. 启动与停止

   ```
   systemctl stop nginx
   systemctl start nginx
   ```

2. 查看服务状态

   ```
   systemctl status nginx
   ```

3. 设置服务开机启动

   ```
   systemctl enable nginx
   ```

4. 查看服务log

   ```
   journalctl -u foo-daemon
   ```

   

### 自定义服务

新建一个systemd service file `/etc/systemd/system/demo.service`

```
sudo touch /etc/systemd/system/demo.service
sudo chmod 664 /etc/systemd/system/demo.service
```

写入以下内容， `/usr/sbin/demo` 可以是自己随便写一个小程序

```
[Unit]
Description=A Systemd Service Demo

[Service]
ExecStart=/usr/sbin/demo

[Install]
WantedBy=multi-user.target
```

加载脚本

```
sudo systemctl daemon-reload
```

现在 就创建了一个linux服务，我们就可以用systemctl操作我们服务了

```
sudo systemctl start demo
sudo systemctl stop demo
sudo systemctl restart demo
systemctl status demo
```

更多有关systemctl介绍 请查看[systemd](https://www.freedesktop.org/software/systemd/man/systemd.exec.html)

