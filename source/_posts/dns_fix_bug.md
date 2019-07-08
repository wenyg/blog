---
title: 一次DNS服务器BUG调试
date: 2018-03-27 20:34:30
tags: [DNS, BUG, 调试]
categories: BUG调试
---
## 背景
公司做了一个DNS服务器，测试没问题了，架设到网关上使用，出现了电脑能解析域名，手机不能解析的情况问题。
## 问题解决过程
有时候找到问题在哪比解决问题本身更难。同一个路由器的下的电脑能访问，手机不能访问。先在网关上进行抓包，分析手机发送的DNS请求和电脑发送的DNS请求有什么不同，无果，手机和电脑发送的DNS请求并没有什么不同，服务器端返回的响应也一样。找了一下午也没有找到。有时候找bug就像写作一样，当写不出东西的时候不如出去走走，弄不好灵感就来了。第二天偶然发现手机上并不是所有的域名都不能解析，有个别的域名还是能访问的，又进行了一些域名进行尝试，总结出一个规律：知名的网站大多数不能访问比如百度、腾讯、网易等等，而一些不知名的小网站能够访问。尝试尝试自己注册的域名，果然能访问。有突破口就好办了，然后开始分析公共DNS服务器返回的大网站和小网站的DNS报文有什么不同。

<!-- more -->

用dig查询baidu域名的IP（手机不能访问）

	;; QUESTION SECTION:
	;www.baidu.com.                 IN      A
	
	;; ANSWER SECTION:
	www.baidu.com.          358     IN      CNAME   www.a.shifen.com.
	www.a.shifen.com.       58      IN      A       115.239.211.112
	www.a.shifen.com.       58      IN      A       115.239.210.27

个人小网站域名winn.cc

	;; QUESTION SECTION:
	;www.winn.cc.              IN      A
	
	;; ANSWER SECTION:
	www.winn.cc.       58      IN      A       202.196.35.225

其他的一些域名和上面的类似，带CNAME记录的全部不能访问，看到这一点，问题已经找到在哪了，之前BOSS为了减少流量，把CNAME记录给删除了，只返回给IP。
比如百度的域名 我们返回的响应是这样的：

	;; QUESTION SECTION:
	;www.baidu.com.                 IN      A
	
	;; ANSWER SECTION:
	www.a.shifen.com.       58      IN      A       115.239.211.112
	www.a.shifen.com.       58      IN      A       115.239.210.27

这样的响应理解起来是这样子的，有人（客户端）来找看门大爷（DNS服务器）问老王（域名）家住哪，老王有个外号（CNAME）叫胖子，但是来人并不知道老王的外号。

	客户：大爷，老王家在哪啊
	看门大爷：胖子家在第一栋楼502号
	客户：？？？？？（一脸懵逼）

正常的流程应该是这样的

	客户：大爷，老王家在哪啊
	看门大爷：老王，你说那个胖子啊，胖子家在第一栋楼502号
	客户：哦，那谢谢您嘞。（去找老王）

问题就在上层DNS服务器返回了多条记录，这几条记录可能是相关联的，我们删掉了其中的一条记录，使这些记录关联不到一起。手机系统看来是服务器答非所问不能解析。至于电脑为什么能解析，可能Windows系统和unix的处理流程方法不一样吧。

### 解决方法

1. 在返回记录里添加CANME记录
2. 在返回记录里不添加CNAME记录，但把CNAME换成QNAME

原始响应

	;; QUESTION SECTION:
	;www.baidu.com.                 IN      A
	
	;; ANSWER SECTION:
	www.baidu.com.          358     IN      CNAME   www.a.shifen.com.
	www.a.shifen.com.       58      IN      A       115.239.211.112
	www.a.shifen.com.       58      IN      A       115.239.210.27

修改后的响应

	;; QUESTION SECTION:
	;www.baidu.com.               IN      A
	
	;; ANSWER SECTION:
	;www.baidu.com.       58      IN      A       115.239.211.112
	;www.baidu.com.       58      IN      A       115.239.210.27