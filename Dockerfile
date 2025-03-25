FROM node:latest
RUN npm install -g cnpm --registry=https://registry.npmmirror.com
RUN cnpm install hexo-cli hexo-server -g
RUN hexo init blog && cd blog && cnpm install \
    && cnpm install hexo-renderer-scss --save \
    && cnpm install hexo-deployer-git --save
RUN cd /blog && cnpm install hexo-generator-search --save
CMD /bin/bash
WORKDIR /blog
EXPOSE 4000