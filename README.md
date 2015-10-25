# <http://greptweet.com>

<a href="http://www.flickr.com/photos/hendry/7577182774/" title="Offline Greptweet on Chrome IOS by Kai Hendry, on Flickr"><img src="http://farm8.staticflickr.com/7133/7577182774_d5b654ea69_n.jpg" width="213" height="320" alt="Offline Greptweet on Chrome IOS"></a>

* Image VIRTUAL SIZE <100MB (Docker)
* Uses [HTML offline feature](http://www.whatwg.org/specs/web-apps/current-work/multipage/offline.html)
* Aims to [suck less](http://suckless.org) by keeping lines of code low
* Can run from command line
* **Please** review and comment on the code!

# Known limitations

* API only allows 3200 tweets to be downloaded this way at one time :(
* 300 API limit using a [Application only Auth](https://dev.twitter.com/docs/auth/application-only-auth) bearer token (which doesn't seem to expire...)
* Won't work on protected accounts (duh!)
* No @mentions or DMs from other accounts

# API

Invoke a fetch of a TWITTER_USERNAME by accessing the URL:

	http://greptweet.com/f/TWITTER_USERNAME

Last 4 tweets:

	curl --compressed -s http://greptweet.com/u/webconverger/tweets.txt | head

# Getting a Bearer Token

When you clone and attempt to run this opensource project you will notice that
you are missing a `secret.php` file, this file contains one setting
`$bearer_token`.  To [create a bearer
token](https://dev.twitter.com/docs/auth/application-only-auth):

1. [Create a new Twitter app](https://dev.twitter.com/apps/new)
1. Under OAuth settings, make a note of the **Consumer key** and **Consumer secret**
1. Now retrieve the bearer token by building a request with curl:


	curl -X POST --verbose "https://api.twitter.com/oauth2/token" -d "grant_type=client_credentials" -u consumerKey:consumerSecret

The response should end like:

	{"access_token":"SECRETEXAMPLESTRING","token_type":"bearer"}

Save that SECRETEXAMPLESTRING to www/secret.php:

	<?php
	$bearer_token = 'SECRETEXAMPLESTRING';
	?>
