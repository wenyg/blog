FROM node:latest
RUN npm install -g cnpm --registry=https://registry.npm.taobao.org
RUN cnpm install hexo-cli hexo-server hexo-deployer-git -g
RUN hexo init blog && cd blog && cnpm install \
    && cnpm install hexo-renderer-scss --save
CMD /bin/bash
WORKDIR /blog
EXPOSE 4000