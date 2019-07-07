这是一个基于docker的hexo博客环境，博客主题是even。利用docker可以快速的搭建一个个人博客 
### BUILD
构建docker
```
$ git clone https://github.com/wenyg/blog.git
$ sudo docker build -t hexo -f blog/Dockerfile .
```
### 使用说明
1. 启动博客
```
$ cd blog
$ sudo docker run -it --rm -p 80:4000 \
      -v "$(pwd)"/source:/blog/source \
      -v "$(pwd)"/even:/blog/themes/even \
      -v $HOME/.ssh:/root/.ssh \
      --mount type=bind,source="$(pwd)"/_config.yml,target=/blog/_config.yml \
      hexo hexo s
```
启动完之后便可以在浏览器中访问了
2. 关闭博客
```
sudo docker stop hexo 
```
之后便可以访问博客了
### 目录介绍
- `even`: even主题，是个人比较喜欢的主题，所以也封装到镜像中了
- `source`: 博客目录，所写的博客基本上都放在此目录下的`_post`目录下，以后要是添加新文章只需要把markdown文件放到此目录即可
- `_config.yml` : hexo的配置文件
- `Dockerfile` : 构建docker镜像的脚本