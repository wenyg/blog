# blog

这是一个基于docker的hexo博客环境，博客主题是even。利用docker可以快速的搭建一个个人博客。

## BUILD

构建docker， 具体操作可以在`Dockerfile`中查看，build镜像的时候会现在本地寻找基础镜像，找不到就会去Dokcer Hub中下载，第一次需要花费一些时间，之后就不需要了

``` bash
git clone https://github.com/wenyg/blog.git
cd blog
sudo docker build -t hexo .
```

## 使用说明
启动博客
```
$ sudo ./blog.sh s
INFO  Start processing
INFO  Hexo is running at http://localhost:4000 . Press Ctrl+C to stop.
```
部署博客
```
./blog.sh p "update blog"
```

## 目录介绍

- `even`: even主题，是个人比较喜欢的主题，所以也封装到镜像中了
- `source`: 博客目录，所写的博客基本上都放在此目录下的`_post`目录下，以后要是添加新文章只需要把markdown文件放到此目录即可
- `_config.yml` : hexo的配置文件,配置个人github pages地址，博客设置等
- `Dockerfile` : 构建docker镜像的脚本
- `blog.sh` : 博客部署脚本，可以自行查看
- `gitconfig` : git配置文件，docker中部署博客到pages用到

## 相关连接

[Winn's blog](https://wenyg.github.io), 该仓库生成的博客网站