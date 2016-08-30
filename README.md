# Greptweet

## Setup

Set `access_token` in envfile. You should be able to get it from [creating a new Twitter app](https://dev.twitter.com/apps/new).

	curl -X POST "https://api.twitter.com/oauth2/token" -d "grant_type=client_credentials" -u consumerKey:consumerSecret

	echo 'access_token=secret' > envfile
	docker run -d --name greptweet --env-file envfile -p 8888:80 hendry/greptweet

# Maintenance

Running it again:

	docker start greptweet

Backing it up:

	docker cp greptweet:/srv/http/u/ /tmp/backup
