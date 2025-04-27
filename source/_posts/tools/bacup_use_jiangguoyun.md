---
title: 利用坚果云自动备份文件
date: 2025-04-27 14:26:22
tags: [rclone]
categories: 工具
---

坚果云提供了 webdav 协议，可以用 rclone 进行文件的上传。

1. 登录坚果云 `https://www.jianguoyun.com/#/safety` 添加应用，获得密码
2. 安装 `rclone`
3. `rclone config` 添加坚果云配置，按照提示一步一步来就行,依次填写
    1. name: 随便填，下面与 `jianguoyun` 为例，后面传输文件的时候会用到该字段
    2. Storage: 选 WebDav
    3. url: 填坚果云地址 `https://dav.jianguoyun.com/dav/`
    4. vendor: 选 other
    5. user: 填自己的坚果云账户
    6. password: 填前面步骤中获取的应用密码，非坚果云账户密码
4. 测试 `rclone lsd jianguoyun:` 如果能显示网盘的信息，就表示配置成功

上传文件
```shell
rclone copy /path/to/local jianguoyun:/path/to/remote
```

坚果云免费用户每月只提供 1G 上传流量

