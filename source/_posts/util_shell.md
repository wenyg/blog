---
title: shell 使用技巧
tags: [shell]
categories: 开发者手册
date: 2023-03-24 11:16:26
---

### 修改全局变量

```shell
#!/bin/bash

my_var="initial value"

my_function() {
  # 声明 my_var 为全局变量
  declare -g my_var
  my_var="new value"
}

echo "Before function call: my_var=$my_var"
my_function
echo "After function call: my_var=$my_var"
```

### 未定义变量默认值

当我们希望一个变量在未定义时使用默认值，可以使用${VAR_NAME:-default_value}的方式。如果VAR_NAME未被定义，则会使用默认值，否则使用VAR_NAME的值。下面是一个例子：

```shell
#!/bin/sh

# 如果 MY_VAR 没有被定义则赋值为 default_value
MY_VAR=${MY_VAR:-default_value}

echo "MY_VAR 的值是: $MY_VAR"
```

在上面的例子中，如果我们运行该脚本时没有定义MY_VAR这个变量，那么就会输出：

```shell
MY_VAR 的值是: default_value
```

### 查找内容中包含某某字符串的文件

```shell
grep -r "xxx" .
```

上述命令将在当前目录及其所有子目录中递归查找包含 "xxx" 的所有文件。如果只希望搜索特定类型的文件，例如 .js 源文件，则可以指定该文件类型。

```shell
grep -r "xxx" --include \*.js .
```



