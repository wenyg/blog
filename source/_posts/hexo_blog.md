---
title: hexo实现个人博客
date: 2017-07-05 20:21:48
tags: [hexo]
categories: 工具
---

### 安装依赖

```bash
sudo apt install nodejs
sudo apt install npm
npm install -g cnpm --registry=https://registry.npm.taobao.org
sudo apt install git
npm install hexo-cli -g
```

### hexo使用

```bash
hexo init blog
cd blog
npm install
hexo server
```

<!-- more -->

服务器启动之后就可以在浏览器里访问了<http://localhost:4000/>. 



### hexo配置

#### 更换主题

hexo 主题官网 <https://hexo.io/themes/> ，找到自己喜欢的主题，获取主题的github地址 ， 一般github上面有该主题的使用方法，下面是even主题的使用方法

```bash
npm install hexo-renderer-scss --save
git clone https://github.com/ahonn/hexo-theme-even themes/even
```

修改博客根目录下的 `_config.yml` 文件，把之前的 theme字段的值改为even

```
# Extensions
## Plugins: https://hexo.io/plugins/
## Themes: https://hexo.io/themes/
## theme: landscape
theme: even
```

重新启动服务就可以看到新主题了