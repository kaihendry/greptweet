build:
	git describe --always > www/version.txt
	docker build -t greptweet .

test:
	docker run -v /srv/www/greptweet.com:/srv/http/u -p 81:80 -t -i greptweet
