---
title: "程序员的自我修养: 延迟绑定"
date: 2023-03-01 19:51:12
tags: [链接]
categories: 程序员的自我修养
---

调动动态库中的函数时候，涉及到地址重定位，函数地址在链接的时候才能确定下来。链接器会额外生成两张表，一个 **PLT(Procedure Link Table) 程序链接表**，一个是 **GOT(Global Offset Table) 全局偏移表**，两张表都在数据段中。

- 全局偏移表，用来存放 "外部的函数地址"。
- 程序链接表，用来存放 "获取外部函数地址的代码"。

<!-- more -->

比如简单的函数调用

```C++
printf("Hello world\n");
```

实际上会先调用 plt 表

```
call printf@plt
```

printf@plt 的调用如下

```
jmp *printf@got
```

printf@got 的地址就是真正的 printf 地址。

### 延迟绑定

要使得所有的函数能正常调用， GOT 表中就要填入正确的函数地址。如果一开始就对所有函数就进行重定位显然效率上会有问题。所以 linux 引入延迟绑定机制，即只有在首次调用函数的时候才进行重定位

假设 GOT[4]是 用来存放 printf 的函数的地址. 延迟绑定中 printf@plt 执行过程大致如下。

```
jmp *GOT[4]
push $0x1
jump PLT[0] 
```
*GOT[4] 初始值是其PLT指定的第二条指令地址（push $0x1），即又跳了回来。
PLT[0] 是一个特殊条目，它跳到动态链接器中，解析函数地址，并且重写 GOT 表，然后再调用函数。

显然经过这次步骤之后，GOT[4] 已经写入了 printf 的地址，下次调用 printf@plt 的时候会直接跳转到 printf。




