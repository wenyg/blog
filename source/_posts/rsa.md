---
title: "RSA加密原理"
date: 2022-07-04 19:41:29
---


##  模运算

非对称加密解密所用到的一个非常重要的特性就是模运算不可逆

比如算 $ 3^3 \text{ } mod \text{ } 7 $ 的值， 很容易算出余数为 27 - 21 = 6 

但是知道 $ 3^{\color{green}{x}} \text{ } mod \text{ } 7 = 6 $， 然后求 $x$ 的值呢，那么就只能挨个去试了，但是如果式子中的数字稍微大那么一点，比如
$$
520^{\color{green}{x}} \text{ } mod \text{ } 1011 = 721
$$

再挨个去试就很不现实了。


试想有3个数字， ${\color{green}{e}},{\color{red}{d}}, {\color{blue}{n}}$ 满足下面的条件

$$
m^{\color{green}{e}} \text{ } mod \text{ } {\color{blue}{n}} = c \\\\
c^{\color{red}{d}} \text{ } mod \text{ } {\color{blue}{n}} = m
$$

m 可以表示是要加密的信息，c 表示加密后的密文， 那么就可以通过这个规则对信息进行加解密了，其中 


- $({\color{green}{e}}, {\color{blue}{n}})$ 用来当做 **公钥**
- $({\color{red}{d}}, {\color{blue}{n}})$ 用来当做 **私钥**

上面公式经过一些变化可以得到

$$
{m^{\color{green}{e}{\color{red}{d}}} \text{ } mod \text{ } {\color{blue}{n}} = m}
$$

如何选取这个 ${\color{green}{e}}$ 和 ${\color{red}{d}}$ 便成了非对称加密中的最关键的问题， 这就提到了欧拉定理

## 欧拉函数

讲欧拉定理前，先说下什么是欧拉函数  
对于正整数N, 欧兰函数 $\phi(n)$ 的值等于从 1 到 N 中与 N 互质的数的个数

> 互质: 如果两个整数它们的最大公约数为 1， 则这两个数互质。

比如

| 正整数 N    | 与 N 互质的数        | 欧拉函数值               |
|------------|--------------------|-------------------------|
| 2          | {1}                | $\phi(2)$ = 1           |
| 3          | {1, 2}             | $\phi(3)$ = 2           |
| 4          | {1, 3}             | $\phi(4)$ = 2           |
| 5          | {1, 2, 3, 4}       | $\phi(5)$ = 4           |
| 6          | {1, 5}             | $\phi(6)$ = 2           |
| 7          | {1, 2, 3, 4, 5, 6} | $\phi(7)$ = 6           |

对于质数来说, 小于它的数都与它互质，所以对于质数 $n$, 有 $\phi(n) = n - 1$ 


## 欧拉定理

对于互质的正整数 $m$、$n$，则 $m$ 的 $\phi{(n)}$ 次方与$1$同余，模为 $n$, 即

$$
m^{\phi(n)} \equiv 1 \text{ } (mod\text{ }{n}) 
$$

我们对公式进行一些简单的变换，等式两端同时取 $k$ 次幂, 即

$$
(m^{\phi(n)})^k = 1^k \text{ } (mod \text{ }n)
$$

等同于

$$
m^{k\phi(n)} = 1 \text{ } (mod \text{ }n)
$$

两端同时乘以 $m$
$$
m^{k\phi(n)} * m = 1 * m \text{ } (mod \text{ }n)
$$

再简化
$$
m^{k\phi(n)+1} = m \text{ } (mod \text{ }n)
$$

最后将模运算写在等式的左边
$$
m^{k\phi(n)+1}\text{ } mod \text{ }n = m 
$$

然后和之前的加解密公式对应起来
$$
{m^{\color{green}{e}{\color{red}{d}}} \text{ } mod \text{ } {\color{blue}{n}} = m}
$$

我们可以将 ${\color{red}{d}}$ 与 ${\color{green}{e}}$ 的关系表实证下面这种形式

$$
{\color{green}{e}}{\color{red}{d}} = k\phi({\color{blue}{n}})+1
$$

即

$$
{\color{red}{d}} = \frac{k\phi({\color{blue}{n}})+1}{\color{green}{e}}
$$

我们可以通过选取这里的 $k$，$\color{blue}{n}$，$\color{green}{e}$ 来计算用于解密的密钥 $\color{red}{d}$

前面讲欧拉函数的时候我们讲到，对于互质的数，有 $\phi(n) = n - 1$ , 除此之外欧拉函数还有一个重要的特性,对于互质的 $p$ 和 $q$
$$
\phi(p * q) = \phi(p) * \phi(q)
$$


我们选取 $p=3, q=11$ 因此 

$$
{\color{red}{d}} = \frac{k * 20+1}{\color{green}{e}}
$$

我们找一个与 $20$ 互斥的较小的数 $3$ 当做 $\color{green}{e}$, 然后尝试找满足等式的 ${\color{red}{d}}$，当 $k=1$的时候，存在 ${\color{red}{d}} = 7$ 满足条件，然后就可以把公钥 ${\color{green}{e}} = 3, {\color{blue}{n}} = 20$ 公布当做公钥，自己保留 ${\color{red}{d}} = 7$ 当做私钥。 

至此就生成了不容易被破解非对称的密钥。