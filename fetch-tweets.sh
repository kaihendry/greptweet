#!/bin/bash
# Twitter backup script - hendry AT iki.fi - please mail me suggestions to make this suckless
# http://dev.twitter.com/doc/get/statuses/user_timeline
# Known issues:
# API only allows 3200 tweets to be downloaded this way :((
# Won't work on protected accounts (duh!)
# No @mentions or DMs from other accounts

umask 002
api="http://api.twitter.com/1/statuses/user_timeline.xml?"

if ! test "$1"
then
	echo -e "Please specify twitter username\n e.g. $0 kaihendry"
	exit 1
fi

if ! twitter_total=$(curl -s "http://api.twitter.com/1/users/lookup.xml?screen_name=$1" | xmlstarlet sel -t -m "//users/user/statuses_count" -v .)
then
	curl "http://api.twitter.com/1/users/lookup.xml?screen_name=$1"
	echo not working
	exit
fi

page=1
saved=0
stalled=0

if test -s $1.txt
then
	saved=$(wc -l $1.txt | tail -n1 | awk '{print $1}')
	since='&since_id='$(head -n1 $1.txt | awk -F"|" '{ print $1 }')
	test "$2" && since='&max_id='$(tail -n1 $1.txt | awk -F"|" '{ print $1 }') # use max_id to get older tweets
fi

echo T:"$twitter_total" S:"$saved"
while test "$twitter_total" -gt "$saved" # Start of the important loop
do

echo $1 tweet total "$twitter_total" is greater than the already saved "$saved"
echo Trying to get $(($twitter_total - $saved))

# Don't like your annonymous var names here, makes the code difficult to read
temp=$(mktemp)
temp2=$(mktemp)
tmpURLs=$(mktemp)
tmpStats=$(mktemp)

# Don't want to have to alter this in two places
url="${api}screen_name=${1}&count=200&page=${page}${since}&include_rts=true&trim_user=1&include_entities=1"

# Have no idea what's going on with temp and temp2 from now on
echo "curl -s \"$url\""
curl -si "$url" > $temp
echo $?

{
{ while read -r
do
if test "$REPLY" = $'\r'
then
        break
else
        echo "$REPLY" >&2 # print header to stderr
fi
done
cat; } < $temp > $temp2
} 2>&1 | # redirect back to stdout for grep
grep -iE 'rate|status' # show the interesting twitter rate limits
# date --date='@1320361995'

mv $temp2 $temp

cat $temp

cstatus=$(xmlstarlet sel -t -v "count(//statuses/status)" $temp)
if test $cstatus -eq 0
then

        head $temp
        if test "$2" && test "$since"
        then
                echo No old tweets ${since}
        elif test "$since"
        then
                echo No new tweets ${since}
        else
                echo "Twitter is returning empty responses on page ${page} :("
        fi
        rm -f $temp $temp2
        exit

fi

echo "Parsing $cstatus status(es)"
xmlstarlet sel -t -m "//statuses/status" -v "id" -o "|" -v "created_at" -o "|" -v "normalize-space(text)" -n $temp > $tmpStats

cat $tmpStats

# Get long/short URLs preformatted for sed, have to specifically escape ampersands for sed.
xmlstarlet sel -t -m "//statuses/status/entities/urls/url" -o "s," -v "url" -o "," -v "expanded_url" -o ",g" -n $temp | sed "s,\&,\\\&,g" > $tmpURLs
# Replace short URLs with long URLs

if test -s $tmpURLs
then
	cat $tmpURLs
	# Each regex applied to the whole of the 200 line file? Can't be cheap ... :/
	cat $tmpURLs | xargs -0 -I {} sed '{}' $tmpStats > $temp2
else
	mv $tmpStats $temp2
fi

echo here
cat $temp2

cat $temp2 | perl -MHTML::Entities -pe 'decode_entities($_)' > $temp

echo here2
cat $temp

sed '/^$/d' $temp > $temp2

if test -z $temp2
then
	echo $temp2 is empty
	rm -f $temp $temp2
	continue
fi

#cat $temp2

if test -f $1.txt
then
	mv $1.txt $temp
	before=$(wc -l $temp | awk '{print $1}')
else
	before=0
	> $temp
fi

cat $temp $temp2 | sort -r -n | uniq | sed 's/[ \t]*$//' > $1.txt

after=$(wc -l $1.txt | awk '{print $1}')
echo Before: $before After: $after

if test "$before" -eq "$after"
then
	echo Uable to retrieve anything new. Approximately $(( $twitter_total - $after)) missing tweets
	rm -f $temp $temp2
	exit
fi

rm -f $temp $temp2
page=$(($page + 1))
saved=$(wc -l $1.txt | tail -n1 | awk '{print $1}')
echo $saved

done

echo $1 saved $saved tweets of "$twitter_total": You are uptodate!
