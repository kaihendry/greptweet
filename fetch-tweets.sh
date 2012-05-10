#!/bin/bash
# vim: set ts=4 sw=4

umask 002
api="http://api.twitter.com/1/statuses/user_timeline.xml?"

if ! test "$1"
then
	echo -e "Please specify twitter username\n e.g. $0 kaihendry"
	exit 1
fi

twitter_total=$(curl -s "http://api.twitter.com/1/users/lookup.xml?screen_name=$1" |
xmlstarlet sel -t -m "//users/user/statuses_count" -v .)

if ! test "$twitter_total" -gt 0 2>/dev/null
then
	echo 'Twitter API not working' >&2
	exit 1
fi

page=1
saved=0

if test -s "$1.txt"
then
	saved=$(wc -l < "$1.txt")
	since='&since_id='$(head -n1 "$1.txt" | cut -d'|' -f1)
	test "$2" && since='&max_id='$(tail -n1 $1.txt | cut -d'|' -f1) # use max_id to get older tweets
fi

echo T:"$twitter_total" S:"$saved"
while test "$twitter_total" -gt "$saved" # Start of the important loop
do

echo $1 tweet total "$twitter_total" is greater than the already saved "$saved"
echo Trying to get $(($twitter_total - $saved))

temp=$(mktemp)
temp2=$(mktemp)

url="${api}screen_name=${1}&count=200&page=${page}${since}&include_rts=true&trim_user=1&include_entities=1"

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

mv $temp2 $temp

if test "$(xmlstarlet sel -t -v "count(//statuses/status)" $temp 2>/dev/null)" -eq 0
then
	head $temp | grep -q "Over capacity" && echo "Twitter is OVER CAPACITY"
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

shortDomains="t.co bit.ly tinyurl.com goo.gl"

xmlstarlet sel -t -m "statuses/status" -n -o "text " -v "id" -o "|" -v "created_at" -o "|" -v "normalize-space(text)" \
-m "entities/urls/url" -i "expanded_url != ''" -n -o "url " -v "url" -o " " -v "expanded_url" $temp | {

while read -r first rest
do
	case $first in
		"text") echo $text; text=$rest ;;
		"url")
			  set -- $(echo $rest)
			  finUrl=$2
			  domain=$(echo $finUrl | cut -d'/' -f3)
			  if [[ "$shortDomains" = *$domain* ]]
			  then
				finUrl=$(curl "$finUrl" -s -L -I -o /dev/null -w '%{url_effective}')
			  fi
			  text=$(echo $text | sed s,$1,$finUrl,g)
			;;
	esac
done
echo $text
} > $temp2

perl -MHTML::Entities -pe 'decode_entities($_)' < $temp2 > $temp
sed '/^$/d' < $temp > $temp2

if test -z $temp2
then
	echo $temp2 is empty
	rm -f $temp $temp2
	continue
fi

if test -f $1.txt
then
	mv $1.txt $temp
	before=$(wc -l < "$temp")
else
	before=0
	> $temp
fi

sort -r -n -u $temp $temp2 > "$1.txt"
rm -f $temp $temp2

after=$(wc -l < "$1.txt")
echo Before: $before After: $after

if test "$before" -eq "$after"
then
	echo Unable to retrieve anything new. Approximately $(( $twitter_total - $after)) missing tweets
	exit
fi

page=$(($page + 1))
saved=$(wc -l < "$1.txt")
echo $saved

done

echo $1 saved $saved tweets of "$twitter_total": You are up-to-date!
