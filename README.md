# <http://greptweet.com>

<a href="http://www.flickr.com/photos/hendry/7577182774/" title="Offline Greptweet on Chrome IOS by Kai Hendry, on Flickr"><img src="http://farm8.staticflickr.com/7133/7577182774_d5b654ea69_m.jpg" width="160" height="240" alt="Offline Greptweet on Chrome IOS"></a>

* Uses [HTML offline feature](http://www.whatwg.org/specs/web-apps/current-work/multipage/offline.html)
* Authentication free, using <http://dev.twitter.com/doc/get/statuses/user_timeline>
* Aims to [suck less](http://suckless.org) by keeping lines of code low
* Encourage folks to use `fetch-tweets.sh` themselves and get into shell ;)
* Dependencies: curl, libhtml-parser-perl (to decode HTML entities), xmlstarlet, coreutils, PHP
* Look and feel mostly by <http://twitter.github.com/bootstrap>
* **Please** review and comment on the code!

# Known limitations

* API only allows 3200 tweets to be downloaded this way :((
* 150 API limit on the server ... (so clone it and use it yourself!)
* Won't work on protected accounts (duh!)
* No @mentions or DMs from other accounts

# Local or server ?

What is faster? Using `grep.php` or just doing it via Javascript (we could drop PHP then!)?

# Shell script feedback on the Web works by disabling Apache's mod_deflate !

<http://stackoverflow.com/a/9022823/4534>

There is a problem whereby if the page is killed whilst fetching, the lock isn't cleared then and there because `trap` does not seem to work.

Make sure your httpd does utf8 all the time:

	AddDefaultCharset utf-8
