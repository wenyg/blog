---
title: libevent之ssl通信
date: 2019-04-29 19:10:42
tags: [libevent, ssl]
categories: code
---

### 说明
这里用bufferevent进行ssl通信, 是一个简单的回显服务器,接受客户端的消息,并原封不动的响应回去

<!-- more -->

> 这里仅仅是加密的tcp, 并不是https
### 代码
bufferevent_ssl.c
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#include <openssl/ssl.h>
#include <openssl/err.h>
#include <openssl/rand.h>

#include <event.h>
#include <event2/listener.h>
#include <event2/bufferevent_ssl.h>

#define SERVER_CRT "server.crt"
#define SERVER_KEY "server.key"
#define SERVER_PORT 9999
static void
ssl_readcb(struct bufferevent * bev, void * arg)
{
    struct evbuffer *in = bufferevent_get_input(bev);

    printf("Received %zu bytes\n", evbuffer_get_length(in));
    printf("----- data ----\n");
    printf("%.*s\n", (int)evbuffer_get_length(in), evbuffer_pullup(in, -1));

    bufferevent_write_buffer(bev, in);
}

static void
ssl_acceptcb(struct evconnlistener *serv, int sock, struct sockaddr *sa,
             int sa_len, void *arg)
{
    struct event_base *evbase;
    struct bufferevent *bev;
    SSL_CTX *server_ctx;
    SSL *client_ctx;

    server_ctx = (SSL_CTX *)arg;
    client_ctx = SSL_new(server_ctx);
    evbase = evconnlistener_get_base(serv);

    bev = bufferevent_openssl_socket_new(evbase, sock, client_ctx,
                                         BUFFEREVENT_SSL_ACCEPTING,
                                         BEV_OPT_CLOSE_ON_FREE);

    bufferevent_enable(bev, EV_READ);
    bufferevent_setcb(bev, ssl_readcb, NULL, NULL, NULL);
}

static SSL_CTX *
evssl_init(void)
{
    SSL_CTX  *server_ctx;

    /* 初始化openssl库 */
    SSL_load_error_strings();
    SSL_library_init();
    /* 初始化随机种子 */
    if (!RAND_poll())
        return NULL;

    server_ctx = SSL_CTX_new(SSLv23_server_method());

    if (! SSL_CTX_use_certificate_chain_file(server_ctx, SERVER_CRT) ||
        ! SSL_CTX_use_PrivateKey_file(server_ctx, SERVER_KEY, SSL_FILETYPE_PEM)) {
        puts("Couldn't read 'server.key' or 'server.crt' file.  To generate a key\n"
           "To generate a key and certificate, run:\n"
           "  openssl genrsa -out server.key 2048\n"
           "  openssl req -new -key server.key -out server.crt.req\n"
           "  openssl x509 -req -days 365 -in server.crt.req -signkey server.key -out server.crt");
        return NULL;
    }
    SSL_CTX_set_options(server_ctx, SSL_OP_NO_SSLv2);

    return server_ctx;
}

int
main(int argc, char **argv)
{
    SSL_CTX *ctx;
    struct evconnlistener *listener;
    struct event_base *evbase;
    struct sockaddr_in sin;

    memset(&sin, 0, sizeof(sin));
    sin.sin_family = AF_INET;
    sin.sin_port = htons(SERVER_PORT);
    sin.sin_addr.s_addr = htonl(0x7f000001); /* 127.0.0.1 */

    ctx = evssl_init();
    if (ctx == NULL){
        return 1;
    }
    evbase = event_base_new();
    listener = evconnlistener_new_bind(
                         evbase, ssl_acceptcb, (void *)ctx,
                         LEV_OPT_CLOSE_ON_FREE | LEV_OPT_REUSEABLE, 1024,
                         (struct sockaddr *)&sin, sizeof(sin));

    event_base_loop(evbase, 0);

    evconnlistener_free(listener);
    SSL_CTX_free(ctx);

    return 0;
}
```
### 编译
需要libevent-openssl库, 先用`apt search libevent-openssl`查找版本名,然后再安装,带上版本号如`libevent-openssl-2.0-5`
```bash
$ apt search libevent-openssl
Sorting... Done
Full Text Search... Done
libevent-openssl-2.0-5/xenial-updates,xenial-security,now 2.0.21-stable-2ubuntu0.16.04.1 amd64 [installed]
  Asynchronous event notification library (openssl)
```
```
gcc bufferevent_ssl.c -lssl -lcrypto -levent -levent_openssl
./a.out
```
由于ssl需要密钥,证书,第一次运行会失败,按照屏幕提示生成证书. 中间第二步骤会要求输入一些信息,一路回车即可
### 测试
待补充