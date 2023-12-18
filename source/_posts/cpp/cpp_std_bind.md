---
title: "C++: std::bind"
date: 2023-02-17 20:14:20
tags: [C++]
categories: "C++11/14/17"
---

在C++11中，引入了一个新的库 functional ，其中包括了许多有用的函数对象和函数适配器。其中之一是 std::bind。

std::bind 它可以绑定一个函数或成员函数的参数，并返回一个可调用对象。这意味着可以将参数延迟到稍后再使用。

### 基本用法

下面是一个简单的例子，展示了如何使用 std::bind 实现参数绑定：

<!-- more -->

```cpp
#include <iostream>
#include <functional>

void sum(int a, int b)
{
    std::cout << "sum: " << a + b << std::endl;
}

int main()
{
    auto add_five = std::bind(sum, std::placeholders::_1, 5); // 绑定第二个参数为5
    add_five(10); // 输出：sum: 15
    return 0;
}
```

在这个例子中，我们创建了一个名叫 add_five 的可调用对象，它实际上是 sum 函数的参数绑定版本。我们使用 std::bind 将第一个参数绑定为 _1(占位符)，第二个参数绑定为 5，以此类推。最终，我们可以调用 add_five 并将一个整型值作为第一个参数传入，生成最终结果。


### 可绑定对象

除了普通函数外，std::bind 还可以接收能够被调用的任何对象，例如函数对象和成员函数。

```cpp
#include <iostream>
#include <functional>

class A
{
public:
    void print(int n, char c)
    {
        std::cout << "print called: " << n << ", " << c << std::endl;
    }
};

int main()
{
    auto a = A();
    auto func = std::bind(&A::print, &a, 10, std::placeholders::_1); // 绑定第二个参数为1
    func('A'); // 输出：print called: 10, A
    return 0;
}
```

在这个例子中，我们创建了一个名为 a 的 A 类实例，并将其地址传递给 std::bind。我们还绑定了 print 成员函数的第一个参数为 10，第二个参数使用 _1 占位符。最后我们可以调用 func 函数，并为其传递一个 char 类型的参数，生成最终结果。

### 组合函数

还可以使用 std::bind 来组合多个函数。

```cpp
#include <iostream>
#include <functional>

int sum(int a, int b)
{
    return a + b;
}

int mul(int a, int b)
{
    return a * b;
}

int main()
{
    auto func = std::bind(sum, std::bind(mul, std::placeholders::_1, 5), 10);
    std::cout << "Result: " << func(2) << std::endl; // 输出：30
    return 0;
}

```

在这个例子中，我们首先将第一个参数与 5 相乘，然后将结果与 10 相加。我们使用 std::bind 将 mul 函数的第二个参数绑定为 5。最终，我们调用 func(2) 并得到 30 作为输出。

### 使用 std::placeholders 占位符

当使用 std::bind 时，需要使用 _1, _2, _3, ... _N 等占位符来表示绑定的函数的参数。

```cpp
auto add_five = std::bind(sum, std::placeholders::_1, 5);
```

在这个例子中，_1 表示将要绑定的函数的第一个参数。

另外，如果想对多个参数进行绑定，则需要使用不同的占位符：

在这个例子中，_1 表示原函数的第一个参数，_2 表示原函数的第二个参数。


