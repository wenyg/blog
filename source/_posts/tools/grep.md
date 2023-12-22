---
title: "字符串三剑客: grep"
date: 2022-05-01 17:33:58
tags: [shell, grep]
categories: 工具
---

`grep` 命令小技巧

1. **简单搜索：**
   ```bash
   grep "pattern" filename
   ```

   这将在文件中搜索匹配指定模式的行。

2. **忽略大小写：**
   ```bash
   grep -i "pattern" filename
   ```

   `-i` 选项将忽略大小写。

<!-- more -->

3. **显示匹配行的行号：**
   ```bash
   grep -n "pattern" filename
   ```

   `-n` 选项将显示匹配行的行号。

4. **显示不匹配的行：**
   ```bash
   grep -v "pattern" filename
   ```

   `-v` 选项将显示不包含匹配模式的行。

5. **只显示匹配部分：**
   ```bash
   grep -o "pattern" filename
   ```

   `-o` 选项将只显示匹配到的部分。

6. **显示匹配行之前或之后的行：**
   ```bash
   grep -A 2 "pattern" filename   # 显示匹配行及后面2行
   grep -B 2 "pattern" filename   # 显示匹配行及前面2行
   grep -C 2 "pattern" filename   # 显示匹配行及前后各2行
   ```

   `-A`、`-B`、`-C` 选项用于显示匹配行之前或之后的指定行数。

7. **递归搜索子目录：**
   ```bash
   grep -r "pattern" directory
   ```

   `-r` 选项将递归搜索指定目录及其子目录。

8. **显示匹配行的上下文：**
   ```bash
   grep -C 2 "pattern" filename   # 显示匹配行及前后各2行
   ```

   `-C` 选项用于显示匹配行的上下文。

9. **仅显示匹配的行数：**
   ```bash
   grep -c "pattern" filename
   ```

   `-c` 选项将仅显示匹配的行数，而不是具体的行内容。

