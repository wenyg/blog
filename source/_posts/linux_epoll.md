---
title: "epoll"
date: 2023-03-28 19:41:29
tags: [C++]
categories: "理解计算机"
---


epoll_create 创建一个 epoll 对象，同时内核中会创建一个 eventpoll 对象，并把其关联到当前进程已打开文件列表中。

eventpoll 对象如下

- wait_queue_head_t wq: epollwait 使用的等待队列
- struct list_head rdllist: 就绪描述符队列
- struct rb_root rbr: 红黑树 