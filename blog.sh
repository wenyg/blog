#!/bin/bash

case "$1" in
	p)
	docker run -it --rm \
		-v "$(pwd)"/source:/blog/source \
		-v "$(pwd)"/even:/blog/themes/even \
		-v $HOME/.ssh:/root/.ssh \
		--mount type=bind,source="$(pwd)"/_config.yml,target=/blog/_config.yml \
		--mount type=bind,source="$(pwd)"/gitconfig,target=/root/.gitconfig \
		hexo hexo d
		
	git add source/ even/ _config.yml
	git add Dockerfile blog.sh gitconfig README.md
	if [ -z $2 ]
	then
		git commit -m "Update"
	else
		git commit -m "$2"
	fi
	git push
	;;

	s)
	 docker run -it --rm -p 4000:4000 \
      -v "$(pwd)"/source:/blog/source \
      -v "$(pwd)"/even:/blog/themes/even \
      -v $HOME/.ssh:/root/.ssh \
      --mount type=bind,source="$(pwd)"/_config.yml,target=/blog/_config.yml \
      --mount type=bind,source="$(pwd)"/gitconfig,target=/root/.gitconfig \
      hexo hexo s
	;;
esac

exit 0
