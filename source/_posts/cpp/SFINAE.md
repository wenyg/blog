---
title: "SFINAE应用场景: 检测成员"
date: 2023-06-18 19:08:42
tags: [C++]
categories: "C++11/14/17"
---

在C++编程中，Substitution Failure Is Not An Error（SFINAE）是一种强大的技术，允许我们在编译时根据类型特征选择不同的实现。这个特性在许多现代C++库和框架中被广泛使用，其中之一是在处理不同结构的通用接口时。

让我们看一个简单而实用的例子，通过检查类型是否具有特定成员来优雅地处理不同结构的通用接口。在这个例子中，我们将使用SFINAE来检查类型是否包含名为 'header' 的成员，并相应地执行不同的处理。

<!-- more -->
```cpp
#include <iostream>
#include <type_traits>

// 首先，让我们定义一个模板结构 HasHeader，该结构通过SFINAE技术检查是否存在 'header' 成员。
template <typename T, typename = void>
struct HasHeader : std::false_type {};

template <typename T>
struct HasHeader<T, std::void_t<decltype(std::declval<T>().header)>> : std::true_type {};

// 接下来，我们定义一个使用SFINAE的函数模板 process_header，该模板在类型具有 'header' 成员时执行特定处理。
template <typename T>
std::enable_if_t<HasHeader<T>::value> process_header(const T &data) {
    std::cout << "处理 header: " << data.header << std::endl;
}

template <typename T>
std::enable_if_t<!HasHeader<T>::value> process_header(const T &data) {
    std::cout << "没有要处理的 header。" << std::endl;
}


// 最后，我们定义两个示例类，一个具有 'header' 成员，另一个没有。
struct ExampleWithHeader {
    int header = 42;
};

struct ExampleWithoutHeader {};

// 在 main 函数中，我们使用 process_header 函数处理这两个示例类的实例。
int main() {
    ExampleWithHeader obj1;
    ExampleWithoutHeader obj2;

    process_header(obj1);  // 输出: 处理 header: 42
    process_header(obj2);  // 输出: 没有要处理的 header。

    return 0;
}
```

在实际项目中，这种技术可以用于实现泛型算法、库组件和其他需要在编译时进行类型分派的场景

## C++ Template 小课堂

`decltype`、`std::declval`、`std::enable_if_t` 简要解释：

1. decltype:
   - 作用： `decltype` 用于获取表达式的类型，而不执行该表达式。
   - 用法： `decltype(expr)` 返回表达式 `expr` 的类型。通常在模板编程中用于推导类型。
2. std::declval:
   - 作用： `std::declval` 用于生成对于任何类型 `T` 的右值引用（rvalue reference）。通常与 `decltype` 一起使用，以在不创建对象的情况下获取类型信息。
   - 用法： `std::declval<T>()` 返回类型 `T` 的右值引用。
3. std::enable_if_t:
   - 作用： `std::enable_if_t` 用于在编译时根据条件启用或禁用模板特化。
   - 用法： `std::enable_if_t<Condition, Type>` 如果 `Condition` 为真，则定义 `Type`；否则，不定义。
