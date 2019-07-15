---
title: tar打包
tags: [tar, 打包]
categories: 工具
date: 2019-07-15 19:28:33
---

tcpdump是Linux下的抓包工具，通过tcpdump可以帮助我们分析网络，排除故障，安全测试等。了解tcpdump是一个系统管理员，网络工程师必不可少的专业技能。

tar 打包常用命令, 经常用还是一直忘

> tips:  tar命令要再记不住就要找工作了
>
>   记不住  -j bz2， -j 打包的是bz2格式
>
>   找工作 -z gz， -z 打包的是gz格式 

### 打包

```
tar -cvf ***.tar data
tar -czvf ***.tar.gz data
tar -cjvf ***.tar.bz2 data
```

### 解压

```
tar -xvf ***.tar
tar -xzvf ***.tar.gz
tar -xjvf ***.tar.bz2
```

### 查看包内内容

```
tar -tvf ***.tar
tar -tzvf ***.tar.gz
tar -tjvf ***.tar.bz2
```