# <http://greptweet.com>

* Authentication free, using <http://dev.twitter.com/doc/get/statuses/user_timeline>
* Aim to [suckless](http://suckless.org) by keeping lines of code low
* Encourage folks to use `fetch-tweets.sh` themselves and get into shell ;)
* Dependencies: curl, libhtml-parser-perl (to decode HTML entities), xmlstarlet, coreutils, PHP
* Look and feel mostly by <http://twitter.github.com/bootstrap/>
* **Please** review and comment on the code!

# Known limitations

* API only allows 3200 tweets to be downloaded this way :((
* 150 API limit on the server ... (so clone it and use it yourself!)
* Won't work on protected accounts (duh!)
* No @mentions or DMs from other accounts

## Fetching already!

Closing a window whilst creating an account,
<http://greptweet/create.cgi?id=example>, can cause issues. Need to study
<http://mywiki.wooledge.org/ProcessManagement>.

## @twitterapi is super flaky

Twitter does not allow the possibility of retrieving more than 3200 tweets. :(
However twitter generally stalls before coming close to this limit. Please
consider complaining to Twitter about this issue.

Type your name again up in the box above to update and append any new tweets
to any already existing tweets.

I did file <https://dev.twitter.com/discussions/3414>, which later seemed to be fixed.

## Shell script feedback on the Web works by disabling Apache's mod_deflate !

<http://stackoverflow.com/a/9022823/4534>
