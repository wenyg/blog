# BLOG

这是一个基于 [docker](https://www.docker.com/) 的 [hexo](https://hexo.io/zh-cn/) 博客环境，博客主题是 [even](https://github.com/ahonn/hexo-theme-even)。你只需要安装一个docker，就可以快速的搭建一个博客，并且随时随地在任何地方更新博客。

## 构建hexo镜像

构建hexo镜像，镜像里已经封装了搭建博客所需要的一切东西。构建镜像需要一些时间。

``` bash
git clone https://github.com/wenyg/blog.git
cd blog
sudo docker build -t hexo .
```

如果build花费太多时间， 你也可以用下面这种方法

``` bash
docker pull wenyg/blog
docker tag wenyg/blog hexo
```

## 使用说明

`blog.sh`是一个shell脚本，把docker的用法封装了进去，这样你不会docker也可以轻松的操作博客。

1. 本地预览博客

    ```bash
    ./blog.sh s
    INFO  Start processing
    INFO  Hexo is running at http://localhost:4000 . Press Ctrl+C to stop.
    ```

2. 部署博客到github pages。(自行创建username.github.io仓库，配置ssh key，修改_config.yml中仓库配置)

    ```bash
    ./blog.sh d
    ```

3. 更新源文章到git仓库

    ```bash
    ./blog.sh p
    ```
    

## 目录介绍

仓库下的所有文件都可以自己进行修改定制。

写博客

- `source`: 博客目录，所写的博客基本上都放在此目录下的`_post`目录下，以后要是添加新文章只需要把markdown文件放到此目录即可

一般有两个配置文件需要修改

- `_config.yml` ： hexo的配置文件，包括站点设置，部署设置等等，具体查看 [hexo配置](https://hexo.io/zh-cn/docs/configuration)
- `gitconfig` :  pages仓库中显示的name，email。
- `CNAME` : 为pages可以通过别名访问，前提是要让你的CNAME指向github.io, 如果没有自己的域名，则把CNAME清空，或者在 `blog.sh` 中吧CNAME相关的启动参数去掉，否者会导致pages页面无法访问。

其它的文件可改可不改

- `themes`: 主题目录，里面的是 [even](https://github.com/ahonn/hexo-theme-even) 主题，是个人比较喜欢的主题，所以也封装到镜像中了
- `Dockerfile` : 构建docker镜像的脚本
- `blog.sh` : 博客部署脚本

## 相关连接

[Winn's blog](https://wenyg.github.io), 该仓库生成的博客网站

[菜鸟教程](https://www.runoob.com/docker/ubuntu-docker-install.html) docker安装教程

[Docker文档](https://docs.docker.com/) docker官方教程

[even配置文档](https://hexo.io/zh-cn/docs/configuration), 只需关注设置部分即可