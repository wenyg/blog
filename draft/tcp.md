---
title: 右值引用，移动语义
date: 2024-03-30 17:04:40
tags: [C++]
categories: "C++11/14/17"
---

右值通常指的是那些临时对象或者表达式的值，它们没有持久的身份，可以被移动或者传递给函数

```cpp
// 临时变量
std::string getName() {
    return "John";
}
std::string&& name = getName();

// 字面量
int&& num = 10; // 10 是一个右值

// 表达式结果
int x = 5, y = 10;
int&& sum = x + y; // x + y 的结果是一个右值
```