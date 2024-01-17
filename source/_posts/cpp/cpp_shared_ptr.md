---
title: "你真的理解 shared_ptr 吗"
date: 2024-01-16 21:27:46
tags: [C++]
categories: "C++11/14/17"
---

C++ 的 `shared_ptr` 是什么呢？你真的理解吗？让我们试着回答以下问题。

1. 下面的几行代码是否正确，是否存在差异？
   ```cpp
   std::shared_ptr<int> p1;
   std::shared_ptr<int> p2(new int(0));
   std::shared_ptr<int> p3 = std::make_shared<int>(0);
   ```
2. `void func(Class *A);` 的参数可以是 `std::shared_ptr<A>` 吗？
3. `shared_ptr<T>` 是线程安全的吗？
4. 类成员函数如何返回指向自身的 `shared_ptr`？
5. 如何自定义 `shared_ptr` 的释放行为？

## 问题解答

### `shared_ptr<T>(new T)` 与 `make_shared<T>()`

在 C++ 中，`shared_ptr` 内部有一个指向动态分配对象的指针和一个指向控制块的指针。指向同一对象的共享指针共享这两个块。

```cpp
std::shared_ptr<int> p1;  // 空对象，数据指针指向空，分配控制块内存，并计数 0
std::shared_ptr<int> p2(new int(0)); // 数据指针指向 `new int(0)` 的内存地址，分配控制块内存，计数 1
std::shared_ptr<int> p3 = std::make_shared<int>(0); // 分配一次内存(数据块+计数块), 数据指针指向数据块，控制块计数为1
```

`make_shared` 只分配一次内存，效率更高，且能够有效避免内存碎片的产生。

### 获取裸指针

`std::shared_ptr<T>` 构造函数中传入了一个对象指针。它同时提供了一个 `get()` 方法用来返回裸指针，但是在使用裸指针时要注意其生命周期。

### `shared_ptr<T>` 是线程安全的吗？

`shared_ptr` 的引用计数是原子操作，因此是线程安全的。但是 `shared_ptr` 指向的对象以及 `shared_ptr` 自身并不是线程安全的。在多线程中修改 `shared_ptr` 指向的数据或修改 `shared_ptr` 自身的指向可能对其他线程的 `shared_ptr` 造成破坏。

### `enable_shared_from_this`

考虑下面的代码会有什么问题。

```cpp
#include <memory>

class A {
public:
    std::shared_ptr<A> getPtr(){
        return std::shared_ptr<A>(this);
    }
};

int main(int argc, char **argv){
    auto p1 = std::shared_ptr<A>(new A());
    auto p2 = p1->getPtr();
}
```

运行这段代码会发现 `A` 会被析构两次。因为 `std::shared_ptr<A>(this)` 会增加一次引用计数，而返回的 `shared_ptr` 和之前的 `shared_ptr` 是没有关联的，所以会各自析构一次。下面的代码有同样的问题。

```cpp
void test(){
    A *p = new A();
    auto p1 = std::shared_ptr<A>(p);
    auto p2 = std::shared_ptr<A>(p);
    // p1 和 p2 各自独立
}
```

`enable_shared_from_this` 就是为了解决通过对象获取自身的智能指针的问题。

```cpp
#include <memory>

class A std::enable_shared_from_this<A> {};

int main(int argc, char **argv){
    auto p1 = std::shared_ptr<A>(new A());
    auto p2 = p1->shared_from_this(); // 同 auto p2 = std::weak_ptr<A>(p1);
}
```

`enable_shared_from_this` 内部也是通过 `weak_ptr` 的原理来实现的。

### 自定义 `shared

_ptr` 删除器

```cpp
#include <memory>

int main() {
    auto customDeleter = [](int* p) {
        std::cout << "Custom deleting: " << *p << std::endl;
        delete p;
    };

    std::shared_ptr<int> sharedPtr(new int(42), customDeleter);

    // 使用 sharedPtr，最后会调用 customDeleter 进行释放
    return 0;
}
```