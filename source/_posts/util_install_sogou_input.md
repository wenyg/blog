---
title: Ubuntu18.04安装搜狗输入法
date: 2019-07-23 09:21:43
tags: [输入法]
categories: 工具
---
虽然说大多数程序的安装，按找官方文档一步一步往下执行就好了，但是还是有一些软件官方文档支持的不好，比如搜狗Linux下的输入法，按官方文档安装完之后，输入法还是不能用。记录下ubuntu下搜狗输入法的安装步骤。

1. 安装fcitx。 fcitx是搜狗输入法的依赖项

   ```
   sudo apt install fcitx-bin
   sudo apt install fcitx-table
   ```

2. 在**语言支持**(Language Support)中配置fcitx。

    把**键盘输入法系统**(Keyboard input method system)的默认方法 **iBus** 替换为 **fcitx** 。

3. 重启系统，重启系统，重启系统。 重要的事情说三遍。

4. 下载 [搜狗输入法For Linux](https://pinyin.sogou.com/linux/?r=pinyin) 安装

5. 还是要重启，之后就可以在右上角设置输入法了。

6. 最后，其实安装不上也没关系，多用用英语吧，挺有用的。