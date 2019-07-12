---
title: linux codedump设置
tags: [codedump]
categories: 工具
date: 2019-07-11 19:28:33
---

1. 打开core开关

   ```
   ulimit -c unlimited
   ```

2. 设置core文件生成位置格式

   ```
   echo "/corefile/core-%e-%p" > /proc/sys/kernel/core_pattern
   ```

3. 设置之后程序coredump的时候就会在`/corefile/`下生成 `code-程序名-进程ID`格式的codedump文件了 

   之后便可以用gdb来调试，前提是编译程序的时候加上了`-g`选项

   ```
   gdb ./a.out code-a.out-28281
   ```

   进入gdb之后输入bt 就能打印出crash时候的函数调用栈了

