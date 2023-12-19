
---
title: "strace：Linux 系统调用排查利器"
date: 2023-06-12 18:44:58
#tags: []
categories: 工具 
---

`strace` 是一个用于跟踪程序执行过程中系统调用的工具。它可以捕获程序与内核之间的交互，包括文件操作、进程控制、网络通信等，为开发者提供了深入了解程序行为的途径。通过 `strace`，你可以追踪到程序的每一步，查看系统调用的参数、返回值以及执行时间等关键信息。


在大多数 Linux 发行版中，`strace` 可以通过包管理工具进行安装。例如，在 Ubuntu 中，可以使用以下命令安装：

```bash
sudo apt-get install strace
```

## 用法

最基本的使用方式是在命令行中直接运行 strace 并指定待跟踪的命令。

```bash
strace ls
```

通过 `-o` 参数，你可以将 `strace` 的输出保存到文件中，以便后续分析。

```bash
strace -o output.txt ls
```


<!-- more -->


通过 `-v` 参数，你可以显示系统调用的详细信息，包括参数的值。

```bash
strace -v ls
```

使用 `-e trace` 参数，你可以指定要跟踪的系统调用类型。
   - **file：** 文件操作，包括`open`、`close`、`read`、`write`等。
   - **process：** 进程控制，包括`fork`、`execve`等。
   - **network：** 网络相关的系统调用，包括`socket`、`connect`、`recvfrom`等。
   - **signal：** 信号相关的系统调用，包括`kill`、`signal`等。
   - **ipc：** 进程间通信相关的系统调用，包括`pipe`、`msgsnd`、`msgrcv`等。
   - **desc：** 文件描述符相关的系统调用，包括`dup`、`fcntl`等。
   - **memory：** 内存管理相关的系统调用，包括`mmap`、`munmap`等。
   - **none：** 不跟踪任何系统调用。
   - **all：** 跟踪所有系统调用。
```bash
strace -e trace=file,process,desc ls
```


通过 `-t` 参数，你可以在每个输出行的前面显示时间信息。

```bash
strace -t ls
```

通过 `-r` 参数，你可以在每个输出行的前面显示相对时间。

```bash
strace -r ls
```

使用 `-f -p` 参数，你可以跟踪进程及其所有子进程的系统调用。

```bash
strace -f -p <PID>
```

通过 `-T` 参数，你可以在每个输出行的末尾显示系统调用的耗时。

```bash
strace -T ls
```