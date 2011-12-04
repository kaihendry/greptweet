# <http://greptweet.com>

* Authentication free, using <http://dev.twitter.com/doc/get/statuses/user_timeline>
* Aim to [suckless](http://suckless.org) by keeping LOC low
* Encourage folks to use `fetch-tweets.sh` themselves and get into shell ;)
* Dependencies: curl, libhtml-parser-perl (to decode HTML entities), xmlstarlet, coreutils
* Look and feel mostly by <http://twitter.github.com/bootstrap/>

# Known issues

* API only allows 3200 tweets to be downloaded this way :((
* 150 API limit on the server ... (so clone it and use it yourself!)
* Won't work on protected accounts (duh!)
* No @mentions or DMs from other accounts

## Fetching already!

Closing a tab whilst creating an account,
<http://greptweet/create.cgi?id=example>, can cause issues. Need to study
<http://mywiki.wooledge.org/ProcessManagement>.

## Twitter can be flaky

Twitter does not allow the possibility of retrieving more than 3200 tweets.
However twitter generally stalls before coming close to this limit. Please
consider complaining to Twitter about this issue.

Type your name again up in the box above to update and append any new tweets
to any already existing tweets.

I did file <https://dev.twitter.com/discussions/3414>, which later seemed to be fixed.

# Shell script feedback (progressive loading) on the Web is quite tricky

<http://stackoverflow.com/questions/3547488>

Simple approaches tried:

* Outputting more than one should (doesn't work actually)
* Different newer servers of Apache seem to do transfer chunking better

Our host is limited by a "stable" version of Apache.
