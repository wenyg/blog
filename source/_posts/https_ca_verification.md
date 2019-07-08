---
title: openssl证书链验证
date: 2019-04-23 21:10:43
tags: [openssl, https, ssl]
categories: HTTP
---

### 证书链

浏览器是怎么保证访问的网站是正经的官方网站而不是其他的钓鱼网站呢，Chome浏览器访问网站时，可信任的网站地址旁边会有一个绿色的锁标准，表明该网站是可信任的，它是怎么知道该网站是可信任的呢。  

因为浏览器会内置一些证书，其他证书都是有这些证书签发的， 通过内置的证书来验证其他证书的有效性。这些浏览器内置的证书叫做Root CA(根CA证书)， 其他网站的证书都是由Root CA证书一层一层往下签发的。

### 证书认证原理

1. 服务器首先生成一个密钥对，把公钥提交给CA
2. CA用自己的私钥对服务器提供的公钥进行签名得到证书
3. https服务器在与客户端进行连接的时候会将证书和公钥一起发给客户端，客户端用CA的公钥对证书进行验证，对比一致则证明该证书确实是CA发布的。

<!-- more -->

通过以上的机制就就确认的网站的真实性。

### openssl生成证书链

1. 生成Root CA密钥和自签证书

```
openssl genrsa -out ca.key 2048
openssl req -new -x509 -key ca.key -out ca.crt -days 3650
```

2. 生成server端密钥和证书请求

```
openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr
```

3. 用Root CA给server颁发证书前先构造环境(ubuntu 18.04测试通过)

```
cp /etc/ssl/openssl.cnf .
mkdir demoCA/newcerts -p
touch demoCA/index.txt
touch demoCA/index.txt.attr
echo "00" > demoCA/serial
```

4. 用自签Root CA颁发证书。注意，根证书和要签发的证书，国家/省/城市字段要一样，否者会失败

```
openssl ca -in server.csr -out server.crt -cert ca.crt -keyfile ca.key -config openssl.cnf
```