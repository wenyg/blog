# BLOG

[阳光的网络日志](https://www.winn.cc)

这是一个基于 [docker](https://www.docker.com/) 的 [hexo](https://hexo.io/zh-cn/) 博客环境，博客主题是 [even](https://github.com/ahonn/hexo-theme-even)。

博客地址: 

## 构建hexo镜像

构建hexo镜像，镜像里已经封装了搭建博客所需要的一切东西。构建镜像需要一些时间。

``` bash
git clone https://github.com/wenyg/blog.git
cd blog
sudo docker build -t hexo .
```

## 使用说明

```
hexo)
	BLOG_DIR="/home/wenyg/workspace/blog"
	CONTAINER_BLOG_DIR="/blog"
	docker run $DOCKER_RUN_FLAGS --name hexo \
		-v ${BLOG_DIR}/source:${CONTAINER_BLOG_DIR}/source \
		-v ${BLOG_DIR}/themes/even:${CONTAINER_BLOG_DIR}/themes/even \
		-v ${BLOG_DIR}/_config.yml:${CONTAINER_BLOG_DIR}/_config.yml \
		-p 4000:4000 \
		wenyg/blog /bin/bash -lic "hexo serve"
	;;
```

## 目录说明

- `source`: 博客目录，所写的博客基本上都放在此目录下的`_post`目录下，添加新文章只需要把markdown文件放到此目录即可
- `_config.yml` ： hexo的配置文件，包括站点设置，部署设置等等，具体查看 [hexo配置](https://hexo.io/zh-cn/docs/configuration)
- `themes`: 主题目录，里面的是 [even](https://github.com/ahonn/hexo-theme-even) 主题
- `Dockerfile` : 构建docker镜像的脚本
- `blog.sh` : 博客部署脚本