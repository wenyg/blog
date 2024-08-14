---
title: "C++对象模型(5): 关于数据"
tags: [C++]
date: 2023-07-12 23:11:12
categories: C++对象模型
---

- 空类也有一字节的大小，因为这才能对对象取地址
- 一个对象的内存布局通常由三部分组成
  1. 非静态成员变量
  2. 内存对齐所填补的空间
  3. 为了支持 virtual 机制而引起的额外负担，比如 vptr
- 传统上，vptr 被安置到所有明确声明的 member 后面，但要看具体编译器实现
- 直观上，通过对象取值 `object.xxx` 比指针取值 `object_point->xxx` 更方便，但实际上是完全一样的，都会被编译器扩展
- 编译器编译的时候会区分
  -  执行data member的指针，指向第一个member (object::member - 1)
  -  指向data member的指针，但是没有指向任何 member
- 下面两种方式，有什么区别
  ```cpp
  X x; 
  x.x == 0.0;
  
  X *px;
  px->x = 0.0;
  ```
  当 X 中含有一个虚基类， 而且 x 正好是虚基类中的成员时，有重大区别。前者可以编译期确定 x 的 offset，但是 px 只能再运行期确定
- 支持多态带来的负担
  1. 导入virtual table 用来存放 virtual function 地址， 这个table的元素数量一般是virtual function的数目再加上一个或两个slots（用于支持RTTI）
  2. 在每一个object中安插一个 vptr 指向 virtual table
  3. 在 constructor 中安插代码用于设置 vptr
  4. 在 deconstructor 中安插代码用于抹除 vptr