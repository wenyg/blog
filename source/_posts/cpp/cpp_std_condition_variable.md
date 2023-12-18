---
title: "C++: std::condition_variable"
date: 2023-02-19 20:14:20
tags: [C++]
categories: "C++11/14/17"
---

不要无条件的等待。否则可能会错过唤醒，或者唤醒了发现无事可做。

condition_variable.wait() 有两个重载函数

- `void wait (unique_lock& lck)`。 无条件的等待
- `void wait (unique_lock& lck, Predicate pred)`。 有条件的等待. 大致实现如下
    ```C++
    template<typename _Predicate>
    void wait(unique_lock<mutex>& __lock, _Predicate __p)
    {
        while (!__p())
            wait(__lock);
    }
    ```

<!-- more -->

下面来看个简单的例子

```C++
#include <condition_variable>
#include <iostream>
#include <thread>

std::mutex mutex_;
std::condition_variable condVar; 

bool dataReady{false};

void waitingForWork(){
    std::cout << "Waiting " << std::endl;
    std::unique_lock<std::mutex> lck(mutex_);
    condVar.wait(lck, []{ return dataReady; });   // (4)
    std::cout << "Running " << std::endl;
}

void setDataReady(){
    {
        std::lock_guard<std::mutex> lck(mutex_);
        dataReady = true;
    }
    std::cout << "Data prepared" << std::endl;
    condVar.notify_one();                        // (3)
}

int main(){
    
  std::cout << std::endl;

  std::thread t1(waitingForWork);               // (1)
  std::thread t2(setDataReady);                 // (2)

  t1.join();
  t2.join();
  
  std::cout << std::endl;
  
}
```

为什么一个如此简单的程序会看起来都会这么麻烦呢。如果不使用 `dataReady` 会怎样呢？

先看看正常情况下 上面 （4）语句

```C++
condVar.wait(lck, []{ return dataReady; });
```

如果 `[]{ return dataReady; }` 为真， 那么程序继续运行。
如果 `[]{ return dataReady; }` 为假， condVar 会释放锁，然后阻塞自己，等待其他线程的 notify 信号。

如果接下来，condVar收到了其他线程的 notify 信号被唤醒。（也有可能被虚假唤醒）线程会被唤醒，并获取锁，并检查 `[]{ return dataReady; }` 的结果。跟之前一样，根据结果来决定接下来的行为。 

回到最开始的问题，如果不使用 `dataReady` 会怎样的呢， 即无条件的等待。

```C++
void waitingForWork(){
    std::cout << "Waiting " << std::endl;
    std::unique_lock<std::mutex> lck(mutex_);
    condVar.wait(lck);                       // (1)
    std::cout << "Running " << std::endl;
}

void setDataReady(){
    std::cout << "Data prepared" << std::endl;
    condVar.notify_one();  
}
```

可能会发生如下现象。

1. waitingForWork 在收到信号之前，setDataReady 线程中已经发出了 notify 信号。那么 waitingForWork 会永远出于阻塞状态，看起来像死锁一样。


用不加锁的变量控制也一样

```C++
std::atomic<bool> dataReady{false};

void waitingForWork(){
    std::cout << "Waiting " << std::endl;
    std::unique_lock<std::mutex> lck(mutex_);
    condVar.wait(lck, []{ return dataReady.load(); });   // (1)
    std::cout << "Running " << std::endl;
}

void setDataReady(){
    dataReady = true;
    std::cout << "Data prepared" << std::endl;
    condVar.notify_one();
}
```

如果执行到 `condVar.wait(lck, []{ return dataReady.load(); });` 的时候。 信号的通知的发生在执行 `[]{ return dataReady.load()` 和 获取到锁之间。 那么可以想象的到。即执行线程顺序如下

- setDataReady 线程 `dataReady = true;`
- waitingForWork 线程 `[]{ return dataReady.load(); }`
- setDataReady 线程 `condVar.notify_one();`
- waitingForWork `condVar.wait(lck,`

很明显，信号通知也会被错过，程序会永远阻塞。原因在于 dataReady 的修改并没有正确的同步到，如果dataReady 在加锁的情况下修改，就不会发生这种现象。


### 其他

#### unique_lock/lock_guard

lock_guard 是一个 scope 锁。创建时获取锁，离开作用域是自动解锁。由于只有在析构的时候才会解锁，如果这个定义域比较大的话，那么锁的粒度就比较大，可能会影响程序效率。所以尽可能的是定义域小。

unique_lock 与lock_guard一样，但它额外提供了一个 unlock() 来主动解锁。

#### notify_one/notify_all

notify_one 只唤醒等待队列中的第一个线程。其余线程只能等待下次 notify_xxx

notify_all 所有线程都会被唤醒。所有线程争用锁，并执行接下里的任务，然后释放锁。


## 参考链接

https://www.modernescpp.com/index.php/c-core-guidelines-be-aware-of-the-traps-of-condition-variables


