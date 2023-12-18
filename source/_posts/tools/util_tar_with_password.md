---
title: tar 带密码压缩
tags: [shell]
categories: 开发者手册
date: 2023-03-30 10:05:45
---

比如对 app 目录进行压缩备份，带上密码，可以使用以下操作

```shell
tar -czvf - /app | openssl enc -aes-256-cbc -e > backup.tar.enc
```

解释一下以上命令：

- `tar -czvf - /app` 将/app目录压缩成一个tar包，并将其输出到stdout。
- `openssl enc -aes-256-cbc -e` 将stdin中的数据用AES-256-CBC算法进行加密，并将加密后的数据输出到stdout。
- `> backup.tar.enc` 将stdout中的数据输出到backup.tar.enc文件中。

<!-- more -->

在执行以上命令时，会提示输入密码，输入密码后就会生成加密后的backup.tar.enc文件。要解密该文件，可以使用以下命令：

```shell
openssl enc -aes-256-cbc -d -in backup.tar.enc | tar -xzvf -
```

解释一下以上命令：

- `openssl enc -aes-256-cbc -d -in backup.tar.enc` 从backup.tar.enc文件中读取加密后的数据，并使用AES-256-CBC算法进行解密，将解密后的数据输出到stdout。
- `tar -xzvf -` 将stdin中的数据解压缩，并将解压缩后的数据输出到stdout。
通过将以上两个命令结合使用，就可以对/app目录进行加密备份和解密恢复了。


### 不使用交互式

密码直接写在命令行中

压缩

```shell
tar -czvf - /app | openssl enc -aes-256-cbc -e -pass "pass:my_super_secret_password" > backup.tar.enc
```

解压

```shell
openssl enc -aes-256-cbc -d -in backup.tar.enc -pass "pass:my_super_secret_password" | tar -xzvf -
```


