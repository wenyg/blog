---
title: "字符串三剑客: sed"
date: 2022-05-13 17:32:11
tags: [shell, sed]
categories: 工具
---



`sed` 小技巧：

1. **替换字符串：**
   ```bash
   sed 's/old_string/new_string/g' filename
   ```

   这将在文件中将所有的 `old_string` 替换为 `new_string`。

2. **删除行：**
   ```bash
   sed '/pattern/d' filename
   ```

   这将删除包含指定模式的行。

<!-- more -->

3. **在行首或行尾插入文本：**
   ```bash
   sed 's/^/prefix/' filename   # 在每一行行首添加前缀
   sed 's/$/suffix/' filename   # 在每一行行尾添加后缀
   ```

4. **显示特定行或行范围：**
   ```bash
   sed -n '5p' filename          # 显示第5行
   sed -n '5,10p' filename       # 显示第5到第10行
   ```

5. **使用变量：**
   ```bash
   my_variable="new_value"
   sed "s/old_value/$my_variable/" filename
   ```

6. **多个替换：**
   ```bash
   sed -e 's/old1/new1/g' -e 's/old2/new2/g' filename
   ```

   这可以在同一次 `sed` 命令中执行多个替换。

7. **保留替换前的备份文件：**
   ```bash
   sed -i.bak 's/old_string/new_string/g' filename
   ```

   `-i.bak` 将替换前的文件备份为 `.bak` 文件。

8. **仅显示匹配部分：**
   ```bash
   sed -n 's/pattern/\1/p' filename
   ```

   这将仅显示匹配到的部分，使用 `\1` 表示匹配到的内容。

9. **转换大小写：**
   ```bash
   sed 's/[a-z]/\U&/g' filename   # 将小写字母转换为大写
   sed 's/[A-Z]/\L&/g' filename   # 将大写字母转换为小写
   ```

   `\U` 和 `\L` 分别用于将后面的文本转换为大写和小写。