---
title: "C++: std::decay_t"
date: 2023-05-29 20:14:20
tags: [C++]
categories: "C++11/14/17"
---

`std::decay_t`是一个类型转换工具，它接受一个类型，并将其转换为对应的"衰减类型"。所谓"衰减类型"指的是将某个类型以如下方式处理得到的类型：

- 对于数组或函数类型，将其转换为指针类型。
- 对于const/volatile限定符和引用类型，去除这些修饰符，得到被修饰类型本身。
- 对于非上述类型，保持其原样。

以下是一个使用`std::decay_t`的例子：

```c++
#include <type_traits>

int main() {
    int arr[3] = {1, 2, 3};
    using type1 = std::decay_t<decltype(arr)>; // type1会被推导为int*
    
    const volatile double& ref = 42.0;
    using type2 = std::decay_t<decltype(ref)>; // type2会被推导为double
    
    struct S {};
    using type3 = std::decay_t<S>; // type3会被推导为S
}
```