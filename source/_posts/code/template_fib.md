---
title: "模板元编程，斐波那契数列"
date: 2024-02-28 10:27:28
tags: [C++]
categories: ["C++11/14/17", "废话少说,放码过来"]
---

定义一个模板结构体，模板参数是个常量，结构体有个成员 v,用于存储斐波那契数。

```cpp
template<int N>
struct Fib {
    static constexpr int v = Fib<N-1>::v + Fib<N-2>::v;
};
```
> 注意, constexpr 用于声明一个常量表达式，明确告知编译器，该表达式可以在编译时期计算出结果。

然后针对 Fib<1> 和 Fib<2> 进行模板特化

```cpp
template <>
struct Fib<1>{
    static constexpr int v = 1;
};

template <>
struct Fib<2>{
    static constexpr int v = 1;
};
```

然后 `Fib<N>::v` 就是编译期确定的斐波那契数。

下面是完整的例子

```cpp

#include <iostream>

template<int N>
struct Fib {
    static const int v = Fib<N-1>::v + Fib<N-2>::v;
};

template <>
struct Fib<1>{
    static const int v = 1;
};

template <>
struct Fib<2>{
    static const int v = 1;
};

template <int Start, int End>
void print(){
    if constexpr (End >= Start){
        std::cout << Fib<Start>::v << std::endl;
        print<Start + 1,End>();
    }
}

int main(int argc, char **argv){
    print<1,10>();
    return 0;
}
```