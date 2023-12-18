---
title: ubuntu 更新为清华源
date: 2022-12-23 17:12:32
tags: [proxy]
categories: 工具
---

将 ubuntu 默认源换为 [清华源](https://mirror.tuna.tsinghua.edu.cn/help/ubuntu/)

```shell
sed -i 's/http:\/\/\(archive\|security\).ubuntu.com\/ubuntu\//http:\/\/mirrors.tuna.tsinghua.edu.cn\/ubuntu\//g' /etc/apt/sources.list
```