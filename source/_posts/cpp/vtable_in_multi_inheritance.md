---
title: "C++多继承下的内存布局"
tags: [C++]
date: 2024-01-21 23:11:12
categories: C++对象模型
---

下面是一个多继承的示例， C 继承了 A 和 B。

```cpp
#include <cstdio>

class A  {
public:
    long varA;
    virtual void funA1(){ std::puts("A::funA1()");};
    virtual void funA2(){ std::puts("A::funA1()");};
};

class B {
public:
    int varB;
    virtual void funB1(){ std::puts("B::funB1()");};
    virtual void funB2(){ std::puts("B::funB2()");};
};

class C: public A, public B {
public:
    int varC;
    virtual void funA1(){ std::puts("C::funA1()");};
    virtual void funB2(){ std::puts("C::funB2()");};
    virtual void funC(){ std::puts("C::funC()");};
};
```

开始本文章之前，先思考下面几个问题

1. A, B, C的对象大小应该都是多大？
2. 有 `A* a = new C();`， 那么 `typeid(*a)` 返回的会 A 的信息，还是 C 的信息？
3. 有函数 `void process(A *a);`, 该函数内部，能否访问到 `B::funB1` / `B::funB2` 吗?
4. 只给一个类C的指针，怎么不用他的函数接口来访问它的虚函数？
5. 虚函数调用会增加访问调用开销吗？多重继承得到的虚函数和一层的继承得到的虚函数，他们调用开销一样吗？

如果你对上面的问题了如指掌，建议跳过本文章。

## 多继承内存布局

A,B,C 的内存布局与虚函数表如下

> 可以通过 `g++ -fdump-lang-class -c base.cpp`  来看到C++ 类的虚函数表和内存布局

![多继承下的虚函数表与内存布局](/d/img/cpp/virtual_function_table.jpg)

我们先以class A 为例， 讲解下虚函数表的内容。

```
--------------
0              // Offset 内部子对象偏移量，后面会讲
--------------
typeinfo for A // RTTI信息，dynmaic_cast 转换的时候会根据这个判断是否能转换
--------------
A::funA1()     //  虚函数表指针指向的位置，注意，虚函数表指针指向的是该位置，而不是虚函数表的开头
--------------
A::funA2()
--------------
```

因为基类的内存布局要在派生类中保证完整性，比如示例中 C 的内存布局可以拆分成两块，一块用来表示子对象A，一块用来表示子对象B。上面的 Offset 就是子对象相当于 C 对象的偏移。通常多继承的情况下，第一个子对象在内存布局的最顶部，所以 Offset 为 0，但是之后其它子对象的 Offset 就不为 0 了， 比如示例中的 子对象 B ，其 Offset 就为 16，也就是子对象 A 的大小，8 字节的vptr，8 字节的 var A。这个Offset有什么用呢，为什么要引入Offset呢? 该字段在基类向派生类转换的时候会用到。

## 基类派生类转换


### 派生类->基类

首先要知道，派生类到基类的转换，百分百会成功，因为所谓的转换就是对指针进行调整，使其指向子对象的位置，这个动作编译器在编译期间就已经确定了。

```cpp
void fun(C *c){
    B *b = c; // 编译器会进行隐式转换，使指针B指向C内部子对象b的位置。
    printf("c: %p\n", c); // c: 0x000000000010
    printf("b: %p\n", b); // b: 0x000000000020
}
```

### 基类->派生类

但是当基类到派生类转换的时候，如果通过基类对象的地址找到其原本派生类对象的地址呢？ 这就用到了前面提到的 Offset，它表明了内部子对象到在原始对象内部的偏移，通过这个偏移就可以找到原始对象的地址。

```cpp
int main() {
    C c1;
    B *b = &c1;
    C *c2 = dynamic_cast<C *>(b); 
    printf("c1: %p\n", &c1); // c1: 0x000000000010
    printf("b : %p\n", b);   // b : 0x000000000020
    printf("c2: %p\n", c2);  // c2: 0x000000000010
}
```

## 访问虚函数

试着运行下, 并理解下下面的代码, [点击此处查看](https://compiler-explorer.com/z/EP1e6qjb5)

```cpp
#include <cstdio>

class A  {
public:
    long varA;
    virtual void funA1(){ std::puts("A::funA1()");};
    virtual void funA2(){ std::puts("A::funA1()");};
};

class B {
public:
    int varB;
    virtual void funB1(){ std::puts("B::funB1()");};
    virtual void funB2(){ std::puts("B::funB2()");};
};

class C: public A, public B {
public:
    int varC;
    virtual void funA1(){ std::puts("C::funA1()");};
    virtual void funB2(){ std::puts("C::funB2()");};
    virtual void funC(){ std::puts("C::funC()");};
};

int main(int argc, char **argv){
    C c;
    using Fun = void (*)();
    Fun *virtual_table = ((Fun**)&c)[0];

    //  virtual_table[-2] 内部子对象 A 的偏移
    //  virtual_table[-1] typeinf
    virtual_table[0]();
    virtual_table[1]();
    virtual_table[2]();
    virtual_table[3]();
    //  virtual_table[3] 内部子对象 B 的偏移
    //  virtual_table[4] typeinfo
    virtual_table[6]();
    virtual_table[7](); // thunk 间接调用
}
```

回过头来在回顾一下前面的几个问题，心里应该有些许答案了吧。

## 深入思考

如果 类 A 和类 B 都继承了一个 Base 类，那么 A 和 B 内部都有了 Base 类的成员。 那么 C 内部岂不是有两份 Base 的数据成员？怎么解决这个问题？
