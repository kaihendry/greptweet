NAME=greptweet
REPO=hendry/$(NAME)

.PHONY: start stop build sh

all: build

build:
	git describe --always > www/version.txt
	docker build -t $(REPO) .

start:
	docker run -d --name $(NAME) -v /srv/www/greptweet.com:/srv/http/u -p 81:80 $(REPO)

stop:
	docker stop $(NAME)

sh:
	docker exec -it $(NAME) /bin/sh