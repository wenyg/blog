---
title: "C++: 右值引用和移动构造"
date: 2023-03-09 20:14:20
tags: [C++]
categories: "C++11/14/17"
---

C++ 11 引入了移动语义和右值引用，使得代码的性能得到了大幅提升。其中，移动构造函数是一种特殊的构造函数，它可以接受一个右值引用参数，用来实现将一个对象的资源转移到另一个对象而不需要复制数据的操作。本文将详细介绍移动构造函数和右值引用。

<!-- more -->


### 右值引用

在 C++ 11 中，引入了新的类型：右值引用。右值是指一个临时对象，它只能存在于表达式的右边，并且其生命周期只能存在于这个表达式内部。右值引用则是指对右值进行引用的方式，其使用的语法是在类型名后面加上 &&，例如：

```c++
int&& a = 5;
```

在这个例子中，a 是一个右值引用，它引用了一个临时的 int 类型对象。由于这个对象是一个右值，所以它的生命周期只存在于这个语句中。右值引用的主要作用是实现移动语义。

### 移动构造函数

移动构造函数是一个特殊的构造函数，它接受一个右值引用参数，用来实现将一个对象的资源转移到另一个对象而不需要复制数据的操作。移动构造函数通常用于容器类、智能指针等需要管理资源的类中，以提高程序的性能。

移动构造函数的语法如下：

```C++
class MyClass {
public:
    MyClass(MyClass&& other) noexcept {
        // 资源转移代码
    }
};
```

在这个例子中，MyClass 的移动构造函数接受一个右值引用参数 other，用来接收另一个 MyClass 对象的资源。在移动构造函数中，可以将 other 对象的资源移动到当前对象中，而不需要进行深拷贝或浅拷贝。由于移动构造函数的特殊性质，其通常会使用 noexcept 关键字来标记其不会抛出异常，从而使得代码更加高效。

#### 使用移动构造函数

使用移动构造函数通常需要遵循一些规则：

- 对象必须是右值：只有右值可以通过移动构造函数来进行资源的转移。如果需要移动一个左值，可以使用 std::move 函数来将其转换为右值。
- 转移后原对象的状态是未定义的：移动构造函数会将原对象的资源转移到新对象中，原对象的状态是未定义的。因此，在使用移动构造函数后，原对象不能再被使用，否则可能会引发未定义行为。

下面是一个使用移动构造函数的例子：

```C++
class MyClass {
public:
    MyClass() : data_(new int[100]) {}
    MyClass(MyClass&& other) noexcept : data_(other.data_) {
        other.data_ = nullptr;
    }

private:
    int* data_;
};
```

```C++
MyClass func() {
    MyClass a;
    // ...
    return std::move(a);
}

int main() {
    MyClass b = func();
    return 0;
}
```

在这个例子中，func 函数返回一个 MyClass 对象，由于返回值是一个临时对象，因此可以通过移动构造函数来转移资源。在 main 函数中，通过使用 std::move 函数将返回值转换为右值，从而使得可以使用 MyClass 的移动构造函数来进行资源的转移。这样，就可以避免不必要的数据复制，从而提高程序的性能。

## 总结

移动构造函数可以用来实现将一个对象的资源转移到另一个对象而不需要复制数据的操作，从而提高程序的性能。使用移动构造函数需要遵循一些规则，例如对象必须是右值，转移后原对象的状态是未定义的等。通过掌握移动构造函数和右值引用，可以编写更加高效的 C++ 代码。


