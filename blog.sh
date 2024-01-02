#!/bin/bash

## 获取脚本自身所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

CONTAINER_BLOG_DIR="/blog"
case "$1" in
	# 生成 html 资源文件到 nginx-deploy/html 目录
	gen)
		docker run -it --rm \
			-v ${SCRIPT_DIR}/source:${CONTAINER_BLOG_DIR}/source \
			-v ${SCRIPT_DIR}/themes/even:${CONTAINER_BLOG_DIR}/themes/even \
			-v ${SCRIPT_DIR}/_config.yml:${CONTAINER_BLOG_DIR}/_config.yml \
			-v ${SCRIPT_DIR}/nginx-deploy/html/:${CONTAINER_BLOG_DIR}/public/ \
			hexo /bin/bash -lic "hexo g"
			#hexo /bin/bash -lic "hexo g && cp -fr public/* /html/"
		;;
	serve)
		docker run -it --rm \
			--net=host \
			-v ${SCRIPT_DIR}/source:${CONTAINER_BLOG_DIR}/source \
			-v ${SCRIPT_DIR}/themes/even:${CONTAINER_BLOG_DIR}/themes/even \
			-v ${SCRIPT_DIR}/_config.yml:${CONTAINER_BLOG_DIR}/_config.yml \
			-v ${SCRIPT_DIR}/nginx-deploy/html/:${CONTAINER_BLOG_DIR}/public/ \
			hexo /bin/bash -lic "hexo serve"
			#hexo /bin/bash -lic "hexo g && cp -fr public/* /html/"
		;;
	# 启动 nginx
	run)
		NGINX_DEPLOY_DIR=${SCRIPT_DIR}/nginx-deploy
		docker run --rm -d --net=host \
			-v ${NGINX_DEPLOY_DIR}/nginx.conf:/etc/nginx/nginx.conf \
			-v ${NGINX_DEPLOY_DIR}/ssl:/etc/nginx/ssl \
			-v ${NGINX_DEPLOY_DIR}/d:/d \
			nginx
	;;
esac

exit 0
