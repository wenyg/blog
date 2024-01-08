---
title: Shell 使用技巧
tags: [shell]
categories: 工具
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


### 获取脚本所在绝对路径

脚本中涉及到一些路径的时候可以用绝对路径，这样可以再任意地方执行脚本。而不用 cd 到固定的目录

```Bash
## 获取脚本自身所在目录绝对路径
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo "SCRIPT_DIR: $SCRIPT_DIR"

```

### 文件路径相关操作

```Bash
# 获取目录名
DIR=$(dirname /path/file.txt) # /path

# 获取文件名
FILE=$(basename /path/file.txt) # file.txt

# 获取文件名，不带文件类型后缀
FILE_NAME=${FILE.*} # file

```

### 获取环境变量的值

```Bash
# 获取环境变量 VAR 的值，如果没有则是 default_value
VAR="${VAR:-default_value}"
```

### 多行字符串换行符处理

某些 CI/CD 流程中可能会涉及到一些多行字符串，需要对换行符进行特殊处理，比如转义

```Bash
# 原始字符串
original_string=" 这是一个包含
换行符的
字符串 "

# 将换行符替换成 ###
escape_string=$(echo "$original_string" | sed ':a;N;$!ba; s/\n/###/g')
echo $escape_string
# 会输出 "这是一个包含 ### 换行符的 ### 字符串"
```

### 后台执行程序

```shell
$(COMMOND &)
```
同 `nohup COMMOND &`