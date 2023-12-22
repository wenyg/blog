---
title: "字符串三剑客: awk"
date: 2022-05-20 17:28:04
tags: [shell,awk]
categories: 工具 
---

`awk` 是一个强大的文本处理工具，用于处理结构化文本数据。以下是一些在使用 `awk` 时的小技巧：

1. **基本用法：**
   ```bash
   awk '{print $1}' filename
   ```

   这将打印文件中每行的第一个字段。

2. **指定字段分隔符：**
   ```bash
   awk -F':' '{print $1}' /etc/passwd
   ```

   这将使用冒号作为字段分隔符来处理 `/etc/passwd` 文件。

<!-- more -->

3. **条件匹配和处理：**
   ```bash
   awk '/pattern/ {print $2}' filename
   ```

   这将打印包含指定模式的行的第二个字段。

4. **计算和使用变量：**
   ```bash
   awk '{sum+=$1} END {print sum}' filename
   ```

   这将计算文件中第一个字段的总和，并在文件结束时打印结果。

5. **自定义输出格式：**
   ```bash
   awk '{printf "Name: %-10s Age: %s\n", $1, $2}' filename
   ```

   这将按照指定格式输出字段内容，使用 `printf` 函数。

6. **处理列之间的关系：**
   ```bash
   awk '$2 > 50 {print $1, "is greater than 50"}' filename
   ```

   这将打印第一个字段，如果第二个字段大于50，则输出附加信息。

7. **统计行数：**
   ```bash
   awk 'END {print NR}' filename
   ```

   这将在文件结束时打印行数。

8. **自定义分隔符输出：**
   ```bash
   awk '{print $1 "|" $2}' filename
   ```

   这将在输出中使用自定义分隔符。
