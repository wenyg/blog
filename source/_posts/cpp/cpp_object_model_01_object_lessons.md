---
title: "C++对象模型(1): 关于对象"
tags: [C++]
date: 2023-02-04 23:11:12
categories: C++对象模型
---

在 C 语言当中，“数据” 和 “处理数据的函数” 是分开声明的，语言本身并没有支持 “数据和函数” 之间的关联性。C++ 则有抽象数据类型，其中不仅有“数据”， 还有处理数据相关的操作。

将 C 中的 strcut+函数 转换成 C++的抽象数据类型，会增加多少成本呢？ 经常有人说，C++ 会比 C 慢， 慢在哪里呢？

<!-- more -->

答案是并没没有增加成本，C++ 也不会比 C 慢。 通常 C++ 比 C 慢主要是 virtual 引起的

- virtual function 机制，用于支持执行期绑定
- virtual base class， 用于实现“多次出现在继承体系中的 base class，有一个单一而被共享的实例”

### C++ 对象模型

C++对象模型包含哪些东西

- 成员变量，静态成员变量
- 函数，静态函数，虚函数

成员变量被配置与每一个对象中，静态变量，函数以及静态函数则是在对象之外。虚函数则稍微不同

- 每一个 class 产生一堆指向虚函数的指针，放在表格这种，这个表格被称为虚函数表
- 每一个 class object 被安插一个指针，指向相关的虚函数表。通常这个指针称为虚函数表指针。虚函数表指针的初始化，重置都由class 的构建函数，析构函数，copy运算符自动完成。
- 每一个 class 所关联的 type_info object (用以只会RTTI) 也经由虚函数表被指出来，通常被放在表格的第一个 slot

### C++中 struct / class 

C 语言中，struct 的内存布局就如我们看到的一样，按照声明从上往下排列。你可能会在 C 语言中看到一些 “巧妙” 的设计（或许是陋习？）

```C
struct mumble{
  //...
  char pc[1];
}

struct mumble *pmumb1 = (struct mumble*)malloc(sizeof(struct mumble) + strlen(string) + 1);
strcpy(&muble.pc, string);
```

但是在 C++中或许不行，C++中凡出于同一个 access section的数据，必定保证其声明顺序出现在内存布局当中。然而多个 access section的数据，其排列顺序就不一定了。前面的 C 技巧，或许能够有效运行，或许不能。

如果一个程序员迫切的需要一个相当复杂的 C++ class 的某部分数据，使它像 C 声明的那种模样，那么最好将该部分抽取出来成为一个单独的 struct 声明。然后使用组合的方式

```C++
struct C_point {...};
class Point{
  public:
    operator C_point(){return _c_point;}
  private:
    C_point _c_point;
};
```

C struct 在 C++ 中的一个合理用途，就是你需要传递一个 复杂的 class 数据到某个 C 函数中，struct 声明可以将数据封装起来，并保证拥有与 C 兼容的空间布局。

