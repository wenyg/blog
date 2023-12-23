---
title: 搭建 sftp server
tags: [docker,sftp]
categories: 工具
date: 2022-04-03 19:45:55
---

有些时候我们开发需要接触涉及到一些sftp接口，比如 sftp 上传文件， sftp下载文件，这时候可以用 docker 快速的搭建一个sftp server 用于测试开发。

**拉镜像**

```bash
docker pull atmoz/sftp
```

**启动 sftp 服务**

```bash
docker run -d -v /path/to/shared/folder:/home/username/upload -p 2222:22 -e SFTP_USERS=username:password:::upload atmoz/sftp
```

- /path/to/shared/folder 是想要共享的文件夹的本地路径。
- username 是要创建的用户名。
- password 是用户的密码。
- -p 2222:22 将容器的 22 端口映射到主机的 2222 端口，这是 SFTP 默认的端口。

**测试**

```bash
sftp -P 2222 username@localhost:/upload/xxx xxx
```

- 要用 sftp 而不是 scp
- 下载路径是 /upload/， 而不是 /home/username/upload