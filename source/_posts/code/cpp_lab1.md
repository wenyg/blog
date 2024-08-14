---
title: C++小实验，两个线程交替执行
date: 2023-09-04 11:06:48
tags: [C++]
categories: ["C++11/14/17", "废话少说,放码过来"]
---

cpp小实验，两个线程，一个线程负责将变量减一，另一个线程负责打印线程。

```cpp
#include <thread>
#include <condition_variable>
#include <mutex>
#include <iostream>

int global_value = 10;
bool ready_to_reduce{false};
std::mutex mtx;
std::condition_variable cv_reduce;
std::condition_variable cv_print;

void producer() {
    while(true) {
        std::unique_lock<std::mutex> lock(mtx);
        cv_reduce.wait(lock,[](){
            return ready_to_reduce;
        });
        global_value--;
        ready_to_reduce = !ready_to_reduce;
        cv_print.notify_one();
        if (global_value == 0) {
            break;
        }
    }
}

void consumer() {
    while(true) {
        std::unique_lock<std::mutex> lock(mtx);
        cv_print.wait(lock,[] () {
            return !ready_to_reduce;
        });
        std::cout << global_value << std::endl;
        if (global_value == 0) {
            break;
        }
        ready_to_reduce = true;
        cv_reduce.notify_one();
    }
}

int main() {
    auto t1 = std::thread(producer);
    auto t2 = std::thread(consumer);
    t1.join();
    t2.join();
    return 0;
}
```