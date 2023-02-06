---
title: C语言发送http请求
date: 2017-10-22 20:33:21
tags: [http]
categories: 废话少说,放码过来
---

C语言发送http请求和普通的socket通讯,原理是一样的.无非就三步connect()连上服务器,send()发送数据,recv()接收数据.只不过发送的数据有特定的格式.下面的是简单发送一个http请求的例子

<!-- more -->

```
#include <netinet/in.h>
#include <sys/socket.h>
#include <netdb.h>

#include <unistd.h>
#include <string.h>
#include <stdio.h>
int main(int argc, char **argv)
{
	/* 构造查询包 */
	const char quary[] = 
	"GET / HTTP/1.0\r\n"
	"Host: blog.csdn.net\r\n"
	"\r\n";

	const char hostname[] = "blog.csdn.net";
	struct sockaddr_in sin;
	struct hostent *h;
	const char *cp;
	int fd;
	ssize_t n_written, remaining;
	char buf[1024];

	/* 查找该域名的地址 */ 
	h = gethostbyname(hostname);
	if(h == NULL)
	{
		fprintf(stderr, "Couldn't lookup %s:%s\n", hostname, hstrerror(h_errno));
		return 1;
	}
	if (h->h_addrtype != AF_INET)
	{
		fprintf(stderr, "No ipv6 support, sorry.\n");
		return 1;
	}

	/* 创建一个套接字用来连接服务器 */
	fd = socket(AF_INET, SOCK_STREAM, 0);
	if (fd < 0)
	{
		perror("socket");
		return 1;
	}

	/* 连接到服务器 */
	sin.sin_family = AF_INET;
	sin.sin_port = htons(80);
	sin.sin_addr = *(struct in_addr*)h->h_addr;
	if (connect(fd, (struct sockaddr *)&sin, sizeof(sin)))
	{
		perror("connect");
		close(fd);
		return 1;
	}

	/* 发送请求 */
	cp = quary;
	remaining = strlen(quary);
	while(remaining)
	{
		n_written = send(fd,cp, remaining, 0);
		if (n_written <= 0)
		{
			perror("send");
			return 1;
		}
		remaining -= n_written;
		cp += n_written;
	}

	/* 获取响应 */
	while(1)
	{
		ssize_t result = recv(fd, buf, sizeof(buf), 0);
		if (result == 0)
		{
			break;
		}
		else if (result < 0)
		{
			perror("recv\n");
			close(fd);
			return 1;
		}
		fwrite(buf, 1, result, stdout);
	}
	close(fd);
	return 0;
}
```
