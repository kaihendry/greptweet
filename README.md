# <http://greptweet.com>

<a href="http://www.flickr.com/photos/hendry/9284645632/" title="Greptweet by Kai Hendry, on Flickr"><img src="http://farm4.staticflickr.com/3790/9284645632_6e5fc45fd9_n.jpg" width="180" height="320" alt="Greptweet"></a>

* Uses [HTML offline feature](http://www.whatwg.org/specs/web-apps/current-work/multipage/offline.html)
* Aims to [suck less](http://suckless.org) by keeping lines of code low
* Dependencies: PHP, curl
* Look and feel by <http://twitter.github.com/bootstrap>
* **Please** review and comment on the code!

# Known limitations

* API only allows 3200 tweets to be downloaded this way :(
* 300 API limit using a [Application only Auth](https://dev.twitter.com/docs/auth/application-only-auth) bearer token (which doesn't seem to expire...)
* Won't work on protected accounts (duh!)
* No @mentions or DMs from other accounts

# API

Fetch your tweets manually by accessing the URL:

	http://greptweet.com/f/TWITTER_USERNAME

Last 4 tweets:

	curl -s http://greptweet.com/u/webconverger/tweets.txt | head -n4

# Getting a Bearer Token

When you clone and attempt to run this project you will notice that you are missing a `secrets.php` 
file, this file contains one setting `$bearer`. To 
[create a bearer token](https://dev.twitter.com/docs/auth/application-only-auth):

1. [Create a new Twitter app.](https://dev.twitter.com/apps/new)
1. Base64 encode your key and secret separated by a colon, eg: key:secret => a2V5OnNlY3JldA==
1. Add the result to the Authorization header:
<pre>
    wget --post-data=grant_type=client_credentials \
        --header='Authorization: Basic **BASE64HERE**' \
        --header='Content-Type: application/x-www-form-urlencoded;charset=UTF-8' \
        https://api.twitter.com/oauth2/token
</pre>
