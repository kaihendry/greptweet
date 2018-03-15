# Greptweet

## Setup

Set `access_token` in envfile. You should be able to get it from [creating a new Twitter app](https://dev.twitter.com/apps/new).

	curl -X POST "https://api.twitter.com/oauth2/token" -d "grant_type=client_credentials" -u consumerKey:consumerSecret

	echo 'access_token=secret' > envfile
	docker run -d --restart=unless-stopped -v /mnt/raid1/greptweet/:/srv/http/u --name greptweet --env-file envfile -p 8888:80 hendry/greptweet

## Maintenance

Backing it up:

	docker cp greptweet:/srv/http/u/ /tmp/backup
