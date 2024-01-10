---
title: 浅析 lambda 表达式 
date: 2024-01-09 19:52:13
tags: [C++,lambda]
categories: "C++11/14/17"
---

lambda 中的函数调用和普通函数调用有什么区别？

这是一个普通的函数调用

```cpp
int add(int x, int y){
    return x + y;
}

void invoke(){
    // 普通函数调用
    add(11,17);
}
```

这是一个 lambda 函数调用

```cpp
void invoke(){
    auto add = [](int x, int y){
        return x + y;
    };
    //lambda 函数的调用
    add(11,17);
}
```

下面一起来解开他们的头盖骨，看看下面到底是什么东西。

## 汇编角度

他们的汇编代码如下， 可以 [点击此处查看](https://gcc.godbolt.org/z/jKsvYaE9c)

![lambda 函数与普通函数汇编比较](/d/img/lambda/lambda_compare.jpg)

查看他们的汇编代码，可以发现 lambda 表达式最后也会被编译成一个函数，调用方式也是常见的函数栈调用，从这个角度来看，lambda 就是一个匿名函数。

但仔细观察，他们还是稍微还是有一点差异，如下

![lambda 函数与普通函数汇编差异](/d/img/lambda/diff.jpg)

至于为什么会有这样的差异，接下来会讲。


## C++ 角度

从 C++ 的角度，解释 lambda 到底是什么，先看下面的示例，下面的代码与上面的 lambda 函数调用代码在汇编代码中等价，[点击查看汇编代码](https://gcc.godbolt.org/z/jqbc9Pjz6)

```cpp
void invoke()
{
  class __invoke_add{
    public: 
    inline int operator()(int x, int y) const {
      return x + y;
    }
  };
  
  __invoke_add add;
  add.operator()(11, 17);
}
```
> 注意仅仅是在该示例中等价，实际上lambda函数在编译时还会有一个类型转换操作符，用于将lambda对象转换为一个函数指针，本例中没有涉及，故省略。

简单一句话就是编译器会将 lambda 函数编译成一个匿名类， 重载它的 `operator ()` 方法。

回头来解释上面汇编的几处差异，

```assembly
invoke()::{lambda(int, int)#1}::operator()(int, int) const:
        pushq   %rbp
        movq    %rsp, %rbp
        movq    %rdi, -8(%rbp) ; 这里是匿名类对象的地址，也就是 C++ 中的 this 指针。
        movl    %esi, -12(%rbp)
        movl    %edx, -16(%rbp)
        movl    -12(%rbp), %edx
        movl    -16(%rbp), %eax
        addl    %edx, %eax
        popq    %rbp
        ret
invoke():
        pushq   %rbp
        movq    %rsp, %rbp
        subq    $16, %rsp ; 因为声明了一个匿名类对象，所以要开辟一个新的栈帧
        leaq    -1(%rbp), %rax ; 没有任何数据成员的类对象，其大小为 1， rax里放到是类对象的地址
        movl    $17, %edx
        movl    $11, %esi
        movq    %rax, %rdi ; 将匿名类对象的地址放入 rdi 寄存器
        call    invoke()::{lambda(int, int)#1}::operator()(int, int) const
        nop
        leave
        ret
```

**lambda参数捕获**

拿捕获的变量为 `int base=5;` 举例。

`=` 捕获相当于匿名类内部有个 `int base;`  私有变量。构造函数是 `__invoke_add(int &_base): base(_base) {};`

`&` 捕获相当于匿名类内部有个 `int &base;` 私有变量。构造函数同上。