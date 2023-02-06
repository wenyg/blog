---
title: "C++对象模型(6): 运行时"
tags: [C++]
categories: C++对象模型
date: 2023-02-03 20:13:21
---

想象一下下面这句话执行的时候会发生什么

```C++
if (yy == xx.getValue()){
    //...
}
```

<!-- more -->

xx 和 yy 定义如下

```C++
class Y{
    public:
        Y();
        ~Y();
        bool operator==(const Y&) const;
};
class X{
    public:
        X();
        ~X();
        operator Y() const;
        X getValue();
};
```

yy ==  明显需要调用一个等号运算符`yy.operator==()`。 但是 xx.getValue() 返回的是一个 X 对象，所以需要调用 `xx.openrator Y()` 运算符将其转换为 Y 对象。上面的展开了其实就是

```C++
if (yy.operator==(xx.getValue().operator Y())){
    //...
}
```

以上的发生的一切，都是编译器根据 class 的隐含语义生成的。当然我们也可以明确的写出这样的例子，但是不建议，它只会时编译速度稍微快一些。并没有其他好处。

![runtime_semantincs_1.png](https://note.youdao.com/yws/res/20541/WEBRESOURCE7a1cdbd495687904b1cf0a694f165136)

实际程序运行时会比这复杂

1. 产生临时 x 对象，放置 `getValue()` 返回值
2. 产生临时 y 对象，放置 `operator Y()` 返回值
3. 产生临时 int 对象，放置 `yy.operator==()` 返回值


所以最开始的一行代码，会被转换为如下形式

```C++
X temp1 == xx.getValue();
Y temp2 == temp1.operator Y();
int temp3 = yy.operator==(temp2);

if (temp3){
    //...
}
temp2.Y::~Y();
temp1.X::~X();
```

C++就是这样，不太容易从源码表达式上看出它的复杂度。

## 对象的构造和析构

一般来说，对应的构造和析构安插如我们所想的那样

```C++
{
    Point point;
    // point.Point::Point();
    ...
    // point.Point::~Point();
}
```

如果区段中有多个离开点(多处 return)，情况会复杂一些，析构必须被放置在每一个离开点之前。  
同时我们声明变量的时候，最好在使用他的时候才开始定义，否则可能会造成不必要的构造，析构。

```C++
if (cache){
    return 1;
}

Point point;
```

如果我们在检查 cache 之前就声明 point。那么就可能会造成 Point 对象不必要的构造与析构开销


### 全局对象

假如我们有以下代码

```C++
Matrix identity;

int main(){
    Matrix m1 = identity;
    
    return 0;
}
```

C++ 保证，一定会在第一次用到全局变量之前把它构造出来，并且在 main 函数结束之前，把它销毁掉。

> 通常不建议直接使用全局变量，建议将全局变量包装成一个函数。否则容易造成初始化灾难，比如两个全局变量，分别在不同的源文件中，并且其中一个变量用到了另一个变量，就可能会造成使用前未被初始化的问题。

```C++
Matrix& x(){
    static Matrix* identity = new Matrix();
    return *identity;
}
```
### 局部静态对象

假设有以下片段

```C++
const Matirx& identity(){
    static Matrix mat_identity;
    return mat_identity;
}
```
局部静态对象保证，mat_identity的构造和析构只调用一次，即使 identity() 可能被调用多次。

> 如果你是一个编译器开发者，你会怎么保证该特性

现在C++标准中要求，编译单位中的局部静态对象必须被摧毁--以构造相反的顺序摧毁，。但是由于这些 object 是在需要时才被构造，所以编译时期无法预知其集合以及顺序。为了支持这个规则，可能需要对被产生出来的局部对象保持一个执行器链表。

### 对象数组

假设有一下数组定义

```C++
Point knots[10];
```
编译会有对应的函数来生成该数组，通常函数形式可能如下

```C++
void *vec_new(
    void *array, 
    size_t elem_size, 
    int elem_count, 
    void (*constructor)(void *),
    void (*destructor)(void *, char)
)
```
> 对于支持异常处理的编译器，传入一个destructor 是有必要的

编译器实际运行的时候就可能对我们声明的数组做 vec_new 操作

```C++
Point knots[10];
vec_new(&knots, sizeof(Point), 10, &Point::Point, 0)
```

显然释放也一样

```C++
void *vec_delete(
    void *array, 
    size_t elem_size, 
    int elem_count, 
    void (*destructor)(void *, char)
)
```

有些编译器会另外增加一些参数，便于有条件的导引 vec_delete 的逻辑

## new 和 delete 运算符

new 运算符总是以 C 的 malloc() 完成，虽然没有规定一定这么做。 相同情况，delte 总是以 free() 完成

## 临时对象

临时对象的被摧毁，应该是对完整表达式求值过程中的最后一个步骤

```C++
((objA > 1024) && (objB > 1024)) ? objA + objB : foo(objA, objB)
```

以上包含 5 个表达式，任何一个表达式所产生的任何一个临时对象，都应该在完整表达式被求值完成后，才可以被毁去。

