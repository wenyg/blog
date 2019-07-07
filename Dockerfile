FROM node:latest
RUN npm install -g cnpm --registry=https://registry.npm.taobao.org
RUN cnpm install hexo-cli hexo-server -g
RUN hexo init blog && cd blog && cnpm install \
    && cnpm install hexo-renderer-scss --save \
    && cnpm install hexo-deployer-git --save
RUN git config --global user.email "yg_wen@126.com" \
    && git config --global user.name "wenyg"
CMD /bin/bash
WORKDIR /blog
EXPOSE 4000