---
title: 从TCP到HTTPS代码实现-https服务器
date: 2019-04-27 21:10:43
tags: [openssl, https]
categories: 废话少说,放码过来
---

https 就是在http和tcp之间加一道加密的过程, 在代码上的实现和一般的TCP Server区别就两点

1. 在accpet之后要由ssl接管套接字, 协商加密算法,交换密钥等.
2. 之后的send(), recv()替换成SSL的 SSL_write(), SSL_read()

<!-- more -->

### 代码实现

#### https_client.c
```c
#include <openssl/bio.h>  
#include <openssl/ssl.h>  
#include <openssl/err.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

#define SERVER_PORT 443
#define CA_CERT_FILE "server/ca.crt"
#define SERVER_CERT_FILE "server/server.crt"
#define SERVER_KEY_FILE "server/server.key"

SSL_CTX  *ssl_ctx_int();
SSL *client_ssl_init(SSL_CTX *ctx, int fd);
int bind_and_listen();

int main(int argc, char **argv)  
{  
    printf("Server Running at hppts://127.0.0.1/\n");

    int data_len;  
    struct sockaddr_in addr;   
    int listen_fd, accept_fd;  
    socklen_t len  = sizeof(addr);
    SSL_CTX *ctx = ssl_ctx_int();
    listen_fd = bind_and_listen();
    int times = 0;
    while(1){
        char recvbuf[1024] = {0};
        char sendbuf[1024] = {0};
       
        accept_fd = accept(listen_fd, (struct sockaddr *)&addr, &len);
        SSL *ssl = client_ssl_init(ctx, accept_fd);
        data_len = SSL_read(ssl,recvbuf, sizeof(recvbuf));  
        fprintf(stdout, "[%d] Get %d data:\n%s\n",times++, data_len, recvbuf);

        sprintf(sendbuf, "HTTP/1.0 200 OK\r\n\r\n<h1>hello ssl! [%d]</h1>", times);
        SSL_write(ssl, sendbuf, strlen(sendbuf));  
    
        SSL_free (ssl);  
        close(accept_fd);
    }
    SSL_CTX_free (ctx);  
    return 0;
}
```
#### ssl_ctx_int()
SSL初始化,服务器加载证书私钥
```c
SSL_CTX  *ssl_ctx_int(){
    SSLeay_add_ssl_algorithms();  
    OpenSSL_add_all_algorithms();  
    SSL_load_error_strings();  
    ERR_load_BIO_strings();  
    SSL_CTX *ctx = SSL_CTX_new (SSLv23_method());
    if(ctx == NULL){
        printf("SSL_CTX_new error!\n");
        exit(0);
    }

    // 是否要求校验对方证书 此处不验证客户端身份所以为： SSL_VERIFY_NONE
    SSL_CTX_set_verify(ctx, SSL_VERIFY_NONE, NULL);  

    // 加载CA的证书  
    if(!SSL_CTX_load_verify_locations(ctx, CA_CERT_FILE, NULL)){
        printf("SSL_CTX_load_verify_locations error!\n");
        ERR_print_errors_fp(stderr);
        exit(0);
    }

    // 加载自己的证书  
    if(SSL_CTX_use_certificate_file(ctx, SERVER_CERT_FILE, SSL_FILETYPE_PEM) <= 0){
        printf("SSL_CTX_use_certificate_file error!\n");
        ERR_print_errors_fp(stderr);
        exit(0);
    }

    //加载自己的私钥  私钥的作用是，ssl握手过程中，对客户端发送过来的随机
    //消息进行加密，然后客户端再使用服务器的公钥进行解密，若解密后的原始消息跟
    //客户端发送的消息一直，则认为此服务器是客户端想要链接的服务器
    if(SSL_CTX_use_PrivateKey_file(ctx, SERVER_KEY_FILE, SSL_FILETYPE_PEM) <= 0){
        printf("SSL_CTX_use_PrivateKey_file error!\n");
        ERR_print_errors_fp(stderr);
        exit(0);
    }

    // 判定私钥是否正确  
    if(!SSL_CTX_check_private_key(ctx)){
        printf("SSL_CTX_check_private_key error!\n");
        ERR_print_errors_fp(stderr);
        exit(0);
    }
    return ctx;
}
```
#### client_ssl_init()
和客户端ssl握手,协商算法,交换公钥等
```c
SSL *client_ssl_init(SSL_CTX *ctx, int fd)
{
    if (ctx == NULL){
        printf("The SSL_CTX is NULL\n");
        exit(0);
    }
    // 将连接付给SSL  
    SSL *ssl = SSL_new (ctx);
    if(!ssl){
        printf("SSL_new error!\n");
        ERR_print_errors_fp(stderr);
        exit(0);
    }
    SSL_set_fd (ssl, fd); 
    if(SSL_accept (ssl) != 1){
        int icode = -1;
        ERR_print_errors_fp(stderr);
        int iret = SSL_get_error(ssl, icode);
        printf("SSL_accept error! code = %d, iret = %d\n", icode, iret);
    }

    return ssl;
}
```
#### bind_and_listen()
建立套接字,绑定并监听,这个没什么说的
```c
int bind_and_listen()
{
    int listen_fd;
  
    listen_fd = socket(AF_INET, SOCK_STREAM, 0);
    if( listen_fd == -1 ){
        printf("socket error\n");
        exit(0);
    }
    int one = 1;
    if (setsockopt(listen_fd, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one)) < 0) {
        printf("setsockopt error\n");
        close(listen_fd);
    }
    struct sockaddr_in sin;
    sin.sin_family = AF_INET;
    sin.sin_addr.s_addr = 0;
    sin.sin_port = htons(SERVER_PORT);

    if(bind(listen_fd, (struct sockaddr *)&sin, sizeof(sin)) < 0 ){
        printf("Bind error\n");
        exit(0);
    }

    if(listen(listen_fd, 5) < 0){
        printf("listen error\n");
        exit(0);
    }

    return listen_fd;
}
```
### 编译运行
把上面的代码写到一个文件当中命名为https_server.c
```bash
gcc https_server.c -lssl -lcrypto -o https_server
```
此时还不能运行,还要生成服务器密钥,证书才可以, 看一下代码中宏定义的路径,生成证书放到相应路径
```
sudo ./https_server #监听443端口 需要root权限
```
然后打开浏览器,访问 [https://127.0.0.1/](https://127.0.0.1/), 因为证书是自制的,所以一般会拦截. 测试Chrome浏览器会拦截无法访问, 用Firefox忽略风险可以继续访问.