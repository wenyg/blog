---
title: Ubuntu 安装sublime
date: 2019-07-11 21:36:43
tags: [sublime]
categories: 工具
---

1. 信任sublime的密钥

   ```
   wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
   ```

2. 添加subilme的仓库

   ```
   echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee \
     /etc/apt/sources.list.d/sublime-text.list
   ```

3. 安装sublime

   ```
   sudo apt-get update
   sudo apt-get install sublime-text
   ```

4. 启动

   ```
   subl
   ```

   

