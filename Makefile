NAME=greptweet
REPO=hendry/$(NAME)

.PHONY: start stop build sh

all: build

build:
	git describe --always > www/version.txt
	docker build -t $(REPO) .

start:
	docker run -d --name $(NAME) -v /mnt/2tb/greptweet/:/srv/http/u -v $(PWD)/www:/srv/http/ -v $(PWD)/logs:/var/log/nginx/ -p 81:80 $(REPO)

stop:
	docker stop $(NAME)
	docker rm $(NAME)

sh:
	docker exec -it $(NAME) /bin/sh
