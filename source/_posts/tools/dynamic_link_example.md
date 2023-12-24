---
title: "动态链接多个同名不同版本函数"
date: 2023-12-24 17:33:58
tags: [dl, C++, 符号修饰]
categories: 工具
---

在软件开发中，版本管理至关重要。但是，某些极端情况，需要同时运行一个接口的不同版本的函数，那么有没有可能实现呢。

比如下面有两个版本的 `fun` 函数，他们函数签名，都完全一样，能在一个程序中同时调用这两个函数吗？

```cpp
// v1/fun.cpp
const char* fun() {
    return "fun version 1";
}

// v2/fun.cpp
const char* fun() {
    return "fun version 2";
}
```

<!-- more -->

在上述代码中，我们定义了两个版本的函数 `fun()`，分别位于目录 `v1/` 和 `v2/` 下。接下来，我们将这两个版本编译成共享库（.so 文件）：

```bash
g++ -shared -fPIC -o v1/fun.so v1/fun.cpp
g++ -shared -fPIC -o v2/fun.so v2/fun.cpp
```

然后，我们在 `main.cpp` 中调用这两个共享库中的 `fun` 函数：

```cpp
#include <dlfcn.h>
#include <iostream>

typedef const char* (*fun_ptr)();

int main() {
    // 打开 v1 版本的共享库
    void* handle_v1 = dlopen("v1/fun.so", RTLD_LAZY);
    fun_ptr fun_v1 = reinterpret_cast<fun_ptr>(dlsym(handle_v1, "_Z3funv"));

    // 打开 v2 版本的共享库
    void* handle_v2 = dlopen("v2/fun.so", RTLD_LAZY);
    fun_ptr fun_v2 = reinterpret_cast<fun_ptr>(dlsym(handle_v2, "_Z3funv"));

    // 调用并输出两个版本的函数
    std::cout << "Calling v1/fun(): " << fun_v1() << std::endl;
    std::cout << "Calling v2/fun(): " << fun_v2() << std::endl;

    // 关闭共享库
    dlclose(handle_v1);
    dlclose(handle_v2);

    return 0;
}
```

在上述代码中，我们使用了 `dlsym` 函数来获取函数指针，注意参数中的函数名是 `_Z3funv`，而不是`fun`。在编译并运行程序之前，你可以通过 `nm v1/fun.so` 查看符号表以获取正确的符号名。

最后，编译并运行程序：

```bash
g++ main.cpp -ldl
./a.out
```

通过以上步骤，你将能够看到以下输出结果：

```text
Calling v1/fun(): fun version 1
Calling v2/fun(): fun version 2
```

通过 dl 库，我们发现在一个程序中同时调用这一个函数的不同版本是可行的。（实际项目中一定要避免这种情况，做好版本管理）

上述示例代码可在 https://github.com/wenyg/dynamic_link_example 查看