#!/bin/bash

case "$1" in
	d)
	cname=$(cat CNAME)
	docker run -it --rm \
		--env CNAME=${cname} \
		-v "$(pwd)"/source:/blog/source \
		-v "$(pwd)"/themes/even:/blog/themes/even \
		-v $HOME/.ssh:/root/.ssh \
		--mount type=bind,source="$(pwd)"/_config.yml,target=/blog/_config.yml \
		--mount type=bind,source="$(pwd)"/gitconfig,target=/root/.gitconfig \
		--mount type=bind,source="$(pwd)"/CNAME,target=/root/CNAME \
		hexo sh -c 'hexo g && echo "$CNAME" > /blog/public/CNAME && hexo d'
	;;

	p)
	git add source/ themes/ _config.yml
	git add Dockerfile blog.sh gitconfig README.md CNAME
	if [ -z $2 ]
	then
		git commit -m "Update"
	else
		git commit -m "$2"
	fi
	git push origin master
	;;

	s)
	 docker run -it --rm -p 4000:4000 \
        -v "$(pwd)"/source:/blog/source \
		-v "$(pwd)"/themes/even:/blog/themes/even \
        -v $HOME/.ssh:/root/.ssh \
        --mount type=bind,source="$(pwd)"/_config.yml,target=/blog/_config.yml \
        --mount type=bind,source="$(pwd)"/gitconfig,target=/root/.gitconfig \
        hexo hexo s
	;;
esac

exit 0
