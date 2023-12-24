---
title: "PyTorch 与 C++ Torch 混合编程问题排查"
date: 2022-08-01 19:41:29
tags: [C++, 链接]
categories: "BUG调试"
---

## 问题

在公司的一个项目中，需要同时使用 C++ 和 Python 的一些接口。项目的主要语言是 Python，通过 pybind11 调用 C++ 的接口。然而，在实际运行过程中出现了 torch 符号未定义的问题，尽管 Python 和 C++ 使用的 torch 都是相同版本（PyTorch 调用的也是 C++ 的 so），理论上不应该出现这样的问题。

## 排查

尽管两个 torch 版本相同，但它们的安装方式不同。PyTorch 是通过 pip 安装的，而 C++ Libtorch 是通过源码编译的方式安装的。虽然两者版本相同，但通过使用 `nm` 查看符号表发现两个 torch.so 的符号表确实不一样。最终排查发现，由于 [Dual ABI](https://gcc.gnu.org/onlinedocs/libstdc++/manual/using_dual_abi.html) 的原因，libtorch 在编译时采用的是 cxx11 ABI，而 Python 中的 torch 使用的是 Pre-cxx11 ABI，两者版本的符号不兼容，导致冲突问题。

## 解决方案

1. 重新编译 C++ 项目相关的代码和库，全部使用旧 ABI。然而，使用旧 ABI 编译的可行性尚待调研。考虑到目前几乎所有的代码都是以 cxx11 编译，包括很多系统库也选择了 cxx11 的 ABI，因此全部重新编译并不现实。该方案被否决。
2. 重新编译 Python 中的 torch，使用新的 ABI。