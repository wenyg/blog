---
title: "C++: 进程间同步之共享内存"
date: 2023-03-21 20:14:20
tags: [C++]
categories: "废话少说,放码过来"
---

为了实现多进程间的数据同步，我们可以使用进程间通信（IPC）机制。下面是一个使用共享内存实现多进程间数据同步的示例代码：

<!-- more -->

```C++
#include <iostream>
#include <cstdlib>
#include <cstring>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <fcntl.h>

using namespace std;

// 共享内存的结构体
struct SharedMemory {
    int request_count;  // 请求数量
};

int main() {
    const char* kSharedMemoryName = "/my_shared_memory";  // 共享内存名称
    const int kSharedMemorySize = sizeof(SharedMemory);  // 共享内存大小

    // 创建或打开共享内存
    int shm_fd = shm_open(kSharedMemoryName, O_CREAT | O_RDWR, 0666);
    if (shm_fd == -1) {
        perror("shm_open");
        exit(1);
    }

    // 调整共享内存大小
    if (ftruncate(shm_fd, kSharedMemorySize) == -1) {
        perror("ftruncate");
        exit(1);
    }

    // 映射共享内存到当前进程的地址空间
    void* shared_memory = mmap(NULL, kSharedMemorySize, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, 0);
    if (shared_memory == MAP_FAILED) {
        perror("mmap");
        exit(1);
    }

    // 关闭文件描述符，不再需要
    close(shm_fd);

    // 初始化共享内存的内容
    SharedMemory* p_shared_memory = reinterpret_cast<SharedMemory*>(shared_memory);
    p_shared_memory->request_count = 0;

    // 模拟多进程并发请求的情况
    const int kNumProcesses = 4;
    for (int i = 0; i < kNumProcesses; i++) {
        pid_t pid = fork();
        if (pid == -1) {
            perror("fork");
            exit(1);
        } else if (pid == 0) {
            // 子进程逻辑
            for (int j = 0; j < 10000; j++) {
                // 模拟一次请求
                p_shared_memory->request_count++;
            }
            exit(0);
        }
    }

    // 父进程等待所有子进程结束
    for (int i = 0; i < kNumProcesses; i++) {
        wait(NULL);
    }

    // 输出最终请求数量
    cout << "Total request count: " << p_shared_memory->request_count << endl;

    // 解除共享内存映射
    if (munmap(shared_memory, kSharedMemorySize) == -1) {
        perror("munmap");
        exit(1);
    }

    // 删除共享内存
    if (shm_unlink(kSharedMemoryName) == -1) {
        perror("shm_unlink");
        exit(1);
    }

    return 0;
}
```

在这个示例代码中，我们使用了 shm_open、ftruncate、mmap、munmap 和 shm_unlink 函数来操作共享内存。其中，shm_open 函数用于创建或打开共享内存，ftruncate 函数用于调整共享内存的大小，mmap 函数用于映射共享内存到当前进程的地址空间，munmap 函数用于解除共享内存映射，shm_unlink 函数用于删除共享内存。

在初始化共享内存的内容后，我们创建了多个子进程，并在每个子进程中模拟了一定数量的请求，这些请求会增加共享内存中的请求数量。最后，父进程等待所有子进程结束后，输出最终的请求数量，并删除共享内存。

需要注意的是，使用共享内存进行进程间通信需要确保不同进程对共享内存中的数据进行访问时不会产生竞态条件。在本示例代码中，我们使用了共享内存的结构体成员来保存请求数量，这样可以避免多个进程同时修改同一个变量的问题。同时，由于共享内存是一块共享的内存区域，因此不同进程可以通过相同的指针来访问共享内存中的数据。

需要注意的是，共享内存虽然是一种高效的进程间通信方式，但是由于多个进程共享同一块内存，因此容易产生数据一致性问题，需要采取相应的同步措施来避免这些问题的出现。在本示例代码中，我们没有使用任何同步措施，因为对于只有一个变量的情况下，并发修改不会导致数据不一致的问题。但是，在实际情况下，如果需要对多个变量进行并发修改，就需要使用锁或者其他同步机制来保证数据的一致性。