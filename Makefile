NAME=greptweet
REPO=hendry/$(NAME)

.PHONY: start stop build sh

all: build

build:
	git describe --always > www/version.txt
	docker build -t $(REPO) .

start:
	#docker run --rm -it --name $(NAME) -v /mnt/raid1/greptweet:/srv/http/u -v $(PWD)/www:/srv/http/ -v $(PWD)/logs:/var/log/nginx/ -p 81:80 $(REPO)
	docker run --rm -it --name $(NAME) --env-file envfile -v /tmp/g:/srv/http/u -p 81:80 $(REPO)

sh:
	docker exec -it $(NAME) /bin/sh
