---
title: tcpdump抓包
tags: [tcpdump, 抓包]
categories: 开发者手册
date: 2017-07-08 19:28:33
---

tcpdump是Linux下的抓包工具，通过tcpdump可以帮助我们分析网络，排除故障，安全测试等。了解tcpdump是一个系统管理员，网络工程师必不可少的专业技能。

### 基础知识

基本命令解析

```bash
sudo tcpdump -i eth0 -nn -v port 80
```

**-i** : 选择要抓包的接口，通常是以太网卡或者无线适配器，但也可能是`vlan`或者更稀奇古怪的东西。

**-nn** : `-n`显示主机名，`-nn`显示主机名和端口。

**-v** : 显示详细信息，`-vv`显示更多。

**port 80** : 只抓80端口的数据包，当然通常是HTTP包。

<!-- more -->

#### 显示ASCII文本

添加`-A`到命令行将使输出包括ascii捕获中的字符串。这样可以轻松读取并使用`grep`其他命令解析输出。

```bash
 sudo tcpdump -A port 80
```



#### 抓某个协议的包

比如抓UDP协议的包(协议号17)

```bash
sudo tcpdump -i eth0 udp 
sudo tcpdump -i eth0 proto 17
```



#### 抓某个IP的包

使用`host`过滤器抓取某个IP的包，包括发往这个ip的包和这个ip发过来的包

```bash
sudo tcpdump -i eth0 host 10.10.1.1
```

或者使用 `src`, `dst` 抓取单向传输的包

```bash
sudo tcpdump -i eth0 dst 10.10.1.20
```



#### 把抓取的包写进文件

将抓的包写入文件之后可以用Wireshark或者其他分析工具进行分析

```bash
sudo tcpdump -i eth0 -s0 -w test.pcap
```