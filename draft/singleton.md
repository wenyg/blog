---
title: "C++ 单例"
date: 2024-01-31 10:27:28
tags: [C++]
categories: "C++11/14/17"
---



```cpp
// Singleton.hpp
template <typename T>
class Singleton {
 public:
  inline static T& get() {
    static T instance;
    return instance;
  }

 private:
    Singleton() = default;
    ~Singleton() = default;
    Singleton(const Singleton&)= delete;
    Singleton& operator=(const Singleton&)= delete;
};
```

1. get 函数内部定义了一个 T 的 Static 示例，C++ 保证，会在第一次调用该对象的时候完成 instance 的构造，在 main 返回的时候析构 instance
2. 删除了 copy 构造函数，赋值函数，确保它只能有一个实例。

使用方法

```cpp
class Config : public Singleton<Config>{
 public:
  void foo(){};
}

void business(){
    Config::get()->foo();
}

```