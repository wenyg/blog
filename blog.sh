#!/bin/bash

## 获取脚本自身所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

CONTAINER_BLOG_DIR="/blog"
NGINX_DIR=${SCRIPT_DIR}/../nginx-deploy/nginx/
case "$1" in
	serve)
		docker run -it --rm -d \
			--net=host \
			-v ${SCRIPT_DIR}/source:${CONTAINER_BLOG_DIR}/source \
			-v ${SCRIPT_DIR}/themes/even:${CONTAINER_BLOG_DIR}/themes/even \
			-v ${SCRIPT_DIR}/_config.yml:${CONTAINER_BLOG_DIR}/_config.yml \
			wenyg/blog /bin/bash -lic "hexo serve"
		;;
	# 启动 nginx

	run)
		docker run --rm  -d --net=host \
			--mount type=bind,source=${NGINX_DIR}/nginx.conf,target=/etc/nginx/nginx.conf \
			-v ${NGINX_DIR}/ssl:/etc/nginx/ssl \
			-v ${NGINX_DIR}/d:/d \
			nginx
	;;
esac

exit 0
