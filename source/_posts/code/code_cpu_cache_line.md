---
title: CPU 缓存一致性
date: 2022-09-17 09:55:34
tags: [C++]
categories: 理解计算机 
---

有两个独立的线程，一个线程读写 var1, 一个线程读写 var2。这两个线程的读写会相互影响吗？

```C++
struct SharedData {
    char var1;
    // double magic;
    char var2;
};
```

下面我们来做个实验

## 实验 
```cpp
// test.cpp
#include <iostream>
#include <thread>


struct SharedData {
    char var1;
    // double magic;
    char var2;
};

SharedData data;

void Thread1() {
    for (int i = 0; i < 100000000; ++i) {
        data.var1++;
    }
}

void Thread2() {
    for (int i = 0; i < 100000000; ++i) {
        data.var2++;
    }
}

int main() {
    std::thread t1(Thread1);
    std::thread t2(Thread2);

    t1.join();
    t2.join();

    return 0;
}
```
### 实验一

将上面的代码保存为 `test.cpp`, 然后用 `g++ test.cpp -lpthread` 编译, 运行 10 次统计平均运行时间

```
$ for i in {1..10}; do (time ./a.out); done;
./a.out  1.93s user 0.01s system 191% cpu 1.015 total
./a.out  1.42s user 0.06s system 180% cpu 0.819 total
./a.out  0.85s user 0.16s system 142% cpu 0.706 total
./a.out  1.12s user 0.06s system 186% cpu 0.633 total
./a.out  1.56s user 0.00s system 182% cpu 0.861 total
./a.out  1.22s user 0.01s system 143% cpu 0.857 total
./a.out  1.67s user 0.02s system 185% cpu 0.911 total
./a.out  1.68s user 0.01s system 182% cpu 0.924 total
./a.out  1.63s user 0.02s system 175% cpu 0.941 total
./a.out  1.68s user 0.02s system 184% cpu 0.919 total
```

total 平均时间为 0.8366 秒

### 实验二

然后将 SharedData 里面的 `// double magic;` 注释打开

```cpp
struct SharedData {
    char var1;
    double magic;
    char var2;
};
```

重新编译运行

```
$ for i in {1..10}; do (time ./a.out); done;
./a.out  0.71s user 0.00s system 191% cpu 0.369 total
./a.out  0.67s user 0.01s system 175% cpu 0.390 total
./a.out  0.65s user 0.00s system 154% cpu 0.420 total
./a.out  0.68s user 0.00s system 175% cpu 0.389 total
./a.out  0.69s user 0.00s system 184% cpu 0.374 total
./a.out  0.70s user 0.00s system 183% cpu 0.381 total
./a.out  0.67s user 0.02s system 180% cpu 0.385 total
./a.out  0.65s user 0.04s system 161% cpu 0.425 total
./a.out  0.63s user 0.00s system 116% cpu 0.540 total
./a.out  0.70s user 0.00s system 182% cpu 0.386 total
```

total 平均时间为 0.4269 秒


### 结果

实验一耗时几乎是实验二的两倍，为什么？这里就涉及到 CPU 缓存行的概念

## 缓存行

缓存行是计算机体系结构中的基本缓存单元，通常是一组相邻的内存位置。当一个线程修改了共享的内存位置时，它会将整个缓存行加载到CPU缓存中。

在上述实验中, SharedData 结构中的两个 char 变量 var1 和 var2 可能处于相同的缓存行，因为它们是相邻的。当一个线程修改 var1 时，整个缓存行被加载到该线程的 CPU 缓存中。如果另一个线程正在修改var2，它会导致缓存行无效(缓存失效)，从而迫使其它的线程重主存重新加载最新的数据。

当`// double magic;` 被注释打开时，结构的大小变大，可能使 var1 和 var2 不再在同一个缓存行上。这样，两个线程可以独立地修改各自的变量，减少了缓存失效的可能性。


## 缓存一致性


CPU缓存一致性是指多个处理器或核心之间共享数据时，确保它们看到的数据是一致的。在多核处理器系统中，每个核心都有自己的缓存，当一个核心修改了共享数据时，其他核心可能仍然持有旧的缓存值。为了保证数据的一致性，需要采取一些机制来同步各个核心之间的缓存。


MESI协议是一种常见的缓存一致性协议，它定义了四种状态，分别是：

1. (M)Modified：缓存行被修改，并且是唯一的拥有者，与主内存不一致。如果其他缓存需要该数据，必须先写回主内存。 
2. (E)Exclusive：缓存行是唯一的拥有者，与主内存一致，且未被修改。其他缓存可以直接读取这个缓存行，而不需要从主内存读取。
3. (S)Shared：缓存行是共享的，与主内存一致，且未被修改。多个缓存可以同时拥有相同的缓存行。
4. (I)Invalid：缓存行无效，不能被使用。可能是因为其他缓存修改了这个行，导致当前缓存的数据不再有效。

状态的变化可以通过以下例子来说明：

假设有两个核心，A 和 B，它们共享某个数据的缓存行：

1. 初始状态：A 和 B 的缓存都标记为 Invalid(I)，因为还没有任何核心读取或修改这个数据。
2. 核心A读取数据：A 将缓存行标记为 Exclusive(E)，表示A是唯一的拥有者，并且数据与主内存一致。
3. 核心B读取数据：由于 A 是唯一的拥有者，B 可以直接从 A 的缓存行中读取数据，此时B  的缓存也标记为 Shared(S)。
4. 核心A修改数据：A 将缓存行标记为 Modified(M)，表示数据已被修改且A是唯一的拥有者。同时，A 会通知其他缓存失效，因为此时数据在 A 的缓存中已不一致。
5. 核心B尝试读取数据：由于 A 将数据标记为 Modified，B 的缓存行变为 Invalid(I)，B 需要从主内存重新读取最新的数据。