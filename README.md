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
