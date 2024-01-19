---
title: "初探模板元编程"
date: 2022-10-19 16:37:39
tags: [C++,模板]
categories: "C++11/14/17"
---

## 模板特化

先讲讲模板特化，因为元编程中用到了大量的模板特化。什么是模板特化，比如

```cpp
// 主函数
template <typename T> void process(T data);

// 针对int的特化
template <> void process<int>(int data);
// 针对float的特化
template <> void process<float>(float data);
```

C++的模板元编程中就用到了大量的模板特化, 你如 remove_const 用于去除类型的 const 修饰符

```cpp
  template<typename _Tp>
    struct remove_const
    { typedef _Tp     type; };

  template<typename _Tp>
    struct remove_const<_Tp const>
    { typedef _Tp     type; };
```

实际使用的时候

```cpp
std::remove_const<int>::type a1; // 匹配第一个模板，a1 类型是 int 
std::remove_const<int const>::type a2; // 匹配第二个模板， a2 的类型也是 int
```


## std::integral_constant

大部分模板都继承了 std::integral_constant， 它是一个具有指定值类型，指定值的编译期常量。


```cpp
std::integral_constant<int, 42>::value // 等同于 42
std::integral_constant<int, 42>::type // 等同于 int
```

相关定义如下

```cpp
  /// integral_constant
  template<typename _Tp, _Tp __v>
    struct integral_constant
    {
      static constexpr _Tp                  value = __v;
      typedef _Tp                           value_type;
      typedef integral_constant<_Tp, __v>   type;
      constexpr operator value_type() const noexcept { return value; }
    };

  typedef integral_constant<bool, true>     true_type;

  /// The type used as a compile-time boolean with false value.
  typedef integral_constant<bool, false>    false_type;
```

注意，它特化了两个类型, true_type 和 false_type， 大量的类型判断模板都继承了这两个类型

## is_xxx 

is_xxx 就是大量的模板特化， 拿 is_integral 举例

```cpp
  template<typename>
    struct is_integral
    : public false_type { };

  template<>
    struct is_integral<bool>
    : public true_type { };

  template<>
    struct is_integral<char>
    : public true_type { };

  template<>
    struct is_integral<int>
    : public true_type { };


  // short, long, longlong, unsigned char, unsigned short 等等等
```

大部分 is_xxx 的模板都默认继承了 false_type, 然后特化 xxx 类型继承自 true_type

```cpp
std::is_integral<int>::value // true
std::is_integral<float>::value // false
```

其他的 is_xxx 大同小异

- is_array 特化 T[Size] 或者 T[] 
- is_pointer 特化 T*
- is_lvalue_reference 特化 T&
- is_rvalue_reference 特化 T&&
- ......

但有一部分比如 is_enum, is_union, is_class 无法通过其接口形式来判断，只能通过编译器内置的函数来判断。

还有很多 is_xxx 是复合类型， 就是上面的几个基础类型组合
- is_arithmetic 是否是算数类型 (is_float_point, is_integral)
- is_fundamental 是否是基础类型 (is_arithmetic, is_void, is_nullptr)
- is_reference 是否是左值或者右值引用
- ......

## 其他

不仅可以判断类型，模板元编程还提供了一些其他的模板类，比如
1. 判断属性类型
   - is_const
   - is_volatile
   - ...
2. 查询支持的操作
   - 是否有默认构造函数
   - 是否有虚析构函数
   - ...
3. 查询类型关系
   - is_same
   - is_base_of 是否是另一个类的基类
   - is_convertible 是否能转换到另一个类型
   - ...
4. 变化类型
   - 去除增加 const/volatile
   - 添加或移除引用
   - 添加或移除 singed
   - 添加或移除指针
5. 其他
   - enable_if 条件性的移除函数重载或者模板特化
  
对模板元编程有了大致的了解之后，你就可以对一些模板库初窥门径了，关于模板编程的最好学习资料就是开源库。