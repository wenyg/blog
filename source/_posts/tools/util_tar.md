---
title: tar打包
tags: [tar]
categories: 开发者手册
date: 2019-07-15 19:28:33
---

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

<!-- more -->

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