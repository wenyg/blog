---
title: "C++: std::function"
date: 2023-02-16 17:58:11
tags: [C++]
categories: "C++11/14/17"
---

[std::function](https://en.cppreference.com/w/cpp/utility/functional/function) 是一个函数包装器，它可以包装任何可调用函数实体。

- 函数
- 函数指针
- 成员函数
- 静态函数
- lambda 表达式
- 函数对象

<!-- more -->

### 函数对象赋值方法

```C++
#include <functional>
#include <iostream>
#include <type_traits>

int func(int a){
  return a;
}

class FuncClass{
  public:
    int operator()(int a){
      return a;
    }
    int member_func(int a){
      return a;
    }
    static int static_memory_func(int a){
      return a;
    }
};


int main(){
  std::function<int(int)> f;
  if (!f){ // 函数对象重载了 bool 运算符
    std::cout << "函数对象还没赋值" << std::endl;
  }

  // 函数
  f = func;
  std::cout << f(10) << std::endl;

  // 函数指针
  int (*func_ptr)(int) = func;
  f = func_ptr;
  std::cout << f(11) << std::endl;

  // 可调用对象
  FuncClass func_class_obj;
  f = func_class_obj;
  std::cout << f(12) << std::endl;

  // 类静态成员函数
  f = FuncClass::static_memory_func;
  std::cout << f(13) << std::endl;

  // 成员函数
  f = std::bind(&FuncClass::member_func, &func_class_obj, std::placeholders::_1);
  std::cout << f(14) << std::endl;
  
  // lamda
  f = [](int a){
    return a;
  };
  std::cout << f(15) << std::endl;

  // reset
  f = nullptr;
  std::cout << "无效函数对象，会抛异常" << std::endl;
  std::cout << f(16) << std::endl;
 
  return 0;
}
```

输出如下

```
函数对象还没赋值
10
11
12
13
14
15
无效函数对象，会抛异常
terminate called after throwing an instance of 'std::bad_function_call'
  what():  bad_function_call
```