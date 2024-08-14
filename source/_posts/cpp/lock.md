---
title: "C++中的锁"
date: 2024-02-19 20:14:20
tags: [C++]
categories: "C++11/14/17"
---

C++中，锁是用来管理并发访问共享资源的工具，下面是与锁相关的一些概念。

## std::mutex

互斥锁，最基本的锁类型之一，提供了最基本的锁操作，`lock()`/`unlock()`/`try_lock()`;

## std::shared_mutex

共享锁，或者叫读写锁， C++17中引入的。允许多个线程同时读取共享锁。

## std::lock_guard, std::unique_lock, std::shared_lock

对 mutex 进行了一层封装，更为抽象的封装，RAII风格，为 mutex 的管理类。

- std::lock_guard 在构造函数时候加锁，在析构的时候释放锁。  
- std::unique_lock 支持手动释放锁，加锁。
- std::shared_lock 与 std::shared_mutex 配合实现共享锁

## std::atomic_flag

原子布尔类型，可用于实现自旋锁。提供有 `test_and_set()`/`clear()` 方法

## std::condition_varable

条件变量不是锁，而是与锁结合使用来实现复杂的线程同步机制。它允许一个线程在条件变量上等待，被唤醒之后先判断表达式的值，如果为真再尝试获取锁。

