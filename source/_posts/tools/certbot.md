---
title: 申请 ssl 证书
date: 2025-04-24 15:35:22
tags: [certbot]
categories: 工具
---

Let's Encrypt 提供免费的 SSL/TLS 证书，Certbot 是官方推荐的自动化客户端，用于申请和续期证书。

事先准备
1. 服务器安装 certbot
2. 域名解析，将域名解析到服务器上
3. certbot 申请证书  （需要先停止该服务器上的 80 端口的服务）
    ```
    sudo certbot certonly -d  www.winn.cc --nginx
    Saving debug log to /var/log/letsencrypt/letsencrypt.log
    Requesting a certificate for www.winn.cc

    Successfully received certificate.
    Certificate is saved at: /etc/letsencrypt/live/www.winn.cc/fullchain.pem
    Key is saved at:         /etc/letsencrypt/live/www.winn.cc/privkey.pem
    This certificate expires on 2025-07-23.
    These files will be updated when the certificate renews.
    Certbot has set up a scheduled task to automatically renew this certificate in the background.
    ```
4. 第三步中的路径是个符号链接，用 realpath 获取真实文件路径
5. 部署

