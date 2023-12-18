---
title: protobuf实践
tags: [protobuf]
categories: 开发者手册
date: 2023-02-09 19:45:55
---

## 安装 protoc

protoc 用来编译 proto 文件，将 proto 文件编译成各个语言所需要的代码。去 github 上找对应平台的预编译好的二进制包使用即可, 文件格式 protoc-{VERSION}-{OS}-{ARCH}

```
https://github.com/protocolbuffers/protobuf/releases


```

## proto 命名规则

- message names 使用 CamelCase
- fields names 使用 underscore_separated_names
- repeated fields 使用复数形式
- 枚举值 使用 CAPITALS_WITH_UNDERSCORES

```proto

```

