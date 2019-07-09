---
title: bind中基数树的建立
date: 2018-03-15 20:23:55
tags: [radix tree]
categories: code
---

BIND9新引入了视图的概念，简单的来讲就是能根据不同的来源IP来返回不同的数据。其中网段的存储，网段的快速匹配都是用基数树来实现的。下面是BIND创建基数树的代码。

### 相关结构体

BIND的IP地址结构

```c
struct isc_netaddr {
	unsigned int family;
	union {
		struct in_addr in;
		struct in6_addr in6;
#ifdef ISC_PLATFORM_HAVESYSUNH
		char un[sizeof(((struct sockaddr_un *)0)->sun_path)];
#endif
	} type;
	isc_uint32_t zone;
};
```

<!-- more -->

BIND 二叉树中表示网段的结构，该结构由sturct in_addr结构处理转换而来， bitlen表示掩码位

```c
typedef struct isc_prefix {
    unsigned int family;	/* AF_INET | AF_INET6, or AF_UNSPEC for "any" */
    unsigned int bitlen;	/* 0 for "any" */
    isc_refcount_t refcount;
    union {
		struct in_addr sin;
		struct in6_addr sin6;
    } add;
} isc_prefix_t;
```

IP结构转换为节点结构
```c
#define NETADDR_TO_PREFIX_T(na,pt,bits) \
	do { \
		memset(&(pt), 0, sizeof(pt)); \
		if((na) != NULL) { \
			(pt).family = (na)->family; \
			(pt).bitlen = (bits); \
			if ((pt).family == AF_INET6) { \
				memcpy(&(pt).add.sin6, &(na)->type.in6, \
				       ((bits)+7)/8); \
			} else \
				memcpy(&(pt).add.sin, &(na)->type.in, \
				       ((bits)+7)/8); \
		} else { \
			(pt).family = AF_UNSPEC; \
			(pt).bitlen = 0; \
		} \
		isc_refcount_init(&(pt).refcount, 0); \
	} while(0)
```

节点结构，其中的bit表示网段的掩码位，决定着redix tree的结构，redix tree的插入和匹配过程都会用到它

```c
typedef struct isc_radix_node {
   isc_uint32_t bit;			/* bit length of the prefix */
   isc_prefix_t *prefix;		/* who we are in radix tree */
   struct isc_radix_node *l, *r;	/* left and right children */
   struct isc_radix_node *parent;	/* may be used */
   void *data[2];			/* pointers to IPv4 and IPV6 data */
   int node_num[2];			/* which node this was in the tree,
					   or -1 for glue nodes */
} isc_radix_node_t;

```
根节点结构
```c
typedef struct isc_radix_tree {
   unsigned int		magic;
   isc_mem_t		*mctx;
   isc_radix_node_t 	*head;
   isc_uint32_t		maxbits;	/* for IP, 32 bit addresses */
   int num_active_node;			/* for debugging purposes */
   int num_added_node;			/* total number of nodes */
} isc_radix_tree_t;
```



### 函数

插入节点函数，其中redix是树的根节点，prefix是要插入的节点。

```c
isc_result_t
isc_radix_insert(isc_radix_tree_t *radix, isc_radix_node_t **target,
		 isc_radix_node_t *source, isc_prefix_t *prefix)
{
```

从根节点开始往下搜寻插入位置，bitlen是新插入节点的掩码位。addr是4字节的char型字符串，占32位， 存储着要插入的节点IP地址。根据bit，addr来查找“插入位置”: 判断addr的第bit位是不是为1，如果是，则与右节点进行比较，否则与左节点进行比较。直到匹配到bit值大于或者等于bitlen的叶节点。（内部节点的IP是网段的中间值，比如网段是192.168.8.0/24,那么节点的ip就是192.168.8.128, 比较时先假设网段相同，IP小的在左边，IP大的在右边）



```c
while (node->bit < bitlen || node->prefix == NULL) {
	if (node->bit < radix->maxbits &&
	    BIT_TEST(addr[node->bit >> 3], 0x80 >> (node->bit & 0x07)))
	{
		if (node->r == NULL)
			break;
		node = node->r;
	} else {

		if (node->l == NULL)
			break;
		node = node->l;
	}
	
	INSIST(node != NULL);
}
```
比较新节点和node，找到第一个不同的位

```c
/* Find the first bit different. */
check_bit = (node->bit < bitlen) ? node->bit : bitlen;
differ_bit = 0;

for (i = 0; i*8 < check_bit; i++) {
	if ((r = (addr[i] ^ test_addr[i])) == 0) {

		differ_bit = (i + 1) * 8;
		continue;
	}
	/* I know the better way, but for now. */
	for (j = 0; j < 8; j++) {
		if (BIT_TEST (r, (0x80 >> j)))
			break;
	}
	/* Must be found. */
	INSIST(j < 8);
	differ_bit = i * 8 + j;
	break;
}
```
如果differ_bit小于node->parent->bit，说明新节点和node不在同一个网段，node节点上移，直到node和新节点 同处于node的父节点网段下

```c
if (differ_bit > check_bit)
	differ_bit = check_bit;

parent = node->parent;
while (parent != NULL && parent->bit >= differ_bit) {
	node = parent;
	parent = node->parent;
}
```
下面就分情况，具体就是确定父节点，子节点 和为节点的prefix赋值

1、  新节点和node是同一网段
```c
if (differ_bit == bitlen && node->bit == bitlen) {
    ......
}
```
2、 新节点是node的子网段

```c
if (node->bit == differ_bit) {
    ......
}
```
3、 node是新节点的子网段

```c
if (bitlen == differ_bit) {
    ......
}
```
4、新节点和node是两个不相关的网段 




